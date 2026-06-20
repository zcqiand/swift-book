import Foundation

// 步数为整数计数，用 Int；圆周率为带小数的常量，用 Double；会员状态只有真假两态，用 Bool
var stepCount: Int = 12000
let pi: Double = 3.14159
var isMember: Bool = true

print("stepCount 类型：\(type(of: stepCount))")
print("pi 类型：\(type(of: pi))")
print("isMember 类型：\(type(of: isMember))")

// 整数除法直接舍去小数：7 / 2 结果是 3，而非 3.5
let integerDivisionResult = 7 / 2
print("整数除法 7 / 2 = \(integerDivisionResult)")

// 想拿到小数，至少有一端写成字面量小数
let floatDivisionResult = 7.0 / 2.0
print("浮点除法 7.0 / 2.0 = \(floatDivisionResult)")

// Swift 不会把非零整数隐式当作真值，必须显式比较，否则报错
if stepCount != 0 {
    print("有步数：\(stepCount)")
}

// 取消下一行注释可触发报错：
// if stepCount { print("这行写法不合法") }   // 错误: type 'Int' cannot conform to 'BooleanType'