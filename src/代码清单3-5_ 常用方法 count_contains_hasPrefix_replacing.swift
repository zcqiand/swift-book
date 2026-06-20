import Foundation

let text = "你好,Swift"

// count 按 Unicode 字素簇计数,符合人类阅读直觉;NSString.length 按 UTF-16 单元数,emoji 等 astral 字符会出现与肉眼计数不符的情况
print(text.count)
print(text.contains("Swift"))
print(text.hasPrefix("你好"))

let updated = text.replacingOccurrences(of: "Swift", with: "世界")
print(updated)