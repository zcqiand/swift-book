let english = "Hello Swift"
print(english.uppercased())
print(english.lowercased())

let mixed = "你好 Swift"
// Swift 的 String 是值类型:这两个方法返回新串,原串不会被修改
print(mixed.uppercased())
print(mixed)