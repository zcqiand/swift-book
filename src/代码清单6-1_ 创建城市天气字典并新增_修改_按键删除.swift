// 用 var 声明字典才是可变容器；let 声明的字典无法增删改
var cityWeather: [String: String] = ["北京": "晴", "上海": "雨"]
print("初始字典: \(cityWeather)")
// 输出: 初始字典: ["北京": "晴", "上海": "雨"]

// 给尚不存在的键赋值 → 新增一条键值对
cityWeather["广州"] = "晴"
// 键唯一：给已存在的键赋值不是新增，而是覆盖旧值
cityWeather["北京"] = "多云"
print("新增广州、覆盖北京后: \(cityWeather)")
// 输出: 新增广州、覆盖北京后: ["广州": "晴", "北京": "多云", "上海": "雨"]

// removeValue(forKey:) 按键删除，返回被删除的值（Optional）
let removed = cityWeather.removeValue(forKey: "上海")
print("删除上海——被删除的值: \(removed ?? "无")")
// 输出: 删除上海——被删除的值: 雨