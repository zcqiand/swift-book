import Foundation

// Int.random(in: 1...6) 是 Swift 标准库提供的随机数函数，返回 1 到 6 之间随机整数（含两端）
// 随机数 API 在后续项目章（游戏、概率模拟）会系统讲，这里只用它的最简形态演示循环语义
var roll = Int.random(in: 1...6)

// repeat-while 是「先执后判」：循环体先无条件执行一次，再判 while 条件决定要不要再来一轮
// 关键差异：无论 roll 初值如何，循环体至少跑一次——即便第一次就摇到 6，也会先 print 一次再判
repeat {
    print("摇到了：\(roll)")
    roll = Int.random(in: 1...6)
} while roll != 6

print("摇到 6 了，结束！")