// 最简枚举：3 个 case，无关联值无原始值
enum TrafficLight {
    case red, yellow, green
}

func describe(light: TrafficLight) -> String {
    switch light {
    case .red:
        return "停"
    case .yellow:
        return "注意"
    case .green:
        return "行"
    }
}

print(describe(light: .red))     // 输出：停
print(describe(light: .yellow))  // 输出：注意
print(describe(light: .green))   // 输出：行