import Foundation

// 第一个变量为 nil,演示「nil 兜底」
let nickname: String? = nil
// 为什么用 ??:左侧是 nil 时返回右侧默认值,是非问题一行解决,无须写 if let / guard let
print(nickname ?? "匿名用户")
// 输出: 匿名用户

// 第二个变量有值,演示「有值用值」
let nickname2: String? = "Tom"
// 即使有值也用 ??,因为 ?? 会自动解包——不会打印 Optional("Tom")
print(nickname2 ?? "匿名用户")
// 输出: Tom

// 回扣第 6 章 6.3 节字典取值 ?? 兜底用法:场景相同、写法相同、安全保证相同
var cityWeather: [String: String] = ["北京": "晴"]
print("北京的天气: \(cityWeather["北京"] ?? "暂无数据")")
// 输出: 北京的天气: 晴
print("深圳的天气: \(cityWeather["深圳"] ?? "暂无数据")")
// 输出: 深圳的天气: 暂无数据