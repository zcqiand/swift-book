import SwiftUI
import SwiftData

/// 第 34 章 NoteListView 的增强版:在原有「List + NavigationLink(value:)」基础上,
/// 增加由代码掌控的导航路径(NavigationPath),以演示编程式跳转与一键回到根。
/// 与第 34 章原版二选一使用,请勿同时注册到同一处。
struct NoteListViewWithPath: View {
    // SwiftData 查询:按更新时间倒序,最新编辑的笔记排最前。
    @Query(sort: \Note.updatedAt, order: .reverse) private var notes: [Note]

    // 取得当前 ModelContext,用于新增 / 删除等写操作;
    // 由 App 顶层 .modelContainer 注入,子视图直接从环境读取。
    @Environment(\.modelContext) private var modelContext

    // 关键改动:把导航栈提升为可读写的状态。第 34 章用无参 NavigationStack,
    // 栈内容对代码不可见;持有 NavigationPath 后,append/removeLast 即可
    // 用代码精确控制「进到哪一页」「退回哪一层」。
    @State private var navigationPath = NavigationPath()

    var body: some View {
        // path: 绑定让 NavigationStack 的实际栈与 navigationPath 双向同步——
        // 用户点击导航产生的变化会写回 navigationPath,代码改 navigationPath
        // 也会驱动界面跳转。
        NavigationStack(path: $navigationPath) {
            List {
                ForEach(notes) { note in
                    // 仍用基于值的 NavigationLink(value:),与第 34 章一致。
                    // 用户点击时,系统会把该 note 追加进 navigationPath。
                    NavigationLink(value: note) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(note.title.isEmpty ? "无标题" : note.title)
                                .font(.headline)
                            Text(note.content)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }
                }
                .onDelete(perform: deleteNotes)
            }
            .navigationTitle("笔记")
            // 值类型 Note 到目的地 NoteEditView 的映射,整栈共用这一条规则,
            // 无论笔记是被用户点击还是被代码 append 进来,都走这里。
            .navigationDestination(for: Note.self) { note in
                NoteEditView(note: note)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("新增", systemImage: "plus", action: addNote)
                }
                // 一键回到根:只有当栈非空(确实 push 过子页)时才显示,
                // 避免在已是根页时出现无意义按钮。
                if !navigationPath.isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("回到列表") {
                            // removeLast(count) 一次性弹出全部层级,
                            // 等价于「连续点多次返回」,直接回到列表根。
                            navigationPath.removeLast(navigationPath.count)
                        }
                    }
                }
            }
            // 编程式跳转示例:不依赖用户点击列表,用代码 push 到第一条笔记。
            .safeAreaInset(edge: .bottom) {
                Button {
                    if let firstNote = notes.first {
                        // append 把目标值压入路径,NavigationStack 立即跳转到
                        // 对应的 navigationDestination,无需任何 NavigationLink。
                        navigationPath.append(firstNote)
                    }
                } label: {
                    Label("打开最新一条笔记", systemImage: "arrow.up.forward.app")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                // 没有笔记时禁用,避免点了没反应造成困惑。
                .disabled(notes.isEmpty)
                .padding(.horizontal)
            }
        }
    }

    /// 新增一条空笔记并立即跳转到它的编辑页。
    /// 演示「新增 + 编程式跳转」的组合:插入后用 append 直接进入编辑。
    private func addNote() {
        let newNote = Note(title: "", content: "", updatedAt: .now)
        modelContext.insert(newNote)
        // 插入后立刻 push,用户无需回列表再点一次,体验更顺。
        navigationPath.append(newNote)
    }

    /// 按列表偏移删除笔记。从当前 notes 数组取到对象后交给 modelContext 删除,
    /// SwiftData 会自动持久化这次变更,无需手动 save。
    private func deleteNotes(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(notes[index])
        }
    }
}

#Preview {
    NoteListViewWithPath()
        .modelContainer(for: Note.self, inMemory: true)
}