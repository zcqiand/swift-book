import Foundation
import SwiftData

// @Model 是 SwiftData 的持久化模型，第33章已定义。
// 它是 class（引用类型），生命周期绑定 ModelContext，且非 Sendable，
// 因此绝不能直接把 Note 实例传进 actor 或 Task.detached——那会触发数据竞争。
@Model
final class Note {
    var title: String
    var content: String
    var updatedAt: Date
    var imageData: Data?

    init(title: String, content: String, updatedAt: Date = .now, imageData: Data? = nil) {
        self.title = title
        self.content = content
        self.updatedAt = updatedAt
        self.imageData = imageData
    }
}

// NoteDTO 用 struct 而非 class：值类型在传递时整份拷贝，天生无共享可变状态，
// 所以编译器能自动推断它符合 Sendable——这正是它能安全跨越并发域的根本原因。
// 只要所有存储属性本身都是 Sendable（String/Date/UUID/Data 都是），
// 整个 struct 就自动 Sendable，无需手写任何同步代码。
struct NoteDTO: Sendable, Identifiable {
    let id: UUID
    let title: String
    let content: String
    let updatedAt: Date
    // 用 imageData 的字节数代替原始 Data 参与去重判断时更轻量；
    // 这里保留完整字节以便写回，Data 本身也是 Sendable。
    let imageData: Data?
}

extension Note {
    // 把引用类型 Note「快照」成值类型 DTO：读取发生在持有 Note 的并发域内，
    // 拷贝出去的是独立的值，之后无论传到哪个 Task 都不会回头触碰 Note。
    func toDTO(id: UUID = UUID()) -> NoteDTO {
        NoteDTO(
            id: id,
            title: title,
            content: content,
            updatedAt: updatedAt,
            imageData: imageData
        )
    }
}

extension NoteDTO {
    // 把 DTO 写回本地 Note：必须在持有 ModelContext 的并发域（通常是 @MainActor）执行。
    // updatedAt 更新由调用方决定，这里仅做字段覆盖，保持函数纯粹。
    func apply(to note: Note) {
        note.title = title
        note.content = content
        note.updatedAt = updatedAt
        note.imageData = imageData
    }

    // 从 DTO 新建一个 Note（用于本地不存在该笔记时的插入场景）。
    func makeNote() -> Note {
        Note(title: title, content: content, updatedAt: updatedAt, imageData: imageData)
    }
}