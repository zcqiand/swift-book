import Foundation

let hasAccount = true
let knowsPassword = false   // 这次密码输错了
let isGuest = true

// 括号显式写出求值顺序，不依赖记忆优先级
let canLogin = (hasAccount && knowsPassword) || isGuest
print("是否允许登录：\(canLogin)")   // → true（游客身份绕过了密码错误）