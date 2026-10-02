let name = "Tom"
let visitCount = 3

// + 是 String 重载的运算符,左右操作数必须同为 String;Int 不在其中,因此必须显式 String()
let byConcat = "你好," + name + "!这是你第 " + String(visitCount) + " 次访问。"

// 插值通过 String(describing:) 自动套用,免去显式转换
let byInterpolation = "你好,\(name)!这是你第 \(visitCount) 次访问。"

print(byConcat)
print(byInterpolation)