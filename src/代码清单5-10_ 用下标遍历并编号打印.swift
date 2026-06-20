let tasks = ["学完第5章", "做完练习", "提交作业"]
for index in 0..<tasks.count {
    // index 从 0 开始，编号要显示成 1 起步，所以加 1
    print("\(index + 1). \(tasks[index])")
}
// 输出：
// 1. 学完第5章
// 2. 做完练习
// 3. 提交作业