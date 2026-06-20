// 版本基线：Swift 6.2 / Xcode 26 / iOS 26 SDK
import Foundation

// 一、定义结构体 + 合成初始化器（从第 10 章 10.6 节元组升级而来）
struct TodoItem {
    let id: Int
    var title: String
    var done: Bool
    mutating func toggle() { done.toggle() }   // 回扣第 5 章 5.4 节 append
}

let todo1 = TodoItem(id: 1, title: "学结构体", done: false)
let todo2 = TodoItem(id: 2, title: "做完练习", done: false)

print("=== 一、定义结构体 + 合成初始化器 ===")
print(todo1)
print(todo2)

// 二、值语义复制对照（回扣第 5 章 5.7 节）
var itemB = TodoItem(id: 1, title: "学结构体", done: false)
var itemA = itemB
itemB.title = "改了副本"

print("")
print("=== 二、值语义复制对照 ===")
print("原件 itemA.title: \(itemA.title)")
print("副本 itemB.title: \(itemB.title)")

// 三、mutating toggle（task 必须 var，否则报错见清单 14-3b）
var task = TodoItem(id: 1, title: "学结构体", done: false)

print("")
print("=== 三、mutating toggle ===")
print("调用 toggle 前 done: \(task.done)")
task.toggle()
print("调用 toggle 后 done: \(task.done)")
print(task)

// 四、值类型 vs 引用类型（Java 对比文字）
print("")
print("=== 四、值类型 vs 引用类型（Java 对比文字）===")
print("Swift 结构体赋值即复制，原件与副本彼此独立")
print("这是第 5 章 5.7 节数组值语义在自定义类型上的同款表现")
print("Java 类的赋值共享同一实例，Swift 默认推荐 struct 是因为值语义天然线程安全")