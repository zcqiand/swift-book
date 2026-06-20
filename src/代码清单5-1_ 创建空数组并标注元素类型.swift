// 两种等价写法：推荐简写形式 [String]
var todos: [String] = []
var alsoTodos: Array<String> = []

// 推断写法：直接给出字面量，编译器从内容反推类型为 [String]
var weekend = ["学完第5章", "做完练习"]

print(todos)        // 输出：[]
print(weekend)      // 输出：["学完第5章", "做完练习"]