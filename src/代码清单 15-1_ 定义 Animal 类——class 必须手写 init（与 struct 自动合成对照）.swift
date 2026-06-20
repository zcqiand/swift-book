// 版本基线：Swift 6.2 / Xcode 26 / iOS 26 SDK
import Foundation

// class 是引用类型：与 struct 不同，编译器不会自动合成成员初始化器
// 因此每个 class 至少要手写一个 init，否则报 "has no initializers"
class Animal {
    // 存储属性：与 struct 写法相同，但语义是「堆上实例的成员」而非「栈上值」
    var name: String

    // class 必须手写 init：把传入的 name 装进实例
    // （struct 同样的属性会自动合成 init(name:)，class 不会）
    init(name: String) {
        // self.name 区分参数与属性：左侧是属性，右侧是参数
        self.name = name
    }

    // class 方法不需要 mutating：引用类型直接改实例本体，没有「复制替换」步骤
    func speak() {
        // 默认行为：动物知道自己的名字，但只会发出通用声音
        print("\(name) 发声")
    }
}

// 实例化必须传 name——因为没有无参 init
let animal = Animal(name: "阿白")
animal.speak()