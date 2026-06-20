import Foundation

struct TodoItem {
    let title: String
    let isCompleted: Bool
}

extension TodoItem: CustomStringConvertible {
    var description: String {
        let statusText = isCompleted ? "已完成" : "未完成"
        return "\(statusText)：\(title)"
    }
}

let morningTask = TodoItem(title: "阅读第 19 章《泛型与扩展》", isCompleted: false)
let finishedTask = TodoItem(title: "运行 Playground 示例代码", isCompleted: true)

print(morningTask)
print(finishedTask)