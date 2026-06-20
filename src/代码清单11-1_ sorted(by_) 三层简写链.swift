import Foundation

var scores = [88, 72, 95, 60]

// 第一层:完整闭包表达式。把参数类型与返回类型写全,让编译器明确知道
// 「传入两个 Int、返回一个 Bool」——这是 sorted(by:) 签名 (Int, Int) -> Bool 的精确匹配。
let descending1 = scores.sorted(by: { (a: Int, b: Int) -> Bool in
    return a > b
})
print(descending1)
// 输出：[95, 88, 72, 60]

// 第二层:省略参数类型与返回类型。Swift 根据 sorted(by:) 的签名反向推断
// a、b 必然是 Int、返回必然是 Bool,所以类型声明可以全部隐去。
let descending2 = scores.sorted(by: { a, b in return a > b })
print(descending2)
// 输出：[95, 88, 72, 60]

// 第三层:$0/$1 参数缩写。Swift 闭包内建 $0、$1、$2... 位置参数名——
// 既然能从签名推断出参数个数与类型,连 in 前的形参名也可以省。
let descending3 = scores.sorted(by: { $0 > $1 })
print(descending3)
// 输出：[95, 88, 72, 60]

// 第四层:仅保留运算符 >。在 Swift 中 > 本身就是一个 (Int, Int) -> Bool 类型的函数,
// 当闭包体只是「把两个参数交给某个运算符」时,直接把这个运算符名传进去即可。
// 这正是第 5 章代码清单 5-12 里 scores.sorted(by: >) 的真正含义。
let descending4 = scores.sorted(by: >)
print(descending4)
// 输出：[95, 88, 72, 60]