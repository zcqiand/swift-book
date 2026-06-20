import Foundation

enum VendingError: Error { case outOfStock; case insufficientFunds(coinsNeeded: Int) }

// Error 是一个协议标记：遵守它之后，VendingError 就可以被 throw 抛出。
let sampleError = VendingError.insufficientFunds(coinsNeeded: 3)
print("已经定义售货机错误类型：\(sampleError)")