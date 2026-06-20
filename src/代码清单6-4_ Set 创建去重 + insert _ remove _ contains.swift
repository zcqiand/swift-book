// 数组里故意放了重复元素，模拟脏数据源
let rawSkills = ["Swift", "Swift", "iOS", "iOS", "iOS", "SwiftUI"]
// Set(array) 一次性去重；String 自动满足 Hashable 协议
var skills: Set<String> = Set(rawSkills)
print("去重后的 Set（顺序不保证）: \(skills)")
// 输出: 去重后的 Set（顺序不保证）: ["iOS", "Swift", "SwiftUI"]

// contains 成员判断，比数组的 contains 高效（接近 O(1)）
print("是否已掌握 Flutter: \(skills.contains("Flutter"))")
// 输出: 是否已掌握 Flutter: false

// insert 插入新元素，返回元组 (inserted: Bool, memberAfterInsert:)
// inserted 为 false 说明该元素早已存在——Set 永不重复
let r1 = skills.insert("SwiftUI")
let r2 = skills.insert("Python")
print("插入 SwiftUI 是否为新增: \(r1.inserted) ｜ 插入 Python 是否为新增: \(r2.inserted)")
// 输出: 插入 SwiftUI 是否为新增: false ｜ 插入 Python 是否为新增: true

// remove 删除指定元素；不存在则返回 nil，不会报错
print("删除 iOS——返回: \(skills.remove("iOS") ?? "无")")
// 输出: 删除 iOS——返回: iOS