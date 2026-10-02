import Foundation

// 反例：普通 class 是引用类型，多个 Task 拿到同一实例的同一块内存。
// count += 1 实际是「读-改-写」三步，多个线程交错执行会丢失更新，
// 这就是数据竞争。Swift 6 语言模式默认不允许把它跨域共享，
// 因此这里用 @unchecked Sendable 强行「骗过」编译器，仅为演示运行期后果。
final class UnsafeSyncStore: @unchecked Sendable {
    private var cache: [UUID: NoteDTO] = [:]
    var count: Int = 0

    // 没有任何串行化保护：并发调用时 cache 与 count 的修改会互相踩踏。
    func unsafeSync(_ notes: [NoteDTO]) {
        for note in notes {
            cache[note.id] = note   // 字典并发写是未定义行为，可能直接崩溃
            count += 1              // 非原子自增，并发下结果小于预期
        }
    }
}

// 演示用：故意从 1000 个并发任务调用反例存储，观察竞争。
func demonstrateUnsafeRace() async {
    let store = UnsafeSyncStore()
    let sample = NoteDTO(id: UUID(), title: "race", content: "x", updatedAt: .now, imageData: nil)

    await withTaskGroup(of: Void.self) { group in
        for _ in 0..<1000 {
            group.addTask {
                // 多个任务同时写同一个 store，制造竞争窗口。
                store.unsafeSync([sample])
            }
        }
    }
    // 预期：count 往往小于 1000，且开 Thread Sanitizer 会报 data race。
    print("UnsafeSyncStore.count = \(store.count) (期望 1000，实际常常更小或崩溃)")
}