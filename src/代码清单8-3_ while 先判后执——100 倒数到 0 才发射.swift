import Foundation

var counter = 100

// while 是「先判后执」：每次进入循环体前，先看 counter > 0 这个 Bool 条件是否成立
// 条件成立才进花括号执行；条件为假就直接跳出，循环体一次都不跑
// 对照锚点：若把 counter 初值改成 0，则条件一开始就为假，循环体一次都不执行
// 这是 while 与 repeat-while 的关键差异，清单 8-4 对照看
while counter > 0 {
    print("倒计时：\(counter)")
    counter -= 1
}

print("发射！")