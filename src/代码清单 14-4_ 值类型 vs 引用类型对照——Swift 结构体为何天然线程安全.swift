// 版本基线：Swift 6.2 / Xcode 26 / iOS 26 SDK
import Foundation

struct TodoItem {
    let id: Int
    var title: String
    var done: Bool
}

var taskB = TodoItem(id: 1, title: "学结构体", done: false)
var taskA = taskB                // 赋值即复制
taskB.title = "改了副本"

print("=== 值语义（Swift 结构体）===")
print("taskA.title: \(taskA.title)")
print("taskB.title: \(taskB.title)")

print("=== 引用语义（Java 类对比，仅文字说明，不运行）===")
// Java 等价写法（参考）：TodoItem b = a; b.title = "改了副本"; 则 a.title 也变
// 根因：Java 类赋值复制的是引用（地址），不是内容
// Swift 结构体复制独立 = 两个并发任务各持独立副本 = 天然线程安全
print("在 Java 里同样的赋值会让 taskA.title 也变成「改了副本」")
print("Swift 结构体的复制独立 = 两个并发任务各持独立副本 = 天然线程安全")