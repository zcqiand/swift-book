import Foundation
import SwiftData

// @Model 宏让 SwiftData 自动为这个类生成持久化能力,
// 任何被它修饰的存储属性发生变更,都会被自动写入数据库,无需手动 save。
@Model
final class Note {
    var title: String
    var content: String
    var updatedAt: Date

    // 用 Data? 而非直接存 Image:
    // 1) SwiftData 只能持久化 Codable/原生类型,SwiftUI 的 Image 不可直接落盘;
    // 2) 用可选类型表达「这条笔记可以没有配图」这一真实业务语义。
    var imageData: Data?

    // 给 imageData 默认值 nil,是为了让老代码(第34章只传三个参数的调用)
    // 在不修改的情况下依然能编译通过,平滑升级。
    init(title: String, content: String, updatedAt: Date = .now, imageData: Data? = nil) {
        self.title = title
        self.content = content
        self.updatedAt = updatedAt
        self.imageData = imageData
    }
}