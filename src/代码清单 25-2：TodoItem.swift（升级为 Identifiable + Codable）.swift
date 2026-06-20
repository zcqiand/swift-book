import Foundation

/// 待办项数据模型（项目一核心模型）。
///
/// 第 25 章变更：在第 24 章 Identifiable 基础上追加 Codable 协议。
/// 字段保持不变（id / title / isCompleted），不新增字段、不改名称。
/// 编译器看到所有存储属性都是标准 Codable 类型，会自动合成 encode / init(from:)，
/// 无需手写 CodingKeys——键名映射留到第 29 章网络 JSON 场景再展开。
struct TodoItem: Identifiable, Codable {
    // ── UUID 稳定性陷阱（建议读完这段注释） ──
    // 正确写法：id 是没有属性默认值的 let 存储属性。
    // 新建待办时，普通 init(id:title:isCompleted:) 的默认参数会生成 UUID；
    // 解码旧存档时，JSONDecoder 走 Codable 合成的 init(from:)，从 JSON 里解出 id。
    // 解码不会调用普通 init 的默认参数，所以不会重启后重新生成 id。
    //
    // 为什么要用存储属性？
    // List / ForEach 的差量更新依赖 Identifiable.id 判断「这一行是谁」。
    // id 跨重启稳定，重启后 List 才能正确识别「这一条还是上次那一条」，
    // 否则会把整个数组当成「全部变了」导致动画错乱、状态丢失。
    //
    // 严禁的写法：var id: UUID { UUID() }
    // 计算属性不参与存储：编码时不会写进 JSON，每次访问都新建一个 UUID。
    // 用这种写法，序列化/反序列化后 id 全变，差量更新彻底失效。
    let id: UUID

    var title: String

    // 沿用第 24 章命名 isCompleted，避免术语漂移。
    // 默认 false 放在普通 init 的参数里，而不是属性声明上。
    var isCompleted: Bool

    init(id: UUID = UUID(), title: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}

// MARK: - 验证：编码 → 解码后 id 仍相等

let encoder = JSONEncoder()
let decoder = JSONDecoder()

let original: [TodoItem] = [
    TodoItem(title: "买菜"),
    TodoItem(title: "写周报", isCompleted: true)
]
let originalIds = original.map(\.id)

// encode 是 throws 操作，这里只做单次验证可直接 try；生产代码（清单 25-3）应使用 do-catch。
let data = try encoder.encode(original)
let restored: [TodoItem] = try decoder.decode([TodoItem].self, from: data)
let restoredIds = restored.map(\.id)

print("原 id == 解码后 id：\(originalIds == restoredIds)")