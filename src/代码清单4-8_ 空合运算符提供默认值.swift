import Foundation

// 场景1：用户没填昵称
let nickname: String? = nil   // nil 表示「没有值」
let displayName = nickname ?? "匿名用户"
print("nickname 为 nil 时：\(displayName)")   // → 匿名用户

// 场景2：字典取值——键存在拿真值，不存在拿默认值
let profile: [String: String] = ["city": "上海"]
let city = profile["city"] ?? "未知城市"
print("键存在时：\(city)")                   // → 上海

let region = profile["region"] ?? "未知地区"
print("键不存在时：\(region)")               // → 未知地区