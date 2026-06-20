import Foundation

// 为什么把打招呼逻辑封装成函数?
// 因为同一段拼接 + 返回逻辑要被多处调用,封装后调用点只需写一行,改逻辑也只改函数体
// func 关键字声明函数;name: String 是参数(参数标签与参数名同名,Swift 默认形态);
// -> String 声明返回类型为字符串;返回值用 return 给出
func greet(name: String) -> String {
    // 用字符串插值(C012)把 name 嵌进打招呼文案,半角逗号匹配 exec.json 期望输出「你好,Tom」
    return "你好,\(name)"
}

// 调用点必须写参数标签 name:——这是 Swift 默认形态,提升调用点的可读性(读起来像一句话)
print(greet(name: "Tom"))