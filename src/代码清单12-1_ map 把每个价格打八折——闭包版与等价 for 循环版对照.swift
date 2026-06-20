// Swift 6.2 / Xcode 26 / iOS 26 SDK
import Foundation

let prices = [10, 25, 8, 50]

// === 闭包版:prices.map { ... } ===
// map 接收一个闭包,对数组里每个元素跑一遍这个闭包,把每次返回的值装进「新数组」按序返回。
// 关键:map 不动原数组,只是产出一份新数组——这是 Swift 集合「值语义」的体现(第5章 5.7 实证过数组拷贝独立)。
// $0 是第11章 11.3 练过的位置参数名,代表「当前元素」——一个元素进来一次,$0 就依次指向 10、25、8、50。
// 用 Double($0) * 0.8 而非 $0 * 0.8:八折后是小数(8 的八折是 6.4),
// 而 $0 是 Int,Int 乘 0.8 会被推断成 Double,显式转 Double 让意图和类型都清楚。
let discountedClosure = prices.map { Double($0) * 0.8 }
print(discountedClosure)
// 输出：[8.0, 20.0, 6.4, 40.0]

// === 等价 for 循环版 ===
// 同样的逻辑,如果用第8章的 for-in 显式写,要先建一个空数组、再逐个 append。
// 代码量更多、意图(「我要把每个变换后塞进新数组」)埋在循环细节里——
// 而 map 的方法名本身就告诉你「变换」。
var discountedForLoop: [Double] = []
for price in prices {
    // 同样必须把 Int 转成 Double,否则 append 类型不匹配。
    discountedForLoop.append(Double(price) * 0.8)
}
print(discountedForLoop)
// 输出：[8.0, 20.0, 6.4, 40.0]

// === 实证 forbidden_confusion ①:原数组不变 ===
// map 返回的是全新数组,不改 prices 本身——很多人误以为「map 把 prices 改了」。
// 打印原数组验证它仍然是初始的 [10, 25, 8, 50],这是集合操作的安全特性,不是 bug。
print(prices)
// 输出：[10, 25, 8, 50]