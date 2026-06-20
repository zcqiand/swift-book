// Swift 6.2 / Xcode 26 / iOS 26 SDK
import Foundation

let prices = [10, 25, 8, 50]

// ============================================================
// 一、map 把每个价格打八折
// ============================================================

// 闭包版:一行表达「对每个元素做变换」,方法名 map 即意图。
// Double($0) 转换是必须的:八折后会出现小数(如 8 的八折是 6.4)。
let discountedClosure = prices.map { Double($0) * 0.8 }
print(discountedClosure)
// 输出：[8.0, 20.0, 6.4, 40.0]

// 等价 for 循环版:意图(变换并装配新数组)被空数组初始化 + append 的细节淹没。
var discountedForLoop: [Double] = []
for price in prices {
    discountedForLoop.append(Double(price) * 0.8)
}
print(discountedForLoop)
// 输出：[8.0, 20.0, 6.4, 40.0]

// ============================================================
// 二、filter 筛选大于等于 20 的价格
// ============================================================

// 闭包版:filter 即「按条件保留」。$0 >= 20 返回 true 的元素留下,其余丢弃。
let expensiveClosure = prices.filter { $0 >= 20 }
print(expensiveClosure)
// 输出：[25, 50]

// 等价 for 循环版:用 if 显式写保留逻辑——与闭包版行为完全一致,但代码更长。
var expensiveForLoop: [Int] = []
for price in prices {
    if price >= 20 {
        expensiveForLoop.append(price)
    }
}
print(expensiveForLoop)
// 输出：[25, 50]

// ============================================================
// 三、reduce 把所有价格求和(初始值 0)
// ============================================================

// 闭包版:reduce(0, +) 即「从 0 起步累加」。0 + 10 → 35 → 43 → 93。
// 初始值 0 决定累加器类型是 Int,结果也是 Int。
let totalClosure = prices.reduce(0, +)
print(totalClosure)
// 输出：93

// 等价 for 循环版:var sum = 0 起步,逐个 +=——执行过程与 reduce(0, +) 一一对应。
var totalForLoop = 0
for price in prices {
    totalForLoop += price
}
print(totalForLoop)
// 输出：93

// ============================================================
// 四、forEach 逐行打印每个价格
// ============================================================

// 闭包版:forEach 只做副作用(print),无返回值——适合「逐个做事」,不适合「变换得新集合」。
prices.forEach { price in
    print(price)
}
// 输出：
// 10
// 25
// 8
// 50

// 等价 for 循环版:第8章 for-in 写法。与 forEach 输出完全一致,
// 唯一差别是 for-in 内部可以 break,forEach 内部不能(详见清单 12-4)。
for price in prices {
    print(price)
}
// 输出：
// 10
// 25
// 8
// 50