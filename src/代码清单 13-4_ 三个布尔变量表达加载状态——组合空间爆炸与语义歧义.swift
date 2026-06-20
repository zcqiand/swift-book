import Foundation

// 用三个独立的布尔变量描述「一次网络请求的状态」
let isLoading = true
let isSuccess = true
let hasError = false

// 这组值在语法上完全合法，但语义上荒谬：既在加载（isLoading=true），又已成功（isSuccess=true）？
// 真实网络请求不可能同时「还在加载」和「已经成功」，但布尔组合对此毫无约束
// 三个布尔变量的组合空间是 2^3 = 8 种，其中只有 3 种符合真实状态语义（加载中/成功/失败），
// 其余 5 种都是语义荒谬但语法合法的状态——这就是「组合空间爆炸」

// 用 if-else 处理这组组合：识别结果取决于 if 书写顺序，这本身就是歧义的证据
// 写法一：先判 isLoading，则「既加载又成功」被识别为「加载中」
if isLoading {
    print("识别为: 加载中")
} else if isSuccess {
    print("识别为: 成功")
} else if hasError {
    print("识别为: 失败")
} else {
    print("识别为: 未知")
}
// 输出: 识别为: 加载中

// 如果换个书写顺序——先判 isSuccess，同一组布尔值会被识别为「成功」
// 同样的输入、不同的执行路径，这正是布尔建模的根本缺陷：语义由书写顺序决定，而非由数据本身保证
if isSuccess {
    print("识别为: 成功")
} else if isLoading {
    print("识别为: 加载中")
} else if hasError {
    print("识别为: 失败")
} else {
    print("识别为: 未知")
}
// 输出: 识别为: 成功

// 枚举的 LoadState 只有 3 个 case，case 之间天然互斥：
// 一个 LoadState 实例只能是 .loading、.loaded、.failed 其中之一，从根上消除了 8 种组合中的 5 种语义荒谬状态
// 「互斥」是枚举相对于布尔组合的核心安全保证：不可能构造出 LoadState.loaded 同时又是 .failed 的实例