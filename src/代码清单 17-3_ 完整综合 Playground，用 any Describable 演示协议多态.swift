// 版本基线：Swift 6.2 / Xcode 26 / iOS 26 SDK
import Foundation

protocol Describable {
    var description: String { get }
}

extension Describable {
    func printDescription() {
        // 协议已经承诺 description 一定可读，默认方法只依赖这份最小契约即可复用于所有遵守者。
        print(description)
    }
}

struct TodoItem: Describable {
    let title: String
    let isCompleted: Bool

    var description: String {
        // 状态文字由 isCompleted 推导，避免把“完成状态”和“显示文案”保存成两份可能打架的数据。
        let statusText = isCompleted ? "已完成" : "未完成"
        return "待办：\(title)（\(statusText)）"
    }
}

class Animal: Describable {
    let name: String
    let species: String

    init(name: String, species: String) {
        // 引用类型实例需要明确初始化流程，后续协议多态只关心它是否满足 Describable。
        self.name = name
        self.species = species
    }

    var description: String {
        // 类也可以用计算属性满足 { get }，协议不把实现方式限制成存储属性。
        "动物：\(name)，种类：\(species)"
    }
}

let todo = TodoItem(title: "用 any Describable 组织异构数组", isCompleted: false)
let animal = Animal(name: "旺财", species: "狗")

let items: [any Describable] = [todo, animal]

print("=== 直接读取 description ===")
for item in items {
    // any Describable 保证循环变量至少拥有 description，因此不同具体类型可以用同一套调用方式处理。
    print(item.description)
}

print("=== 调用协议扩展默认方法 ===")
for item in items {
    // TodoItem 和 Animal 没有重复实现 printDescription；共同打印逻辑来自协议扩展。
    item.printDescription()
}