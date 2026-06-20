import SwiftUI

/// 演示 HStack 的水平排列、alignment 与 spacing。
/// 用 .firstTextBaseline 让图标与文字底部基线对齐，
/// 避免图标默认垂直居中导致与文字「飘」开的视觉错位。
struct HStackDemo: View {
    var body: some View {
        VStack(spacing: 24) {
            // 对照组 1：默认 .center 对齐
            // spacing: 8 控制图标与文字的水平间距
            HStack(alignment: .center, spacing: 8) {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                Text("默认居中对齐")
                    .font(.body)
            }

            // 对照组 2：.firstTextBaseline 对齐
            // 图标按文字「基线」对齐，适合「图标 + 文字」行内标签
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                Text("基线对齐")
                    .font(.body)
            }
        }
    }
}

#Preview {
    HStackDemo()
        .padding()
}