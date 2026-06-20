// 不会编译通过，仅展示报错，不要粘进主 Playground 运行
// 版本基线：Swift 6.2 / Xcode 26

class Animal {
    var name: String
    init(name: String) { self.name = name }
    func speak() {
        print("\(name) 发声")
    }
}

class Cat: Animal {
    // 漏写 override：方法签名与父类 speak() 完全相同
    // 编译器认为你「想重写但忘了写关键字」，直接拦截
    func speak() {
        print("喵")
    }
}