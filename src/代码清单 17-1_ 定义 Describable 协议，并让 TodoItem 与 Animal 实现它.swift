// 版本基线：Swift 6.2 / Xcode 26 / iOS 26 SDK
import Foundation

protocol Describable {
    var description: String { get }
}

struct TodoItem: Describable {
    let title: String
    let isCompleted: Bool

    var description: String {
        // description 能由 title 与 isCompleted 推导出来，写成计算属性可避免保存两份可能不同步的文字。
        let statusText = isCompleted ? "已完成" : "未完成"
        return "待办：\(title)（\(statusText)）"
    }
}

class Animal: Describable {
    let name: String
    let species: String

    init(name: String, species: String) {
        // class 没有结构体那种自动合成成员初始化器，必须在 init 中给存储属性明确初值来源。
        self.name = name
        self.species = species
    }

    var description: String {
        // description 从已有存储属性实时计算，协议不限制内部必须用哪种保存方式。
        "动物：\(name)，种类：\(species)"
    }
}

let todo = TodoItem(title: "学习 Swift 协议", isCompleted: false)
let animal = Animal(name: "旺财", species: "狗")

print(todo.description)
print(animal.description)