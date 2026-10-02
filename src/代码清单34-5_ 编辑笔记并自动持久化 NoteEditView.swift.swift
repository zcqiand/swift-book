import SwiftUI
import SwiftData

struct NoteEditView: View {
    // 用 @Bindable 包裹被 @Model 管理的对象,才能把它的属性直接绑定到 TextField。
    // 它和列表里、数据库里的是同一个实例,所以这里改标题,列表会同步显示新标题。
    @Bindable var note: Note

    var body: some View {
        Form {
            Section("标题") {
                // $note.title 双向绑定:用户每敲一个字符就写回 note.title。
                TextField("输入标题", text: $note.title)
            }
            Section("正文") {
                TextEditor(text: $note.content)
                    .frame(minHeight: 200)
            }
        }
        .navigationTitle("编辑笔记")
        // 每次正文或标题变化时刷新更新时间,让列表的排序与时间戳保持准确。
        // 注意:这里只是改了 note.updatedAt 这个普通属性赋值——
        // 我们「没有」也「不需要」调用 modelContext.save()。
        // 因为 note 受 ModelContext 管理,对其属性的任何改动都会被自动追踪,
        // SwiftData 会在合适的时机(如场景进入后台)自动落盘持久化。
        // 误以为「每次改完都要手动 save」是常见的反模式,会让代码冗余且易错。
        .onChange(of: note.title) { _, _ in note.updatedAt = .now }
        .onChange(of: note.content) { _, _ in note.updatedAt = .now }
    }
}