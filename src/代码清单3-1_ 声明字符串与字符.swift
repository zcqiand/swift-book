let name = "Tom"
let greeting = "你好"
let initial: Character = "S"

// type(of:) 在零基础阶段比看文档更直观地确认编译器推断出的类型
print(type(of: name))
print(type(of: greeting))
print(type(of: initial))

// Character 只能容纳单个 Extended Grapheme Cluster(字素簇),故多字符字面量无法通过类型检查
// let bad: Character = "abc" // 编译错误:Character 只能放单个字符