import Foundation

// 验证：100 个并发 Task 各 sync 一条不同笔记，结束后 syncedCount 必为 100。
// 若换成 UnsafeSyncStore，这个数字会不确定（常小于 100）。
func verifyActorConsistency() async {
    let engine = NoteSyncEngine()

    await withTaskGroup(of: Void.self) { group in
        for index in 0..<100 {
            group.addTask {
                // 每条用不同 id，确保 100 条都应被计入，便于断言精确值。
                let dto = NoteDTO(
                    id: UUID(),
                    title: "note-\(index)",
                    content: "content-\(index)",
                    updatedAt: .now,
                    imageData: nil
                )
                // await 让 actor 串行化所有这些并发写入。
                await engine.sync([dto])
            }
        }
    }

    let count = await engine.syncedCount
    let cached = await engine.cachedCount()
    // 预期 count == 100 且 cached == 100，每次运行都一致。
    print("Actor 版 syncedCount = \(count), cachedCount = \(cached) (期望均为 100)")
    assert(count == 100, "Actor 必须保证并发写入零丢失")
}