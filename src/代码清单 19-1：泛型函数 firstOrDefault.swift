import Foundation

func firstOrDefault<T>(_ array: [T], default defaultValue: T) -> T {
    array.first ?? defaultValue
}

// 第一次调用中，Swift 推断 T 是 Int。
let firstNumber = firstOrDefault([1, 2, 3], default: 0)
let emptyFallback = firstOrDefault([], default: 0)

print(firstNumber)
print(emptyFallback)