// 返回 String（不是 Optional），本章按 concept-check 约定不引入 nil 返回
func greet(name: String) -> String {
    // guard 不满足就执行 else 块并退出当前作用域；满足则继续往下走
    // 若改用 if 嵌套，主逻辑就要缩进一层——guard 让主逻辑保持扁平
    guard !name.isEmpty else {
        return "匿名用户"
    }
    // 走到这里说明 name 一定非空，主逻辑无需缩进
    return "你好，\(name)！"
}

print(greet(name: "小琪"))   // 输出：你好，小琪！
print(greet(name: ""))       // 输出：匿名用户