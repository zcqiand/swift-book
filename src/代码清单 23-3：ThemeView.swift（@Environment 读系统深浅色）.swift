import SwiftUI

/// 读系统颜色方案并据此切换文字颜色。
/// @Environment(\.colorScheme) 是「读系统值」用法，只读，
/// 与代码清单 23-4「读注入的 @Observable 对象」是两种不同语义，不可混用。
struct ThemeView: View {
    // \.colorScheme 是 SwiftUI 预置的系统环境值键路径。
    // 用户在系统设置里切深浅色，这里读到的值会自动更新，body 随之重算。
    // 注意：colorScheme 是只读的，不能写成 colorScheme = .dark。
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 12) {
            // 据系统模式选文字色：深色模式用亮黄突出，浅色模式用深蓝，
            // 保证两种背景下都有足够对比度（避免单一颜色在某模式下看不清）
            Text("当前模式：\(colorScheme == .dark ? "深色" : "浅色")")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(colorScheme == .dark ? .yellow : .blue)

            Text("系统切到深色/浅色时，这行字的颜色会自动反转")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    // 预览里可用 .preferredColorScheme 显式切换主题，
    // 无需改系统设置就能在画布里看到深色/浅色两种效果。
    // 把下面这行的 .dark 改成 .light，或注释掉，对比两种渲染。
    VStack(spacing: 24) {
        ThemeView()
            .preferredColorScheme(.dark)

        ThemeView()
            .preferredColorScheme(.light)
    }
}