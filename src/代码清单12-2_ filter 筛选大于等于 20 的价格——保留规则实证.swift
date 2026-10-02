// Swift 6.2 / Xcode 26 / iOS 26 SDK
import Foundation

let prices = [10, 25, 8, 50]

// === 闭包版:prices.filter { ... } ===
// filter 接收一个「返回 Bool」的闭包:对每个元素跑一遍闭包,
// 闭包返回 true 的元素被「保留」进新数组,返回 false 的元素被「丢弃」。
// $0 >= 20 意思是「当前价格 >= 20 就返回 true」——25 与 50 满足,被保留。
let expensiveClosure = prices.filter { $0 >= 20 }
print(expensiveClosure)
// 输出：[25, 50]

// === 等价 for 循环版 ===
// 显式写:建空数组、逐个判断、满足条件才 append。
// 与闭包版行为完全等价,但意图(「按条件筛选」)被循环 + if 的细节淹没。
var expensiveForLoop: [Int] = []
for price in prices {
    if price >= 20 {
        expensiveForLoop.append(price)
    }
}
print(expensiveForLoop)
// 输出：[25, 50]

// === 实证 forbidden_confusion ②:条件返回 true 的「留下」,不是「丢弃」 ===
// 读者直觉容易把「条件成立」误解为「触发过滤即剔除」,这里用反例对照拆穿。
// 把闭包改成 $0 < 20:满足条件的是 10 和 8(返回 true),它们被保留;25 和 50 不满足(返回 false),被丢弃。
let cheapClosure = prices.filter { $0 < 20 }
print(cheapClosure)
// 输出：[10, 8]

// 一句话对照:同样的「条件判断」,$0 >= 20 留下高价、$0 < 20 留下低价——
// 永远是「返回 true 的留下」,这是 filter 名字(过滤 = 留下要的)的真正含义。

// 同样验证 filter 不改原数组——它返回新数组,prices 保持原值。
print(prices)
// 输出：[10, 25, 8, 50]