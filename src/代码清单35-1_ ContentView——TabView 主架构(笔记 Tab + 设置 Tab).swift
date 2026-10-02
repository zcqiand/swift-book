import SwiftUI

/// App 的根视图:底部分栏(TabView)承载两个并列的功能模块。
///
/// 为什么用 TabView 而不是把所有页塞进一个 NavigationStack:
/// 「笔记」和「设置」是两条平行的导航分支,用户在设置里 push 到
/// 「关于」页后切回笔记,再切回设置时应保留刚才的导航位置。只有
/// 每个 Tab 各自持有独立的 NavigationStack 才能实现这种「各走各路」
/// 的体验;单一 NavigationStack 做不到分支隔离。
struct ContentView: View {
    var body: some View {
        // iOS 26 SDK 的 Tab(...) {} 写法:标签的标题、图标、内容
        // 在同一处声明,编译期即可校验,比旧版 .tabItem 修饰符更不易错配。
        TabView {
            Tab("笔记", systemImage: "note.text") {
                // NoteListView 内部已含自己的 NavigationStack(来自第 34 章),
                // 这里直接放入即可,切勿再包一层 NavigationStack。
                NoteListView()
            }

            Tab("设置", systemImage: "gearshape") {
                // SettingsView 同样自带 NavigationStack,以支持 push 到「关于」子页。
                SettingsView()
            }
        }
    }
}

#Preview {
    // 预览也要挂载内存版 SwiftData 容器,否则 NoteListView 的 @Query 会因
    // 缺少 ModelContainer 而崩溃。isStoredInMemoryOnly 让预览数据不落盘。
    ContentView()
        .modelContainer(for: Note.self, inMemory: true)
}