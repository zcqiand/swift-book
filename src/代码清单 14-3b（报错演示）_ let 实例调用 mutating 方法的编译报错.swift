// 不会编译通过，仅展示报错，不要粘进主 Playground 运行
// 版本基线：Swift 6.2 / Xcode 26

struct Counter {
    var count = 0
    mutating func increment() { count += 1 }
}

let fixed = Counter()
// 报错：mutating 本质是「产生新值替换回变量」，let 实例无法被替换
// 报错原文从 Xcode 26 / Swift 6.2 控制台逐字复制
fixed.increment()