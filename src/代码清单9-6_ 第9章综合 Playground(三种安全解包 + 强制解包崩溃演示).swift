import Foundation

// 一、if let 安全解包
// 为什么这样写:if let 适合「两种分支都要走」的场景(成功做 A、失败做 B)
// 解包出的常量只在 if 花括号内可用——这是它和 guard let 的关键差异
func greetIfLet(nickname: String?) -> String {
    if let nickname {
        return "你好,\(nickname)"
    } else {
        return "没有昵称"
    }
}

print("一、if let 安全解包:")
print(greetIfLet(nickname: "Tom"))   // 输出: 你好,Tom
print(greetIfLet(nickname: nil))     // 输出: 没有昵称

// 二、guard let 提前退出(兑现第 7 章 7.4 节钩子)
// 为什么这样写:guard let 把「不合格先走人」的逻辑压到函数开头,主逻辑保持扁平
// 关键点:guard let 解包出的 nickname 在 guard 之后整个函数体都可用,作用域向外延伸
// 因此函数返回类型可以直接写 String(非可选),不必带问号
func greetGuard(nickname: String?) -> String {
    guard let nickname else {
        return "没有昵称"
    }
    return "你好,\(nickname)"
}

print("\n二、guard let 提前退出:")
print(greetGuard(nickname: "Tom"))   // 输出: 你好,Tom
print(greetGuard(nickname: nil))     // 输出: 没有昵称

// 三、空合 ?? 提供默认值
// 为什么这样写:?? 是「缺省值一行搞定」的语法糖,是非问题不写分支,最简洁
// 等价于「nickname 有值就解包返回,nil 就返回右侧默认值」,永远安全不崩溃
func greetCoalescing(nickname: String?) -> String {
    return nickname ?? "匿名用户"
}

print("\n三、空合 ?? 提供默认值:")
print(greetCoalescing(nickname: "Tom"))   // 输出: Tom
print(greetCoalescing(nickname: nil))     // 输出: 匿名用户

// 四、强制解包 ! 陷阱(用注释保留崩溃代码,仅展示报错)
// 以下代码会运行时崩溃,仅展示报错,不会编译运行成功。
// 如需亲眼看一次崩溃,请新建一个独立 Playground,仅粘贴下方两行:
//
//   let bad: String? = nil
//   print(bad!)
//
// Xcode 26 / Swift 6.2 控制台预期崩溃原文:
//   Fatal error: Unexpectedly found nil while unwrapping an Optional value
//   (Program ended with exit code: signal SIGABRT / exited with code = 1)
//
// 心法:实际工程中 99% 的强制解包都可以用 if let / guard let / ?? 替代,
// 除非你 100% 确定此刻非 nil,否则一律别用 !。