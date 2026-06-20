extension NoteSyncEngineTests {

    func test_sync_demonstratesRedFailure() async {
        let baseDate = Date(timeIntervalSince1970: 1_700_000_000)
        let notes = [
            NoteDTO(id: UUID(), title: "会议纪要", content: "讨论排期", updatedAt: baseDate, imageData: nil),
            NoteDTO(id: UUID(), title: "购物清单", content: "牛奶与面包", updatedAt: baseDate, imageData: nil),
            NoteDTO(id: UUID(), title: "读书笔记", content: "第三章要点", updatedAt: baseDate, imageData: nil)
        ]

        await engine.sync(notes)
        let syncedCount = await engine.syncedCount

        // 实际值为 3，这里故意期望 99。本断言会失败并让用例报红，
        // 用于演示 Xcode 26 测试导航器中失败用例的红色标记与失败详情。
        XCTAssertEqual(syncedCount, 99, "故意写错的期望值，运行后会报红")
    }
}