import SwiftUI
import SwiftData

@main
struct NotesApp: App {
    // 把容器作为 App 的存储属性,只在启动时构造一次。
    // 用 let 而非每次 body 求值都新建,避免重复建库与上下文不一致。
    let modelContainer: ModelContainer

    init() {
        do {
            // 显式构造时可传入配置,例如下面注释的内存模式常用于单元测试,
            // 让数据只存在内存中、随进程退出而清空,不污染真机数据库。
            // let config = ModelConfiguration(isStoredInMemoryOnly: true)
            // modelContainer = try ModelContainer(for: Note.self, configurations: config)
            modelContainer = try ModelContainer(for: Note.self)
        } catch {
            // 出版级代码不忽略错误:这里把失败原因打印出来再终止,
            // 比起静默崩溃,开发阶段能立刻看到「为什么建库失败」。
            fatalError("无法创建 ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            NoteListView()
        }
        // 注入「已经构造好」的容器实例,而不是让系统再隐式建一个。
        .modelContainer(modelContainer)
    }
}