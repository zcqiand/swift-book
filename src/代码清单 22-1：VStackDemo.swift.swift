import SwiftUI

/// 演示 VStack 的默认居中、spacing 参数。
/// 不绑按钮 action —— 点击交互在第 23 章「状态与交互」讲解。
struct VStackDemo: View {
    var body: some View {
        // spacing: 16 让三个子视图之间留 16pt 竖直间隙，
        // 比默认值更宽松，避免标题/副标题/按钮视觉拥挤
        VStack(spacing: 16) {
            Text("SwiftUI 布局入门")
                .font(.largeTitle)
                .fontWeight(.bold)

            // 副标题用 secondary 色，与主标题形成主次层级
            Text("用组合式声明搭建界面")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            // 按钮此处只作为「子视图」演示布局，不绑 action
            // 闭包留空 + 注释说明，避免引入第 23 章才讲的交互
            Button("开始学习") {
                // 点击交互逻辑在第 23 章讲解
            }
        }
    }
}

#Preview {
    VStackDemo()
        .padding()
}