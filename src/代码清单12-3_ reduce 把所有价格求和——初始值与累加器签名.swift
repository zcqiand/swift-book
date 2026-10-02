// Swift 6.2 / Xcode 26 / iOS 26 SDK
import Foundation

let prices = [10, 25, 8, 50]

// === 闭包版:prices.reduce(初始值, 闭包) ===
// reduce 把整个数组「归约」成一个值。流程:
//   第一步:用「初始值」和数组的第一个元素,跑闭包,得到「当前累加值」;
//   第二步:用「当前累加值」和第二个元素,再跑闭包,得到新的累加值;
//   依此类推,直到最后一个元素,最终累加值就是返回值。
// prices.reduce(0, +):初始值 0,闭包就是 + 运算符(第11章 11.3 第四层简写)。
//   0 + 10 = 10 → 10 + 25 = 35 → 35 + 8 = 43 → 43 + 50 = 93,最终 93。
// 闭包签名(累加器, 当前元素) -> 新累加器——初始值 0 决定了累加器类型是 Int,结果也是 Int。
let totalClosure = prices.reduce(0, +)
print(totalClosure)
// 输出：93

// === 等价展开写法:把 + 显式写成闭包 ===
// $0 是累加器(每次的累加结果),$1 是当前元素。这种写法与 reduce(0, +) 完全等价,
// 写出来是为了让你看清闭包的两个参数分别是什么。
let totalExpanded = prices.reduce(0) { $0 + $1 }
print(totalExpanded)
// 输出：93

// === 等价 for 循环版 ===
// 显式写:初始 sum = 0,逐个累加。与 reduce(0, +) 的执行过程一一对应。
var totalForLoop = 0
for price in prices {
    totalForLoop += price
}
print(totalForLoop)
// 输出：93

// === 实证 forbidden_confusion ③:初始值决定累加器(结果)类型 ===
// 同样是 reduce,初始值是 0(Int)得 Int;初始值是 ""(String)得 String。
// 这里换一个字符串数组演示:把三个水果名拼成一句话。
// 累加器从 "" 起步,每次把当前水果名 append 到累加器上——
// 结果类型由初始值 "" 决定,与原数组元素类型恰好一致(String)。
let fruits = ["苹果", "香蕉", "橙子"]
let combined = fruits.reduce("", +)
print(combined)
// 输出：苹果香蕉橙子

// 对照:如果初始值给 "水果清单:",结果就在前面拼上这段前缀——
// 进一步证明「初始值是累加器的起点,直接决定结果」。
let withPrefix = fruits.reduce("水果清单:", +)
print(withPrefix)
// 输出：水果清单:苹果香蕉橙子