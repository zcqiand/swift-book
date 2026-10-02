import Foundation

// 第一段:安全路径——nil 时走 ?? 给默认值,永不崩溃
let nickname: String? = nil
print(nickname ?? "匿名用户")
// 输出: 匿名用户

// 第二段:危险路径——对 nil 强制解包触发运行时崩溃
// 以下代码会运行时崩溃,仅展示报错,不会编译运行成功。
// 如果你想亲眼看一次崩溃,新建一个独立 Playground 仅粘贴下方两行(不要放进本章主文件):
//
//   let bad: String? = nil
//   print(bad!)
//
// Xcode 26 / Swift 6.2 控制台预期崩溃原文:
//   Fatal error: Unexpectedly found nil while unwrapping an Optional value
//   (Program ended with exit code: signal SIGABRT / exited with code = 1)
//
// 心法:实际工程中 99% 的强制解包都可以用 if let / guard let / ?? 替代,
// 除非你 100% 确定此刻非 nil(例如字面量初始化的常量、或来自不可能为空的来源),
// 否则一律别用 !——它把「可能没有」的警告信号在编译期抹平,却把惩罚推到运行期。