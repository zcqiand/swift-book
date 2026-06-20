import SwiftUI

/// 整合 VStack / HStack / 修饰符的卡片组件。
/// 作为本章最终交付物：可直接粘进 Xcode 26 项目运行。
struct CardView: View {
    var body: some View {
        // 外层 VStack 把标题、副标题、说明三部分竖直堆叠
        // spacing: 12 控制三部分之间的竖直间隙
        VStack(spacing: 12) {
            // 主标题：大号粗体白色，承担卡片信息层级最高位
            Text("SwiftUI 布局")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            // 副标题：次级信息，用白色透明度（.white.opacity(0.8)）弱化，
            // 而非用 .secondary —— secondary 在深色背景上对比度不足。
            // .opacity(0.8) 表示 80% 不透明度的白色（数值越小越透明）
            Text("组合三大容器搭建界面")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))

            // HStack 水平排列图标 + 说明文字，作为卡片底部信息行
            // .firstTextBaseline 让图标与文字基线对齐，视觉更紧凑
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Image(systemName: "sparkles")
                    .foregroundStyle(.yellow)
                Text("VStack + HStack + ZStack")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.9))
            }
        }
        // 先 padding 再 background：让圆角蓝底覆盖「内容 + 20pt 内边距」整块，
        // 形成视觉上「内容被蓝底包裹」的卡片效果
        .padding(20)
        // iOS 26 新 API：一次性完成「蓝底 + 12pt 圆角」，
        // 取代已弃用的 .background(Color.blue).cornerRadius(12) 两步写法
        .background(.blue, in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    // Preview 用 ZStack 给个浅灰底，让蓝色卡片更突出
    ZStack {
        Color(.systemGroupedBackground)
        CardView()
    }
    .ignoresSafeArea()
}