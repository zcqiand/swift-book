// 版本基线：Swift 6.2 / Xcode 26 / iOS 26 SDK
import Foundation

// 从第 10 章 10.6 节元组升级而来：元组没字段名、不能挂方法，struct 两者都有
struct TodoItem {
    let id: Int              // 唯一标识，创建后不可变
    var title: String        // 标题可编辑
    var done: Bool           // 完成状态可切换
}

// 不用手写 init，Swift 自动合成 memberwise 初始化器，签名即 TodoItem(id:title:done:)
let todo1 = TodoItem(id: 1, title: "学结构体", done: false)
let todo2 = TodoItem(id: 2, title: "做完练习", done: false)

print(todo1)
print(todo2)