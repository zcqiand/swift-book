import SwiftUI
import SwiftData

struct SettingsView: View {
    // 整个设置页共享一个同步引擎实例，保证同步状态一致。
    private let syncEngine = NoteSyncEngine()

    @State private var statusText = "尚未同步"
    @State private var isSyncing = false

    var body: some View {
        // SettingsView 自带 NavigationStack（第 35 章既定），不在 TabView 外包。
        NavigationStack {
            Form {
                Section("数据同步") {
                    Text(statusText)
                        .foregroundStyle(.secondary)
                    Button("立即同步") {
                        runSync()
                    }
                    .disabled(isSyncing) // 同步中禁用按钮，避免重复触发
                }
            }
            .navigationTitle("设置")
        }
    }

    private func runSync() {
        isSyncing = true
        // Task 把异步同步从同步的按钮回调中桥接出去；await 跨越 actor 边界，
        // 期间主线程不被阻塞，界面照常响应。
        Task {
            defer { isSyncing = false }
            // 真实项目里这里会先把本地 Note 转成 [NoteDTO] 快照再传入；
            // sync 是第 37 章既定的 async 方法（无返回值、不 throws）。
            await syncEngine.sync([])
            let count = await syncEngine.syncedCount
            if let date = await syncEngine.lastSyncedAt {
                statusText = "上次同步：\(date.formatted(date: .abbreviated, time: .shortened))，共 \(count) 条"
            }
        }
    }
}