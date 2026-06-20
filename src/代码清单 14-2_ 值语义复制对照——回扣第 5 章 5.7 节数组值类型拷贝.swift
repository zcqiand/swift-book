// 版本基线：Swift 6.2 / Xcode 26 / iOS 26 SDK
import Foundation

struct TodoItem {
    let id: Int
    var title: String
    var done: Bool
}

var itemB = TodoItem(id: 1, title: "学结构体", done: false)
// 赋值即复制：itemA 与 itemB 是两份独立内存（回扣第 5 章 5.7 节 copy.append 不影响 original）
var itemA = itemB
itemB.title = "改了副本"

// 若 TodoItem 是引用类型（类），itemA.title 也会变成「改了副本」
print("原件 itemA.title: \(itemA.title)")
print("副本 itemB.title: \(itemB.title)")