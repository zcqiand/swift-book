import Foundation

// 返回值是 String(非可选),因为 guard 成功后 nickname 已是确定有值的 String,无须再带问号
func greetGuard(nickname: String?) -> String {
    // guard let 与 if let 的关键差异:
    // if let 解包出的常量只在 if 花括号内可用;
    // guard let 解包出的常量在 guard 之后的「整个外层作用域」都可用
    guard let nickname else {
        // 不满足(传入的是 nil)必须从这里退出当前作用域,return 是语法强制
        return "没有昵称"
    }
    // 走到这里 nickname 已经是非可选 String,整个函数剩余部分都能直接用
    // 不需要任何花括号包裹,主逻辑保持扁平——这就是 guard 相对 if let 的核心优势
    return "你好,\(nickname)"
}

print(greetGuard(nickname: "Tom"))   // 输出: 你好,Tom
print(greetGuard(nickname: nil))     // 输出: 没有昵称