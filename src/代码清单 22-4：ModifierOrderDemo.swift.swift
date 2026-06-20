import SwiftUI

/// 修饰符顺序敏感对照实验。
/// 左右两个 Text 字号、padding 数值完全一致，仅修饰符顺序不同，
/// 直观展示「padding 与 background 谁先」对背景范围的影响。
struct ModifierOrderDemo: View {
    var body: some View {
        HStack(spacing: 32) {
            // 左侧：padding 在前 → background 在外层
            // 执行顺序：先给 Text 加 20pt 内边距，
            // 再把这「文字 + 边距」整体涂蓝，于是蓝底覆盖内容包括边距
            Text("padding 在前")
                .font(.body)
                .foregroundStyle(.white)
                .padding(20)
                .background(.blue)

            // 右侧：background 在前 → padding 在外层
            // 执行顺序：先给文字本身涂蓝（背景只盖文字尺寸），
            // 再在「带蓝底的文字」外加 20pt 内边距，
            // 于是边距落在屏幕底色上，蓝底只盖文字
            Text("background 在前")
                .font(.body)
                .foregroundStyle(.white)
                .background(.blue)
                .padding(20)
        }
    }
}

#Preview {
    ModifierOrderDemo()
        .padding()
}