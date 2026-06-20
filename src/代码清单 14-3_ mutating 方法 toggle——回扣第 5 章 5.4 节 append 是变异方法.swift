// 版本基线：Swift 6.2 / Xcode 26 / iOS 26 SDK
import Foundation

struct TodoItem {
    let id: Int
    var title: String
    var done: Bool

    // 必须 mutating：修改自身存储属性 = 产生新值再替换回变量（回扣第 5 章 5.4 节 append）
    mutating func toggle() {
        done.toggle()   // Bool.toggle() 是 Swift 4.2+ 标准 mutating 方法
    }
}

var task = TodoItem(id: 1, title: "学结构体", done: false)

print("调用 toggle 前 done: \(task.done)")
task.toggle()
print("调用 toggle 后 done: \(task.done)")
print(task)