import SwiftUI
import SwiftData
import UIKit  // UIPasteboard 来自 UIKit,用于「复制」到系统剪贴板

struct NoteListView: View {
    // @Query 自动从数据库拉取全部笔记并保持界面同步,
    // 按更新时间倒序,让最近编辑的笔记排在最上面。
    @Query(sort: \Note.updatedAt, order: .reverse) private var notes: [Note]

    // 删除操作需要数据库上下文:context.delete 后变更自动持久化。
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        // 沿用第35章的导航结构:列表行用 NavigationLink(value:) 触发 push,
        // 由 navigationDestination 决定目标页面,做到值驱动导航。
        NavigationStack {
            List {
                ForEach(notes) { note in
                    NavigationLink(value: note) {
                        NoteRow(note: note)
                    }
                    // 左滑手势:用 swipeActions 声明式生成滑动按钮,
                    // role: .destructive 让系统自动渲染成红色删除样式,无需手写 DragGesture。
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            delete(note)
                        } label: {
                            Label("删除", systemImage: "trash")
                        }
                    }
                    // 长按手势:contextMenu 声明式生成长按弹出菜单,
                    // 三项操作分别对应复制、分享、删除,无需手写 LongPressGesture。
                    .contextMenu {
                        Button {
                            copy(note)
                        } label: {
                            Label("复制内容", systemImage: "doc.on.doc")
                        }

                        // ShareLink 是 SwiftUI 原生分享入口,直接拉起系统分享面板,
                        // 把笔记正文作为分享内容。
                        ShareLink(item: note.content) {
                            Label("分享", systemImage: "square.and.arrow.up")
                        }

                        Button(role: .destructive) {
                            delete(note)
                        } label: {
                            Label("删除", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("我的笔记")
            // 承接第35章:值类型为 Note 时,统一 push 到编辑页。
            .navigationDestination(for: Note.self) { note in
                NoteEditView(note: note)
            }
        }
    }

    // 从数据库删除一条笔记;delete 后 @Query 会自动刷新列表,行随之消失。
    private func delete(_ note: Note) {
        modelContext.delete(note)
    }

    // 把笔记正文写入系统剪贴板,用户可在任意 App 里粘贴。
    // UIPasteboard.general 是全局共享剪贴板。
    private func copy(_ note: Note) {
        UIPasteboard.general.string = note.content
    }
}

// 单独抽出列表行视图,让列表结构清晰、行样式可复用。
struct NoteRow: View {
    let note: Note

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(note.title.isEmpty ? "无标题" : note.title)
                .font(.headline)
            Text(note.content)
                .font(.subheadline)
                .foregroundStyle(.secondary)  // 次要信息用 .foregroundStyle 弱化
                .lineLimit(1)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    // 同样用内存数据库做预览,并预置两条样例数据,方便直接看到列表与手势效果。
    let container = try! ModelContainer(
        for: Note.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    container.mainContext.insert(Note(title: "购物清单", content: "牛奶、鸡蛋、面包"))
    container.mainContext.insert(Note(title: "会议纪要", content: "下周一上午十点对齐项目进度。"))

    return NoteListView()
        .modelContainer(container)
}