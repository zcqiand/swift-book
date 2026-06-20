// Swift 6.2 / Xcode 26 / iOS 26 SDK
import Foundation

let prices = [10, 25, 8, 50]

// === 主例:prices.forEach { ... } 逐行打印 ===
// forEach 接收一个闭包,对每个元素跑一遍,但「不返回任何值」(返回 Void)。
// 它的唯一用途是触发副作用——这里副作用就是 print。
// 语法形态与 map 几乎一样,但语义不同:map 是「变换得新数组」,forEach 是「逐个做事」。
prices.forEach { price in
    print(price)
}
// 输出：
// 10
// 25
// 8
// 50

// === 实证 forbidden_confusion ④:forEach 无返回值 vs map 返回数组 ===
// 如果把上面的 forEach 换成 map,虽然每行同样会被打印(map 内部确实调了闭包),
// 但 map 还会返回一个「装满 Void 的新数组」——因为闭包 print(price) 返回 ()(即 Void),
// map 把这些 () 收集成 [(), (), (), ()]。这个返回值通常没用,纯属浪费。
let mapResult = prices.map { print($0) }
print(mapResult)
// 输出：
// 10
// 25
// 8
// 50
// [(), (), (), ()]

// 一句话边界:只想逐个做事(打印/通知/写日志)用 forEach;想变换出一份新集合用 map。
// forEach 因为没有返回值,不能继续链式调用(如 prices.forEach{}.filter{} 没意义);
// map 返回数组,可以继续 .filter{}.reduce{},这是函数式链式编程的基础。

// === 实证 forbidden_confusion ⑤:forEach 内部不能 break ===
// 下列代码「不会编译通过」,仅展示报错,不要粘进 Playground 运行。
// 试图在 forEach 闭包里 break 提前退出,Swift 6.2 编译器会报错:
/*
prices.forEach { price in
    if price > 30 {
        break  // 'break' is only allowed inside a loop or switch
               // (consider using a 'return' to exit the closure early)
    }
    print(price)
}
*/
// 报错原文(从 Xcode 26 / Swift 6.2 控制台逐字复制):
//   error: 'break' is only allowed inside a loop or switch
//   (consider using a 'return' to exit the closure early)
//
// 原因:forEach 内部的闭包不是真正的循环——它是被传给 forEach、对每个元素调用一次的函数。
// 函数体内 break 没有可跳出 的「外层循环」,所以编译器直接拒绝。
// 需要提前退出循环时,必须用第8章的 for-in + break,而不是 forEach。
// (forEach 闭包内可以用 return 提前结束「当前这一轮」,但不能结束整个遍历。)

// === 正确写法:需要提前退出时用 for-in + break ===
for price in prices {
    if price > 30 {
        print("遇到高价 \(price),停止遍历")
        break
    }
    print(price)
}
// 输出：
// 10
// 25
// 8
// 遇到高价 50,停止遍历