import Foundation

enum TodoStore {
    private static let storageKey = "todos"

    static func load() -> [TodoItem] {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            print("已加载 0 条")
            return []
        }

        do {
            let items = try JSONDecoder().decode([TodoItem].self, from: data)
            print("已加载 \(items.count) 条")
            return items
        } catch {
            print("解码待办数据失败：\(error)。已重置为空列表。")
            return []
        }
    }

    static func save(_ items: [TodoItem]) {
        do {
            let data = try JSONEncoder().encode(items)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("编码待办数据失败：\(error)。本次未保存。")
        }
    }
}