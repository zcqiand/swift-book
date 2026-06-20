import Foundation

var counter = 0

// 闭包体内引用了外层的 counter——闭包会「捕获」它。
// 关键:对 var 的捕获是引用捕获——闭包持有的不是 0 这个值,而是 counter 这个变量本身。
let increment = {
    counter += 1
}

// 每次调用 increment,改的都是同一个外层 counter,而不是闭包内部的副本。
increment()
increment()
increment()
print(counter)
// 输出：3

// 对照:用 let 声明的常量不可变,即使被捕获也无法修改。
// 如果写 let readConstant = { constant += 1 } 会直接编译报错:
// Left side of mutating operator isn't mutable: 'constant' is a 'let' constant
let constant = 0
print(constant)
// 输出：0