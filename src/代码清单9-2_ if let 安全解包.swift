import Foundation

// 函数沿用第 7 章 greet 最简形态:参数标签 nickname、返回 String
func greet(nickname: String?) -> String {
    // if let 把可选值解包给临时常量 nickname(同名复用,Swift 惯例减少命名负担)
    // 为什么用 if let 而不直接用 nickname 拼字符串?
    // 因为 nickname 的类型是 String?,String? 与 String 不是同一个类型,
    // 不能直接拼,必须先「打开盒子」取出里面的 String
    if let nickname {
        // 这个 nickname 已经是确定有值的 String,作用域仅在本花括号内
        return "你好,\(nickname)"
    } else {
        return "没有昵称"
    }
    // 注意:走到这里时 if 分支里的那个 nickname 已不可用——它只活在花括号里
}

print(greet(nickname: "Tom"))   // 输出: 你好,Tom
print(greet(nickname: nil))     // 输出: 没有昵称