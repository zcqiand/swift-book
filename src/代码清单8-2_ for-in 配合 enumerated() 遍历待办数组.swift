import Foundation

let todos = ["学完第8章", "做练习", "提交作业"]

// enumerated() 在第3章 3.7 节已在字符串上用过（返回 (offset, element) 元组序列）
// 这里把它用在数组上：同时拿到「第几项」与「内容」两份信息，免去再写下标循环
for (index, task) in todos.enumerated() {
    // offset 从 0 起；展示给用户习惯从 1 数，所以这里 + 1
    print("第\(index + 1)项: \(task)")
}