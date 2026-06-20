import Foundation

/// 封装 [TodoItem] 在 UserDefaults 中的持久化读写。
///
/// 为什么把读写逻辑独立成一个类型（而不是塞进 TodoListView）？
/// 1) 复用：未来可能从设置页、小组件等地方读写同一份数据；
/// 2) 可测：纯 Foundation 类型，方便写 XCTest（第 38 章）做单测；
/// 3) 关注点分离：View 只管「展示 + 触发保存」，存储细节藏在 Store 里。
struct TodoStore {
    /// 存储用的键名抽成常量，避免散落的字符串字面量拼错导致读写错位。
    /// UserDefaults 不校验 key 是否被注册过，拼错只会静默失效（不会崩溃）。
    static let storageKey = "todos"

    /// 读取已持久化的待办列表。
    ///
    /// 设计要点：
    /// - 首次启动（key 从未写过）：data(forKey:) 返回 nil，直接返回空数组，避免在 nil 上调用 decode 触发错误。
    /// - 解码失败（如未来字段升级导致 JSON 格式不匹配）：返回空数组并打印原因，
    ///   而不是把错误抛给调用方导致 App 崩溃。待办数据丢失严重程度低于 App 不可用。
    static func load() -> [TodoItem] {
        let defaults = UserDefaults.standard

        // 用 data(forKey:) 而不是 object(forKey:)：语义明确（只接 Data），返回 Data?。
        guard let data = defaults.data(forKey: storageKey) else {
            print("已加载 0 条（首次启动，无存档）")
            return []
        }

        let decoder = JSONDecoder()
        do {
            let items = try decoder.decode([TodoItem].self, from: data)
            // 这一行是启动验证日志：控制台出现「已加载 N 条」即说明 load() 成功取回上次存的数据。
            print("已加载 \(items.count) 条")
            return items
        } catch {
            // 为什么这里 catch 而不是 try!？
            // JSON 解码是 throws 操作（C049）：数据格式错误、字段类型不匹配都会抛错。
            // try! 在出错时直接崩溃，对「待办数据」这种非致命场景过于激进。
            // 回扣第 18 章错误处理：能恢复的失败应优雅降级，而不是把用户踢出 App。
            print("解码待办数据失败：\(error)。已重置为空列表。")
            return []
        }
    }

    /// 把待办列表持久化到 UserDefaults。
    static func save(_ items: [TodoItem]) {
        let encoder = JSONEncoder()
        let defaults = UserDefaults.standard

        do {
            let data = try encoder.encode(items)
            // UserDefaults 的 set(_:forKey:) 内部会异步同步到磁盘，对小量数据延迟可忽略。
            defaults.set(data, forKey: storageKey)
        } catch {
            print("编码待办数据失败：\(error)。本次未保存。")
        }
    }
}