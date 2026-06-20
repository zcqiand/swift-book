import SwiftUI

/// 笔记 App 的程序入口。
///
/// 注意:本章入口保持最简,不挂任何持久化容器。
/// 持久化容器(SwiftData 的 .modelContainer)将于第 34 章在此处注入,
/// 现在提前留空,是为了让读者先确认"空工程能独立跑起来"这一最小闭环。
@main
struct NotesApp: App {
    var body: some Scene {
        // WindowGroup 是 iOS App 的标准场景容器:
        // 它为 App 管理窗口生命周期,并把根视图 ContentView 接入界面层级。
        WindowGroup {
            ContentView()
        }
    }
}