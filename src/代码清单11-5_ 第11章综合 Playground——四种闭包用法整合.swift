import Foundation

// 一、sorted(by:) 三层简写链:完整表达式 → 省略类型 → $0/$1 → 仅运算符 >。
var scores = [88, 72, 95, 60]

let descending1 = scores.sorted(by: { (a: Int, b: Int) -> Bool in
    return a > b
})
print(descending1)
// 输出：[95, 88, 72, 60]

let descending4 = scores.sorted(by: >)
print(descending4)
// 输出：[95, 88, 72, 60]

// 二、尾随闭包:把闭包作为函数最后一个参数,写在圆括号外。
func process(numbers: [Int], transform: (Int) -> Int) -> [Int] {
    var result: [Int] = []
    for number in numbers {
        // 策略由调用方传进来的闭包决定,函数本身只负责循环与装配。
        result.append(transform(number))
    }
    return result
}

let nums = [1, 2, 3, 4, 5]

// 两种写法行为完全一致——尾随闭包是语法糖,只改变写法,不改变语义。
let doubledInside = process(numbers: nums, transform: { $0 * 2 })
let doubledTrailing = process(numbers: nums) { $0 * 2 }
print(doubledInside)
// 输出：[2, 4, 6, 8, 10]
print(doubledTrailing)
// 输出：[2, 4, 6, 8, 10]

// 三、捕获语义:闭包对外层 var 是引用捕获——闭包内修改,外层可见。
var counter = 0
let increment = {
    counter += 1
}
increment()
increment()
increment()
print(counter)
// 输出：3

// 四、逃逸闭包 @escaping:闭包在函数返回后才被调用,体内必须显式 self.。
// 用最简 class + DispatchQueue 演示——类的系统讲解在第 15 章,并发细节第 20 章讲。
class Counter {
    var count = 0

    func delayedIncrement(after seconds: TimeInterval, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.count += 1
            completion()
        }
    }
}

let c = Counter()
c.delayedIncrement(after: 1) {
    print("异步完成,count 现在是 \(c.count)")
}
// 输出（延迟 1 秒后）：异步完成,count 现在是 1