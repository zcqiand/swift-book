let name = "Tom"
let visitCount = 3
let isVIP = true

// 插值表达式 \(value) 由编译器保证类型安全,无需手动转换
let message = "你好,\(name)!这是你第 \(visitCount) 次访问,VIP 状态:\(isVIP)。"
print(message)