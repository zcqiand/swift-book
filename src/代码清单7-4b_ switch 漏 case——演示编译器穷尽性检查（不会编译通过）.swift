enum TrafficLight {
    case red, yellow, green
}

func describe(light: TrafficLight) -> String {
    switch light {
    case .red:
        return "停"
    case .green:
        return "行"
    // 故意漏掉 .yellow，触发 Swift 编译器穷尽性检查
    }
}