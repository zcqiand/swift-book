var scores = [88, 72, 95, 60]          // 推断为 [Int]
var prices: [Double] = [9.9, 19.9]      // 显式标注为 [Double]
var switches = [true, false, true]      // 推断为 [Bool]

print(scores)    // 输出：[88, 72, 95, 60]
print(prices)    // 输出：[9.9, 19.9]
print(switches)  // 输出：[true, false, true]