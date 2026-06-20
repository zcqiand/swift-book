// 版本基线：Swift 6.2 / Xcode 26 / iOS 26 SDK
import Foundation

// 这里先定义最简 Dog 类（不继承），专做引用语义演示
// 继承版本留给清单 15-3，避免前向引用把读者绕晕
class Dog {
    // 给默认值，省去 init，让对照实验聚焦「赋值即共享」这一点
    var name: String = "旺财"

    func speak() {
        print("\(name) 发声")
    }
}

let a = Dog()        // a 持有指向堆上 Dog 实例的引用
let b = a            // 引用语义：b 复制的是「引用（地址）」，不是内容
                    // 此时 a 和 b 指向堆上同一个实例（别名关系）

// 改 b 的属性，等同于改了堆上那个共享实例的 name
b.name = "改了副本"

// 回扣第 14 章 14.4 节：同样的赋值语句，struct 复制独立，class 共享同一实例
// 区别全在值/引用语义——这正是本章开头要建立的直觉
print("a.name: \(a.name)")
print("b.name: \(b.name)")

// 进一步验证：两者引用相等（=== 表示同一实例）
print("a 与 b 是否同一实例：\(a === b)")