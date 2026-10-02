import SwiftUI
import SwiftData

@main
struct NotesApp: App {
    var body: some Scene {
        WindowGroup {
            // 第 35 章把根视图从 NoteListView() 改为 ContentView()，
            // 让 App 启动后直接进入 TabView 分栏主架构。
            ContentView()
        }
        // 在 App 顶层注入一次 SwiftData 容器，整棵视图树共享同一份存储。
        // 注入位置必须高于所有用到 @Query / modelContext 的视图，
        // 缺了这行，子视图里的 @Query 会在运行时报错「找不到 ModelContainer」。
        .modelContainer(for: Note.self)
    }
}