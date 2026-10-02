let cityWeather: [String: String] = ["北京": "多云", "广州": "晴", "成都": "阴"]

// for-in 配合元组 (key, value) 一次性拿到键和值
for (city, weather) in cityWeather {
    print("\(city): \(weather)")
}
// 输出（每次运行顺序可能不同）:
// 北京: 多云
// 广州: 晴
// 成都: 阴

// 字典天生无序，遍历顺序和插入顺序没有必然关系
// 顺序敏感的场景应先对 keys 排序再遍历
for city in cityWeather.keys.sorted() {
    print("按城市名排序: \(city)")
}
// 输出:
// 按城市名排序: 北京
// 按城市名排序: 成都
// 按城市名排序: 广州