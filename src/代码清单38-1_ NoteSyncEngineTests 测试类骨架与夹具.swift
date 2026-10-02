import XCTest

// @testable 会以「testable import」方式链接 NotesApp，
// 让测试能访问被测模块里 internal 级别的类型与成员（如 NoteSyncEngine 的方法），
// 无需为了测试而把它们提升为 public，从而避免污染对外 API 表面。
@testable import NotesApp

final class NoteSyncEngineTests: XCTestCase {

    // engine 是 actor 类型，这里只声明引用（隐式解包可选），
    // 真正的实例在每个测试前由 setUp 重建，确保测试之间状态隔离。
    var engine: NoteSyncEngine!

    // 同步版 setUp 用于不涉及并发/异步的基础准备。
    // 这里把可选属性显式置空，作为「实例应在 async setUp 中重建」的契约说明。
    override func setUp() {
        super.setUp()
        engine = nil
    }

    // async 版 setUp 在每个测试方法执行前运行，创建全新的 NoteSyncEngine。
    // 之所以每次重建，是因为 actor 持有可变的 localCache / syncedCount，
    // 若复用同一实例，前一个测试写入的缓存会污染后续断言。
    override func setUp() async throws {
        try await super.setUp()
        engine = NoteSyncEngine()
    }

    // tearDown 在每个测试方法结束后释放 engine，
    // 让 ARC 尽早回收 actor 及其缓存，避免跨测试的隐性引用残留。
    override func tearDown() {
        engine = nil
        super.tearDown()
    }
}