import SwiftUI
import SwiftData

struct NoteListView: View {
    // @Query 把数据库查询声明式地绑定到视图:notes 始终是数据库的最新结果。
    // 当任何笔记被插入、删除或修改,@Query 会自动触发视图刷新,
    // 这就是为什么后面新增/删除后不需要我们手动调用任何 setState 之类的操作。
    // sort 指定按 updatedAt 倒序,让最近编辑的笔记排在最上面。
    @Query(sort: \Note.updatedAt, order: .reverse)
    private var notes: [Note]

    // 从环境取出 App 入口注入的那个 ModelContext。
    // 所有写操作(insert/delete)都通过它进行。
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        // 用 NavigationStack 而非已弃用的 NavigationView。
        NavigationStack {
            Group {
                if notes.isEmpty {
                    // 空状态延续第 33 章风格,用系统的 ContentUnavailableView,
                    // 它在 iOS 26 下自带 Liquid Glass 观感,无需我们手绘空页。
                    ContentUnavailableView(
                        "还没有笔记",
                        systemImage: "note.text",
                        description: Text("点击右上角加号,新建第一条笔记")
                    )
                } else {
                    List {
                        ForEach(notes) { note in
                            // value-based 导航:把笔记本身作为路由值传出去,
                            // 由下面的 navigationDestination 统一决定目的地。
                            // 这比 NavigationLink(destination:) 更适合做主导航路径,
                            // 因为路由值与目的地解耦,便于后续做深层链接与状态恢复。
                            NavigationLink(value: note) {
                                rowContent(for: note)
                            }
                        }
                        // onDelete 提供系统级左滑删除手势。
                        .onDelete(perform: deleteNotes)
                    }
                }
            }
            .navigationTitle("我的笔记")
            // 声明:当路由值是 Note 时,跳转到编辑页。
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

    // 单行内容抽成方法,让 body 的导航结构保持清晰、避免嵌套过深。
    private func rowContent(for note: Note) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            // 标题可能为空(刚新建时),用占位文案避免出现空白行让人误以为出错。
            Text(note.title.isEmpty ? "未命名笔记" : note.title)
                .font(.headline)
            // 用 .foregroundStyle 而非已不推荐的 .foregroundColor。
            Text(note.updatedAt, format: .dateTime.year().month().day().hour().minute())
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func addNote() {
        // insert 把新对象交给上下文管理,@Query 随即感知到变化并刷新列表。
        // 新笔记 updatedAt 默认是当前时间,因此会自动排到列表最顶部。
        let newNote = Note(title: "新笔记")
        modelContext.insert(newNote)
    }

    private func deleteNotes(at offsets: IndexSet) {
        // offsets 是被滑动删除的行号集合,逐个从上下文删除对应笔记。
        for index in offsets {
            modelContext.delete(notes[index])
        }
    }
}