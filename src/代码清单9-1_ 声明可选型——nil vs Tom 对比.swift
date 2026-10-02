import Foundation

// 显式写 String? 让编译器把它推断成 Optional<String>,而不是普通 String
// 为什么要写问号?因为 nickname 可能「没有值」,普通 String 在 Swift 中绝不可能为 nil
let nickname1: String? = nil
let nickname2: String? = "Tom"

// 直接 print 一个可选值,Swift 会保留 Optional(包装)层,提醒你「这还是盒子」
print("nickname1 的值: \(nickname1 ?? "无")")
// 输出: nickname1 的值: 无
print("nickname2 的值: \(nickname2 ?? "无")")
// 输出: nickname2 的值: Tom

// type(of:) 暴露真实静态类型:两者都是 Optional<String>,运行时值不同但类型相同
print("nickname1 的类型: \(type(of: nickname1))")
// 输出: nickname1 的类型: Optional<String>
print("nickname2 的类型: \(type(of: nickname2))")
// 输出: nickname2 的类型: Optional<String>

// 回扣第 6 章 6.3 节代码清单 6-2:weather 的 Optional("晴") 与上面 nickname2 完全同构
let weather: String? = "晴"
print("weather 的值: \(weather ?? "未知")")
// 输出: weather 的值: 晴
print("weather 的类型: \(type(of: weather))")
// 输出: weather 的类型: Optional<String>