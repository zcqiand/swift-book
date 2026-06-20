import Foundation

// 用 var 因为步数会随用户走动不断增加，初始值必须可变
var stepCount = 0

stepCount = 1
print("走出第一步，当前步数：\(stepCount)")

stepCount = stepCount + 1
print("再走一步，当前步数：\(stepCount)")