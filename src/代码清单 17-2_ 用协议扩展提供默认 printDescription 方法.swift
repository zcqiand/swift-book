// 版本基线：Swift 6.2 / Xcode 26 / iOS 26 SDK
import Foundation

protocol Describable {
    var description: String { get }
}

extension Describable {
    func printDescription() {
        // 默认实现依赖协议已经保证存在的 description，因此任何遵守者都能安全复用这段逻辑。
        print(description)
    }
}

struct TodoItem: Describable {
    let title: String
    let isCompleted: Bool

    var description: String {
        // 用计算属性而不是额外存储一段描述文本，是为了让描述始终跟随真实状态生成。
        let statusText = isCompleted ? "已完成" : "未完成"
        return "待办：\(title)（\(statusText)）"
    }
}

class Animal: Describable {
    let name: String
    let species: String

    init(name: String, species: String) {
        // class 的存储属性必须在初始化阶段全部赋值，避免实例半初始化。
        self.name = name
        self.species = species
    }

    var description: String {
        // Animal 自己决定描述格式，协议只要求外部最终能读到 String。
        "动物：\(name)，种类：\(species)"
    }
}

let todo = TodoItem(title: "完成第 17 章练习", isCompleted: true)
let animal = Animal(name: "雪球", species: "猫")

todo.printDescription()
animal.printDescription()