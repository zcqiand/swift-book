import Foundation

// 圆周率与每周天数在数学/历法上恒定不变，用 let 锁死可避免误改
let pi = 3.14159
let daysInWeek = 7

print("圆周率取值：\(pi)，一周天数：\(daysInWeek)")

// 取消下面这行的注释，编辑器会立即标红并报错：
// pi = 3.14   // 错误: cannot assign to value: 'pi' is a 'let' constant