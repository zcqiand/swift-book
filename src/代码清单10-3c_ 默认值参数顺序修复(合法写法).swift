import Foundation

// 修复:把无默认值的 name 放在前面,带默认值的 greeting 放在末尾——这是 Swift 唯一允许的顺序
func greet(name: String, greeting: String = "你好") -> String {
    return "\(greeting),\(name)"
}

// 调用点可只传必需参数(name),也可显式覆盖 greeting
print(greet(name: "Tom"))                  // 用 greeting 默认值「你好」,输出「你好,Tom」
print(greet(name: "Tom", greeting: "Hi"))  // 覆盖 greeting,输出「Hi,Tom」