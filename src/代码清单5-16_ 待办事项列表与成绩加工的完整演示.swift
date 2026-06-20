import Foundation

// 一、待办列表：增删改查
var todos: [String] = []               // 从空数组起步
todos.append("学完第5章")              // 增：append
todos.append("做完练习")
todos.append("提交作业")
print(todos)
// 输出：["学完第5章", "做完练习", "提交作业"]

todos[1] = "做完所有练习"              // 改：下标赋值
print(todos)
// 输出：["学完第5章", "做完所有练习", "提交作业"]

let removed = todos.remove(at: 0)      // 删：remove(at:)
print("已删除：\(removed)")
// 输出：已删除：学完第5章

// 查：contains
print("包含提交作业：\(todos.contains("提交作业"))")
// 输出：包含提交作业：true

// 遍历：for-in 配下标编号打印
print("当前待办：")
for index in 0..<todos.count {
    print("\(index + 1). \(todos[index])")
}
// 输出：
// 当前待办：
// 1. 做完所有练习
// 2. 提交作业

// 二、成绩加工：排序与查找
let scores = [88, 72, 95, 60, 88]
print("成绩升序：\(scores.sorted())")           // 成绩升序：[60, 72, 88, 88, 95]
print("成绩降序：\(scores.sorted(by: >))")      // 成绩降序：[95, 88, 88, 72, 60]
print("是否有人满分：\(scores.contains(100))")  // 是否有人满分：false
print("总人数：\(scores.count)")                // 总人数：5

// 三、值类型拷贝：复制后彼此独立
var original = [88, 72]
var copy = original
copy.append(95)
print("原件：\(original)")   // 原件：[88, 72]
print("副本：\(copy)")       // 副本：[88, 72, 95]