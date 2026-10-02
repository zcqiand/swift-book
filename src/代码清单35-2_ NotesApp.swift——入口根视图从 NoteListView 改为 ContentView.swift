import SwiftUI
import SwiftData

@main
struct NotesApp: App {
    var body: some Scene {
        WindowGroup {
            // 第 34 章这里是 NoteListView();本章改为 ContentView(),
            // 让 App 启动后直接进入 TabView 分栏主架构。
            ContentView()
        }
        // 在 App 顶层注入一次 SwiftData 容器,整棵视图树共享同一份存储。
        // 注入位置必须高于所有用到 @Query / modelContext 的视图,
        // 因此放在根 Scene 上而非某个子 Tab 内。
        .modelContainer(for: Note.self)
    }
}