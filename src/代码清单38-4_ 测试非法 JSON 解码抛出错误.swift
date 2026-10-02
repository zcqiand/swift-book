extension NoteSyncEngineTests {

    // 仅用于测试的解码载荷：把网络/文件传来的 JSON 字段映射进来，
    // 与对外的 NoteDTO 解耦，这样 NoteDTO 无需为测试而被迫遵从 Decodable。
    private struct NoteDTOPayload: Decodable {
        let title: String
        let content: String
    }

    // 把 JSON Data 解码为 NoteDTO。decode 失败会向上抛出 DecodingError，
    // 这正是第 18 章 throws/try/do-catch 错误处理在测试中的应用对象。
    private func decodeNoteDTO(from json: Data) throws -> NoteDTO {
        let payload = try JSONDecoder().decode(NoteDTOPayload.self, from: json)
        // 解码成功后补齐 NoteDTO 必需但 JSON 未提供的字段，
        // 用客户端当前时间与新生成 id 完成构造。
        return NoteDTO(
            id: UUID(),
            title: payload.title,
            content: payload.content,
            updatedAt: .now,
            imageData: nil
        )
    }

    func test_decode_invalidJSON_throws() {
        // 一段结构非法的 JSON（花括号未闭合），JSONDecoder 解析时必然失败。
        let badData = Data(#"{"title": "断点测试", "content""#.utf8)

        // XCTAssertThrowsError 断言闭包内表达式确实抛错；
        // 尾随闭包进一步检查抛出的是预期的 DecodingError 而非其他类型。
        XCTAssertThrowsError(try decodeNoteDTO(from: badData)) { error in
            XCTAssertTrue(error is DecodingError, "非法 JSON 应抛出 DecodingError")
        }
    }
}