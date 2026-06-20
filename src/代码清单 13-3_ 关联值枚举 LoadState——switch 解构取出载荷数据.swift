import Foundation

// 关联值枚举：每个 case 可携带类型化载荷数据
// 与原始值的本质差异：关联值属于「实例级数据」——同一个 .loaded 每次可带不同字符串；
// 而原始值属于「case 级标识」——定义时固定，所有实例共享
enum LoadState {
    // loading 不携带数据，表示「加载中」这一纯状态
    case loading
    // loaded 携带一个 String 关联值，标签为 data，表示「成功并带回数据」
    case loaded(data: String)
    // failed 携带一个 String 关联值，标签为 error，表示「失败并带回错误原因」
    case failed(error: String)
}

// handle 函数用 switch 处理 LoadState 三态，switch 必须穷尽三个 case
// 关联值用 case .loaded(let data) 模式解构——把载荷绑定到临时常量 data
func handle(state: LoadState) -> String {
    switch state {
    case .loading:
        // loading 无关联值，直接返回固定提示
        return "加载中…"
    case .loaded(let data):
        // 用 let 把 .loaded 携带的 String 绑定到常量 data，分支内即可使用该数据
        return "数据: \(data)"
    case .failed(let error):
        // 同理解构 failed 的关联值，取出错误原因
        return "错误: \(error)"
    }
    // 若漏写 .loading，编译器会报错「switch must be exhaustive, missing case 'loading'」
    // 这条保证你在第 7 章 7.5 节已经亲眼看过，这里不展开报错演示
}

// 三次调用覆盖三个 case，验证每个分支的输出
print(handle(state: .loading))
// 输出: 加载中…
print(handle(state: .loaded(data: "北京 26°C 晴")))
// 输出: 数据: 北京 26°C 晴
print(handle(state: .failed(error: "网络超时")))
// 输出: 错误: 网络超时