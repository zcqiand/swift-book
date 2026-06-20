import Foundation
import SwiftData

// 模拟云端拉取：用 Task.sleep 模拟网络延迟，不发真实请求。
// 标记 throws，让调用方必须用 do/catch 处理失败（如超时、解析错误）。
func fetchRemoteNotes() async throws -> [NoteDTO] {
    // 模拟 800ms 网络往返；Task.sleep 不阻塞线程，仅挂起当前任务。
    try await Task.sleep(for: .milliseconds(800))

    // 模拟「偶发网络失败」的真实情况，触发调用方错误处理分支。
    if Bool.random() && false {
        // 此分支默认关闭（&& false），改成 true 即可演示失败路径。
        throw URLError(.timedOut)
    }

    // 返回几条假数据（id 固定，便于演示去重合并）。
    return [
        NoteDTO(id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
                title: "会议纪要", content: "Q3 规划讨论", updatedAt: .now, imageData: nil),
        NoteDTO(id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
                title: "购物清单", content: "牛奶、鸡蛋、面包", updatedAt: .now, imageData: nil),
        NoteDTO(id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!,
                title: "灵感", content: "做一个本地优先的笔记 App", updatedAt: .now, imageData: nil)
    ]
}

@MainActor
@Observable
final class SyncDemo {
    var statusText: String = "尚未同步"
    var displayedNotes: [NoteDTO] = []

    // 引擎是 actor，跨 await 安全持有；它本身管理自己的隔离状态。
    private let engine = NoteSyncEngine()

    // 入口方法在 @MainActor 上：UI 触发点天然在主线程。
    func startBackgroundSync() {
        statusText = "后台同步中…"

        // Task.detached 开一个不继承当前 actor 上下文的独立任务，
        // 用来模拟脱离主线程的后台拉取，避免占用主线程。
        Task.detached { [engine] in
            do {
                // 1) 后台拉取（耗时操作，远离主线程）
                let remote = try await fetchRemoteNotes()

                // 2) 交给 actor 安全合并：await 自动串行化，无需锁
                await engine.sync(remote)
                let merged = await engine.snapshot()
                let total = await engine.syncedCount

                // 3) 回主线程刷新 UI：用 MainActor.run 显式切回主隔离域，
                //    这是 Swift 6 结构化并发的标准做法，不用 DispatchQueue.main.async。
                await MainActor.run {
                    self.displayedNotes = merged.sorted { $0.updatedAt > $1.updatedAt }
                    self.statusText = "同步完成，共 \(total) 条"
                }
            } catch {
                // 拉取失败（如超时）走这里，同样回主线程更新状态，保证 UI 不卡在「同步中」。
                await MainActor.run {
                    self.statusText = "同步失败：\(error.localizedDescription)"
                }
            }
        }
    }
}