import Foundation

// 一、普通枚举：TrafficLight
// 最简形态，无原始值无关联值，仅用 case 表达有限状态，是第 7 章 7.5 节那张「最简交通灯」的完整版本
enum TrafficLight {
    case red, yellow, green
}

func describe(light: TrafficLight) -> String {
    // switch 穷尽三 case，漏写任一个编译过不去（回扣第 7 章穷尽性）
    switch light {
    case .red:
        return "红灯停"
    case .yellow:
        return "黄灯注意"
    case .green:
        return "绿灯行"
    }
}

print("一、普通枚举 TrafficLight:")
print(describe(light: .red))
// 输出: 红灯停
print(describe(light: .yellow))
// 输出: 黄灯注意
print(describe(light: .green))
// 输出: 绿灯行

// 二、原始值枚举：NoteCategory: String
// 整个枚举共享 String 一种原始值类型，定义时一次性给定，常用于映射常量（分类名、状态码）
enum NoteCategory: String {
    case work = "工作"
    case life = "生活"
    case study = "学习"
}

print("\n二、原始值枚举 NoteCategory:")
// 正向取值：.rawValue 在 case 已固定时返回 String（编译期完全确定）
print(NoteCategory.work.rawValue)
// 输出: 工作

// 反向构造：从字符串构造枚举，返回 Optional——可能匹配失败，用 if let 安全解包（回扣第 9 章盒子）
if let matched = NoteCategory(rawValue: "工作") {
    print("反向构造成功: \(matched.rawValue)")
} else {
    print("反向构造失败")
}
// 输出: 反向构造成功: 工作

// 失败路径：?? 兜底，左侧 nil 时返回右侧默认值
let unknown = NoteCategory(rawValue: "娱乐") ?? NoteCategory.work
print("未知分类兜底为: \(unknown.rawValue)")
// 输出: 未知分类兜底为: 工作

// 三、关联值枚举：LoadState
// 每个 case 携带类型化载荷，与原始值的核心差异：关联值属于实例级数据，每次创建可带不同内容
enum LoadState {
    case loading
    case loaded(data: String)
    case failed(error: String)
}

func handle(state: LoadState) -> String {
    switch state {
    case .loading:
        return "加载中…"
    // 关联值用 case .loaded(let data) 解构，把载荷绑定到常量 data
    case .loaded(let data):
        return "数据: \(data)"
    case .failed(let error):
        return "错误: \(error)"
    }
}

print("\n三、关联值枚举 LoadState:")
print(handle(state: .loading))
// 输出: 加载中…
print(handle(state: .loaded(data: "北京 26°C 晴")))
// 输出: 数据: 北京 26°C 晴
print(handle(state: .failed(error: "网络超时")))
// 输出: 错误: 网络超时