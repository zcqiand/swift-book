// 以下代码会编译失败,仅展示报错,不要粘进 Playground 运行。
// 错误原因:带默认值的参数 greeting 放在了无默认值的参数 name 之前,违反 Swift 编译器规则
func greet(greeting: String = "你好", name: String) -> String {
    return "\(greeting),\(name)"
}