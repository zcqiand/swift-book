import Foundation

// 用 enum 关键字定义一个枚举，Swift 枚举是一等类型（可作函数参数与返回值，与 struct/class 同级）
// 三个 case 写在同一行用逗号分隔，等价于三行各写一个 case，纯书写简写，无语义差异
enum TrafficLight {
    case red, yellow, green
}

// describe 函数以 TrafficLight 为参数、String 为返回值
// 枚举是一等类型，所以可以像 Int、String 那样作为函数参数类型直接使用
func describe(light: TrafficLight) -> String {
    switch light {
    // switch 处理枚举时必须穷尽所有 case：这里漏写 yellow 编译过不去
    // 这是 Swift 编译期的安全保证（回扣第 7 章 7.5 节清单 7-4a 的穷尽性检查）
    case .red:
        // case 内不需要写 break：Swift switch 默认不贯穿（no implicit fallthrough）
        return "红灯停"
    case .yellow:
        return "黄灯注意"
    case .green:
        return "绿灯行"
    }
}

// 枚举 case 用点语法简写引用（完整写法 TrafficLight.red，因类型已被推断可省略枚举名）
print(describe(light: .red))
// 输出: 红灯停
print(describe(light: .yellow))
// 输出: 黄灯注意
print(describe(light: .green))
// 输出: 绿灯行