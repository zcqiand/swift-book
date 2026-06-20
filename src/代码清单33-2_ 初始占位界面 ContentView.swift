import SwiftUI

/// App 的初始界面(骨架占位)。
///
/// 本章只渲染一个"空状态"占位界面,真正的笔记列表会在第 34、35 章接入
/// 数据源与多页面导航后实现。此处用 NavigationStack 而非已弃用的
/// NavigationView,是因为 iOS 26 SDK 已将 NavigationView 标记弃用,
/// NavigationStack 是当前唯一推荐的栈式导航容器。
struct ContentView: View {
    var body: some View {
        NavigationStack {
            // ContentUnavailableView 是系统提供的标准"空状态"视图,
            // 用它而非自己拼布局栈,能直接获得与系统一致的留白、字号与图标排版,
            // 也会自动适配 Liquid Glass 的视觉风格。
            ContentUnavailableView {
                Label("还没有笔记", systemImage: "note.text")
            } description: {
                // 用 .foregroundStyle 而非已不推荐的 .foregroundColor,
                // foregroundStyle 支持更丰富的样式来源(颜色、渐变、材质),是 iOS 26 推荐写法。
                Text("笔记列表将在后续章节实现")
                    .foregroundStyle(.secondary)
            }
            .navigationTitle("我的笔记")
        }
    }
}

#Preview {
    ContentView()
}