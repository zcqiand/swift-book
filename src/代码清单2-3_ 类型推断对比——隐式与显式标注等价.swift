import Foundation

var age = 18
var ageExplicit: Int = 18
print(age == ageExplicit ? "两者取值相同" : "两者取值不同")
print("age 的类型：\(type(of: age))")
print("ageExplicit 的类型：\(type(of: ageExplicit))")

var temperature = 36.5
var isLoggedIn = true
print("temperature 的类型：\(type(of: temperature))")
print("isLoggedIn 的类型：\(type(of: isLoggedIn))")