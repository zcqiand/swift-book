import Foundation

// 给 name 一个默认值「朋友」——调用时不传 name 就用默认值,传了就用传的值
// 为什么用默认值?让函数「开箱即用」地处理最常见的调用场景(此处是「不传名字」时的兜底)
func greet(name: String = "朋友") -> String {
    return "你好,\(name)"
}

// 调用一:显式传参,覆盖默认值,输出「你好,Tom」
print(greet(name: "Tom"))

// 调用二:不传参,使用默认值「朋友」,输出「你好,朋友」
// 圆括号留空——Swift 看到参数有默认值就允许省略,无需写 name:
print(greet())