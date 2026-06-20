import Foundation

/// 待办项数据模型。
///
/// 设计要点：
/// - 用 struct 而非 class：值类型拷贝传值，列表与详情页互不串改，
///   符合第 23 章「状态驱动界面」的最小心智负担（详见 24.6 节值语义说明）。
/// - 实现 Identifiable：List / ForEach 需要每个元素有稳定唯一 id 才能正确 diff
///   与导航。UUID 天然全局唯一，比用数组下标安全（删除/插入后下标会漂移）。
/// - 本章不引入 Codable / 持久化：TodoItem 只活在内存里，App 重启即清空；
///   第 25 章会在 UserDefaults 持久化场景中首次实用引入 Codable；第 29 章再深化 CodingKeys、嵌套模型与 API 解析。
struct TodoItem: Identifiable {
    // let 而非 var：id 一旦生成不再变更，避免 SwiftUI 的 diff 误判「换了行」。
    // 每个 TodoItem 实例化时各自新建一个 UUID，互不相同。
    let id: UUID = UUID()

    var title: String
    // 默认值 false：构造时只传 title 也合法（如 TodoItem(title: "买菜")）。
    // 沿用第 17 章命名 isCompleted，避免术语漂移（不要写成 isDone / finished）。
    var isCompleted: Bool = false
}

// MARK: - 构造演示（Playground 风格）

/// 一份写死的示例数据，供 TodoListView 与预览共用。
/// 本章全程用这种内存数组作数据源，不接网络/数据库。
let todoSamples: [TodoItem] = [
    TodoItem(title: "买菜"),
    TodoItem(title: "写周报", isCompleted: true),
    TodoItem(title: "回邮件"),
    TodoItem(title: "健身 30 分钟", isCompleted: true),
    TodoItem(title: "读书 1 小时"),
    TodoItem(title: "整理桌面")
]