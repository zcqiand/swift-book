extension NoteSyncEngineTests {

    func test_sync_withOlderNote_doesNotOverwrite() async {
        // 固定一个 id，让前后两次 sync 命中同一条缓存记录，从而触发合并策略。
        let noteID = UUID()
        let newerDate = Date(timeIntervalSince1970: 1_700_000_100)
        let olderDate = Date(timeIntervalSince1970: 1_700_000_000) // 比 newerDate 早 100 秒

        let newerNote = NoteDTO(id: noteID, title: "项目计划", content: "v2 最新内容", updatedAt: newerDate, imageData: nil)
        let olderNote = NoteDTO(id: noteID, title: "项目计划", content: "v1 过期内容", updatedAt: olderDate, imageData: nil)

        // 第一次写入新版本：缓存中不存在该 id，应写入并令计数变为 1。
        await engine.sync([newerNote])
        // 第二次写入旧版本：existing.updatedAt（newerDate）>= note.updatedAt（olderDate），
        // 命中跳过分支，既不覆盖也不增加计数。
        await engine.sync([olderNote])

        let snapshot = await engine.snapshot()

        // 用 XCTAssertTrue 验证一个组合布尔条件：
        // 缓存中存在该 id，且其 content 仍是新版本的内容（说明旧版本未把它覆盖）。
        let keptNewerContent = snapshot.contains { $0.id == noteID && $0.content == "v2 最新内容" }
        XCTAssertTrue(keptNewerContent, "同 id 旧版本不得覆盖已有的新版本内容")

        // 同一 id 只应占一条缓存。
        let cachedCount = await engine.cachedCount()
        XCTAssertEqual(cachedCount, 1, "同一 id 的两次 sync 仍只有 1 条缓存")

        // 第二次 sync 走跳过分支，不应再累加，计数应停在 1。
        let syncedCount = await engine.syncedCount
        XCTAssertEqual(syncedCount, 1, "旧版本被跳过，同步计数不应增加")
    }
}