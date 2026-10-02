import Foundation

// actor 是引用类型，但它的存储属性被「actor 隔离」保护：
// 任何来自外部并发域的访问都必须 await，运行时自动把这些访问排成串行序列。
// 这是用「隔离」而非「加锁」来保证安全——调用方不会看到锁，也不可能忘记加锁。
actor NoteSyncEngine {
    // 本地缓存：以笔记 id 为键，O(1) 查找/覆盖，便于增量合并去重。
    private var localCache: [UUID: NoteDTO] = [:]
    // 累计成功处理的笔记条数，用于验证并发调用后状态是否一致。
    private(set) var syncedCount: Int = 0
    // 最后一次同步完成时间，反映引擎状态。
    private(set) var lastSyncedAt: Date?

    // sync 标记为 async：外部调用必须 await，actor 据此把多个调用串行化执行。
    // 即使 100 个 Task 同时调用，对 localCache/syncedCount 的修改也不会交错。
    func sync(_ notes: [NoteDTO]) async {
        for note in notes {
            // 合并策略：仅当远端版本更新（updatedAt 更晚）或本地不存在时才覆盖，
            // 避免用旧数据回退本地，这是同步引擎避免「数据倒退」的关键。
            if let existing = localCache[note.id], existing.updatedAt >= note.updatedAt {
                continue
            }
            localCache[note.id] = note
            syncedCount += 1
        }
        lastSyncedAt = .now
    }

    // 供外部只读快照当前缓存：返回值是 [NoteDTO]（Sendable），可安全带出 actor。
    func snapshot() -> [NoteDTO] {
        Array(localCache.values)
    }

    func cachedCount() -> Int {
        localCache.count
    }
}