import SwiftUI
import SwiftData

@main
struct NotesApp: App {
    var body: some Scene {
        WindowGroup {
            NoteListView()
        }
        // 这一行替换了第 33 章在此处预留的空白。
        // .modelContainer(for:) 会为指定模型创建一个默认的持久化容器,
        // 并把对应的 ModelContext 写入 SwiftUI 环境,于是 NoteListView 及其
        // 所有子视图都能用 @Environment(\.modelContext) 取到同一个上下文,
        // 用 @Query 直接读取数据,全程无需手动传递容器对象。
        .modelContainer(for: Note.self)
    }
}