import SwiftUI

/// 用 @State 驱动的本地计数器视图。
/// count 是视图私有状态，点击按钮改写它后 body 自动重算。
struct CounterView: View {
    // @State 把 count 交给 SwiftUI 托管：值变化时框架自动重算 body，
    // 而不是靠 willSet/didSet 触发回调（见第 16 章 16.4 节衔接说明）。
    // 初始值 0 直接写在这里，@State 必须有初值，外部不应通过 init 覆写。
    @State private var count: Int = 0

    var body: some View {
        VStack(spacing: 16) {
            // 显示当前计数：每次 count 变化，这一行都会被重新求值并刷新
            Text("当前计数：\(count)")
                .font(.title)
                .fontWeight(.semibold)

            // Button 的 action 闭包里改写 count 即可触发刷新。
            // 第 22 章 VStackDemo 的 Button 闭包留空标「第 23 章讲解」，
            // 这里就是那句留空的正式兑现：count += 1 让数字递增。
            Button("点我 +1") {
                count += 1
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    CounterView()
}