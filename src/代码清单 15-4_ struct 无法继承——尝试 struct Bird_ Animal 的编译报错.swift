// 不会编译通过，仅展示报错，不要粘进主 Playground 运行
// 版本基线：Swift 6.2 / Xcode 26

class Animal {
    var name: String
    init(name: String) { self.name = name }
    func speak() {
        print("\(name) 发声")
    }
}

// struct 想继承 class：编译器直接拒绝
// 因为 Swift 的继承体系只允许 class 继承 class，struct 的冒号语法只接受 protocol
struct Bird: Animal {
    func speak() {
        print("啾啾")
    }
}