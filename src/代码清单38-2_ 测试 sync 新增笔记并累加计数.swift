extension NoteSyncEngineTests {

    func test_sync_addsNewNotes_increasesCount() async {
        // 构造三条 id 各不相同的笔记。id 不同意味着它们都属于「缓存中不存在」的情形，
        // 按合并策略应全部写入并各自令 syncedCount += 1。
        let baseDate = Date(timeIntervalSince1970: 1_700_000_000)
        let notes = [
            NoteDTO(id: UUID(), title: "会议纪要", content: "讨论排期", updatedAt: baseDate, imageData: nil),
            NoteDTO(id: UUID(), title: "购物清单", content: "牛奶与面包", updatedAt: baseDate, imageData: nil),
            NoteDTO(id: UUID(), title: "读书笔记", content: "第三章要点", updatedAt: baseDate, imageData: nil)
        ]

        await engine.sync(notes)

        // 访问 actor 的隔离属性 syncedCount 需要 await，
        // 三条全新笔记应使计数恰好为 3。
        let syncedCount = await engine.syncedCount
        XCTAssertEqual(syncedCount, 3, "三条新笔记应累加 3 次同步计数")

        // cachedCount() 是 actor 方法，返回 localCache 的条目数，
        // 三条不同 id 应得到 3 条缓存。
        let cachedCount = await engine.cachedCount()
        XCTAssertEqual(cachedCount, 3, "三条不同 id 的笔记应全部缓存")
    }
}