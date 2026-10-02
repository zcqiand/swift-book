import Foundation

// 整箱苹果分配：7个苹果分给2人
let apples = 7
let people = 2

let integerQuotient = apples / people           // Int / Int → Int，小数被丢弃
let floatQuotient = Double(apples) / Double(people)  // 转 Double 后保留小数

print("整数除法：\(integerQuotient)")   // → 3
print("浮点除法：\(floatQuotient)")     // → 3.5