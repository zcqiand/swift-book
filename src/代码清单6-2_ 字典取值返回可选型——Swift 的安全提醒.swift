var cityWeather: [String: String] = ["广州": "晴", "北京": "多云"]

// 键存在 → 取到具体值，但类型仍是 Optional，不会自动解包
let weather = cityWeather["广州"]
print("广州的天气: \(weather)")
// 输出: 广州的天气: Optional("晴")

// 键不存在 → 取到 nil，而不是像数组越界那样崩溃
print("深圳的天气: \(cityWeather["深圳"] ?? "暂无数据")")
// 输出: 深圳的天气: 暂无数据

// type(of:) 暴露真实类型：取值结果是 Optional<String>，不是 String
print("weather 的静态类型: \(type(of: weather))")
// 输出: weather 的静态类型: Optional<String>