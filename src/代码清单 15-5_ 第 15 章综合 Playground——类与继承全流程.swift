// 版本基线：Swift 6.2 / Xcode 26 / iOS 26 SDK
import Foundation

// ============ 第一步：定义父类 Animal（class 必须手写 init）============
print("=== 第一步：定义父类 Animal ===")

class Animal {
    var name: String

    // class 不自动合成 init，必须手写——这是 class 与 struct 第一处差别
    init(name: String) {
        self.name = name
    }

    func speak() {
        // 父类默认行为，子类可重写
        print("\(name) 发声")
    }
}

// 父类直接使用：实例化必须传 name
let generic = Animal(name: "无名氏")
generic.speak()

// ============ 第二步：Dog 继承 Animal 并 override speak ============
print("\n=== 第二步：Dog 继承 Animal，override speak 改输出「汪汪」 ===")

class Dog: Animal {
    // override 关键字硬性要求：漏写会报清单 15-3b 的编译错误
    // 引用类型方法不需要 mutating——直接改实例本体
    override func speak() {
        // name 从父类继承而来，无需在子类重新声明
        print("\(name) 汪汪")
    }
}

// 子类复用父类 init(name:)——继承把初始化器也带过来
let dog = Dog(name: "旺财")
dog.speak()

// ============ 第三步：引用语义对照（回扣第 14 章 14.4 节）============
print("\n=== 第三步：引用语义对照——改 b 后 a 也变 ===")

let a = Dog(name: "原型狗")
let b = a            // 引用语义：b 复制的是引用（地址），与 a 指向同一实例
b.name = "改了副本"  // 改 b 等同于改堆上那个共享实例的 name

// 回扣第 14 章 14.4 节 TodoItem 值语义实验：
// 同样的赋值语句，struct 复制独立（taskA.title 不变），class 共享同一实例（a.name 也变）
print("a.name: \(a.name)")
print("b.name: \(b.name)")
print("a 与 b 是否同一实例：\(a === b)")

// ============ 第四步：什么时候用 class ============
print("\n=== 第四步：什么时候用 class ===")

// class 的两大不可替代能力：
// 1. 继承 + 方法重写（多态）——struct 做不到（见清单 15-4 报错）
// 2. 引用共享——多个引用指向同一实例，适合缓存、UI 视图层级、SwiftData 模型
// 纯数据建模默认 struct（值语义天然线程安全），需要这两点时才升级到 class

let animals: [Animal] = [Animal(name: "阿白"), Dog(name: "旺财")]
// 多态：编译期类型都是 Animal，运行期各自调用自己的 speak 版本
for creature in animals {
    creature.speak()
}