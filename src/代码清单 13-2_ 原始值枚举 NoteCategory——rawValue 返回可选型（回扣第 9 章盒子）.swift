import Foundation

// 在枚举名后加 : String，表示整个枚举共享 String 一种原始值类型
// 关键三特征：① 预声明（定义时一次性给定）；② 同类型（全枚举只能 String，不可混 Int）；
// ③ 每 case 一个固定标识（运行时不可改）
enum NoteCategory: String {
    case work = "工作"
    case life = "生活"
    case study = "学习"
}

// 正向取原始值：.rawValue 在 case 已固定时返回 String（非可选），因为编译期完全确定
// 这里 work 的原始值在定义时就钉死为「工作」，编译器完全知道
let workCategory = NoteCategory.work
print(workCategory.rawValue)
// 输出: 工作

// 反向构造：从原始值字符串构造 NoteCategory，返回 Optional<NoteCategory>
// 为什么返回可选型？因为传入的字符串可能不匹配任何 case（如「娱乐」），此时无法构造、只能给 nil
// 这是第 9 章「装值的盒子」的直接复用——反向构造可能失败，所以装进 Optional 盒子
if let matched = NoteCategory(rawValue: "工作") {
    // 「工作」匹配 .work case，解包成功，matched 是 NoteCategory.work
    print("反向构造成功: \(matched.rawValue)")
} else {
    print("反向构造失败")
}
// 输出: 反向构造成功: 工作

// 失败路径：传入「娱乐」匹配不到任何 case，NoteCategory(rawValue:) 返回 nil
// 用 ?? 兜底：左侧为 nil 时返回右侧默认值，一行解决是非问题（回扣第 9 章 9.6 节空合运算符）
let unknownCategory = NoteCategory(rawValue: "娱乐") ?? NoteCategory.work
print("未知分类兜底为: \(unknownCategory.rawValue)")
// 输出: 未知分类兜底为: 工作