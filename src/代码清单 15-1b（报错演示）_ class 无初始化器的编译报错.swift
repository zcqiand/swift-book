// 不会编译通过，仅展示报错，不要粘进主 Playground 运行
// 版本基线：Swift 6.2 / Xcode 26

class Animal {
    var name: String          // 删掉 init，仅留一个未初始化的存储属性
}