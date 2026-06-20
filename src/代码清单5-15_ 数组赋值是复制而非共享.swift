var original = ["A", "B", "C"]
var copy = original      // 此处发生复制：copy 拿到一份独立内容
copy.append("D")         // 只改了 copy

print(original)          // 输出：["A", "B", "C"]  ← 原数组未受影响
print(copy)              // 输出：["A", "B", "C", "D"]