import Foundation

var score = 100
print("当前分数：\(score)，类型：\(type(of: score))")

// 合法：整数与整数相加
print("加 10 后预览：\(score + 10)")

// 取消下面两行的注释，编辑器会立即报错：
// score = "优秀"      // 错误: cannot assign value of type 'String' to type 'Int'
// let label = score + "分"   // 错误: Cannot convert value of type 'String' to expected argument type 'Int'