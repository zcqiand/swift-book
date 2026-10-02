import Foundation

// transform 是一个「输入 Int、返回 Int」的变换规则——
// 把规则作为参数传进来,函数就能对任意数组套用任意变换,这是把代码当值传递的核心。
func process(numbers: [Int], transform: (Int) -> Int) -> [Int] {
    var result: [Int] = []
    for number in numbers {
        // 把每个元素交给调用方传进来的闭包去处理,处理后的值再装进新数组。
        // 函数本身不关心 transform 具体做什么——这是「策略由调用方决定」的解耦。
        result.append(transform(number))
    }
    return result
}

let nums = [1, 2, 3, 4, 5]

// 写法一:把闭包写在圆括号内、贴着参数标签 transform: ——这是所有闭包参数都通用的写法。
let doubledInside = process(numbers: nums, transform: { $0 * 2 })
print(doubledInside)
// 输出：[2, 4, 6, 8, 10]

// 写法二:尾随闭包。当闭包是函数的最后一个参数时,Swift 允许把它移到圆括号外面、用花括号包裹。
// 行为与写法一完全一致——尾随闭包只改变写法,不改变语义,只是让最后一个闭包参数读起来更自然。
let doubledTrailing = process(numbers: nums) { $0 * 2 }
print(doubledTrailing)
// 输出：[2, 4, 6, 8, 10]