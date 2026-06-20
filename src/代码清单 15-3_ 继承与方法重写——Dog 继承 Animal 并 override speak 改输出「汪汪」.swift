// 版本基线：Swift 6.2 / Xcode 26 / iOS 26 SDK
import Foundation

// 父类（基类）：class 默认 internal，同模块内子类可直接继承并 override
// （open 只在跨模块继承时才需要，本清单同一文件无需 open；这里标 open 仅演示语义）
open class Animal {
    var name: String

    init(name: String) {
        self.name = name
    }

    // open 修饰方法：表示允许其他模块的子类重写它
    // 同模块内不写 open 也能 override，open 的额外价值只在跨模块
    open func speak() {
        // 父类提供默认行为，子类可以重写它
        print("\(name) 发声")
    }
}

// 子类：在父类名后加冒号表示继承，Swift 只支持单继承（C045）
class Dog: Animal {
    // override 关键字是硬性要求：告诉编译器「我明确要重写父类的 speak」
    // 省略 override 会直接报错（见清单 15-3b）
    // 注意：这里不需要 mutating——引用类型方法直接改实例本体
    override func speak() {
        // 重写后输出特化为「汪汪」，name 属性从父类继承而来无需重写
        print("\(name) 汪汪")
    }
}

// 子类构造时仍走父类的 init(name:)：继承把初始化器也带过来了
Dog(name: "旺财").speak()