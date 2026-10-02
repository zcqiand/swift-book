import Foundation
import SwiftData

// @Model 是 SwiftData 的核心宏。它只能标注 class 而不能标注 struct,
// 因为持久化对象需要稳定的身份(identity)与引用语义:同一条笔记在列表、
// 编辑页、数据库中必须是「同一个实例」,对它的修改才能被 ModelContext 追踪。
// 这正是这里用 class(引用类型)而非 struct(值类型)的根本原因。
// 加 final 是因为 SwiftData 模型不需要被继承,final 能让编译器做更多优化,
// 也避免子类化带来的持久化歧义。
@Model
final class Note {
    // 这三个普通存储属性会被 @Model 宏在编译期自动改写为「持久化属性」,
    // 即每次读写都会经过底层存储。我们写的是普通 Swift 属性,
    // 持久化能力是宏免费赠送的,无需手动写任何 SQL 或映射代码。
    var title: String
    var content: String
    var updatedAt: Date

    // 初始化器给出默认值,让「新建一条空笔记」可以一行写成 Note()。
    // updatedAt 默认取当前时间,保证新笔记天然带有正确的时间戳。
    init(title: String = "", content: String = "", updatedAt: Date = .now) {
        self.title = title
        self.content = content
        self.updatedAt = updatedAt
    }
}