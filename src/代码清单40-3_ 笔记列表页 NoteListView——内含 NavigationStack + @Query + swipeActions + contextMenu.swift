import SwiftUI
import SwiftData
import UIKit  // UIPasteboard 来自 UIKit，用于「复制」到系统剪贴板

struct NoteListView: View {
    // @Query 直接声明「我要按更新时间倒序的全部笔记」，
    // SwiftData 负责查询、监听变化、自动刷新。无需手写 fetch、无需手动 reload。
    @Query(sort: \Note.updatedAt, order: .reverse) private var notes: [Note]

    // 拿到当前环境的 ModelContext 才能执行插入/删除（写操作）。
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        // NoteListView 自带 NavigationStack（第 34 章既定），
        // TabView 那一层不再外包，避免双层嵌套。
        NavigationStack {
            List {
                ForEach(notes) { note in
                    // 点击行进入编辑页：值驱动导航，由下方 navigationDestination 决定目的地。
                    NavigationLink(value: note) {
                        NoteRow(note: note)
                    }
                    // 左滑出现删除按钮。role: .destructive 让按钮显示为红色，符合系统语义。
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            delete(note)
                        } label: {
                            Label("删除", systemImage: "trash")
                        }
                    }
                    // 长按弹出上下文菜单：复制正文到剪贴板、用 ShareLink 分享、删除。
                    .contextMenu {
                        Button {
                            copy(note)
                        } label: {
                            Label("复制内容", systemImage: "doc.on.doc")
                        }
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
            // 目标类型绑定到编辑页：点击哪条笔记就把哪条传进 NoteEditView。
            .navigationDestination(for: Note.self) { note in
                NoteEditView(note: note)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: addNote) {
                        Label("新建笔记", systemImage: "plus")
                    }
                }
            }
        }
    }

    // 新建一条空白笔记并立即插入上下文，@Query 会立刻把它显示在列表顶部。
    // content 是普通 String，新建时传空字符串即可（第 34、36 章既定类型）。
    private func addNote() {
        let newNote = Note(title: "无标题笔记", content: "")
        modelContext.insert(newNote)
    }

    private func delete(_ note: Note) {
        modelContext.delete(note)
    }

    // 把笔记正文写入系统剪贴板，用户可在任意 App 里粘贴。
    private func copy(_ note: Note) {
        UIPasteboard.general.string = note.content
    }
}

// 单独抽出列表行视图，保持 NoteListView 的 body 聚焦在「列表与交互」上。
struct NoteRow: View {
    let note: Note

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(note.title.isEmpty ? "无标题" : note.title)
                .font(.headline)
            Text(note.updatedAt, format: .dateTime.year().month().day())
                // 用 .foregroundStyle 而非已不推荐的 .foregroundColor。
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}