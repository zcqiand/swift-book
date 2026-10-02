import SwiftUI

struct ContentView: View {
    var body: some View {
        // iOS 26 SDK 的 Tab(...) {} 写法：标签的标题、图标、内容
        // 在同一处声明，编译期即可校验，比旧版 .tabItem 修饰符更不易错配。
        TabView {
            Tab("笔记", systemImage: "note.text") {
                // NoteListView 内部已含自己的 NavigationStack（来自第 34 章），
                // 此处直接放入即可，切勿再外包一层 NavigationStack。
                NoteListView()
            }

            Tab("设置", systemImage: "gearshape") {
                // SettingsView 同样自带 NavigationStack，以支持 push 到「关于」子页，
                // 同理不再外包。
                SettingsView()
            }
        }
    }
}

#Preview {
    // 预览也需要内存容器，否则 NoteListView 的 @Query 无数据来源会崩。
    ContentView()
        .modelContainer(for: Note.self, inMemory: true)
}