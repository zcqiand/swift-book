import Foundation

// 为什么用 class 而非 struct:@escaping 的核心教学价值是「提示 self 生命周期」,
// 只有引用类型(类)才有真实的 self 生命周期语义;struct 是值类型没有循环引用风险。
// 类的系统讲解在第 15 章,这里只用一个最简的「带属性的类」体会 @escaping。
class Counter {
    var count = 0

    // completion 用 @escaping 标记——告诉编译器:这个闭包可能在 delayedIncrement 返回后才被调用。
    // 没有这个标记,编译器会拒绝把闭包存进任何能逃逸出函数作用域的地方(如 DispatchQueue)。
    func delayedIncrement(after seconds: TimeInterval, completion: @escaping () -> Void) {
        // DispatchQueue.main.asyncAfter 当「定时器」用:延迟 seconds 秒后,
        // 在主线程执行闭包。此时 delayedIncrement 早已返回——闭包「逃逸」出了函数。
        // 完整的并发范式(async/await)第 20 章讲,本章只把它当延迟调用工具。
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // 逃逸闭包内引用所在实例的成员必须显式 self.——
            // 这是编译器在提醒:这段代码可能在 self 被释放前/后才跑,需要你明确 self 的生命周期。
            // 去掉 self. 会编译报错:Reference to property 'count' in closure requires explicit 'self.'
            // to make capture semantics explicit
            self.count += 1
            completion()
        }
    }
}

let c = Counter()
c.delayedIncrement(after: 1) {
    // 闭包延迟 1 秒后才执行,此时 count 已经被加到 1。
    print("异步完成,count 现在是 \(c.count)")
}
// 输出（延迟 1 秒后）：异步完成,count 现在是 1