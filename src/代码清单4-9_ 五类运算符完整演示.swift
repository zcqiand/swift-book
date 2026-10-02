import Foundation

// ========== 一、算术运算：整数除法 vs 浮点除法 ==========
let apples = 7
let people = 2
let integerQuotient = apples / people
let floatQuotient = Double(apples) / Double(people)
print("整数除法：\(integerQuotient)")   // → 3
print("浮点除法：\(floatQuotient)")       // → 3.5

// ========== 二、逻辑运算：组合登录条件 ==========
let hasAccount = true
let knowsPassword = false
let isGuest = true
let canLogin = (hasAccount && knowsPassword) || isGuest
print("是否允许登录：\(canLogin)")   // → true（游客身份绕过密码错误）

// ========== 三、区间运算 + for-in ==========
var rangeResult: [Int] = []
for n in 1...3 { rangeResult.append(n) }
print(rangeResult)   // → [1, 2, 3]

var halfResult: [Int] = []
for n in 1..<3 { halfResult.append(n) }
print(halfResult)   // → [1, 2]

// ========== 四、区间切片验证 ==========
let numbers = [10, 20, 30, 40, 50]
print(Array(numbers[1...3]))   // → [20, 30, 40]
print(Array(numbers[1..<3]))    // → [20, 30]

// ========== 五、空合运算 ?? ==========
let nickname: String? = nil
let displayName = nickname ?? "匿名用户"
print("nickname 为 nil 时：\(displayName)")   // → 匿名用户

let profile: [String: String] = ["city": "上海"]
print("键存在时：\(profile["city"] ?? "未知城市")")    // → 上海
print("键不存在时：\(profile["region"] ?? "未知地区")")  // → 未知地区