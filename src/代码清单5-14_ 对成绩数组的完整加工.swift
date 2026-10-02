var scores = [88, 72, 95, 60, 88]

print("总人数：\(scores.count)")               // 总人数：5
print("升序：\(scores.sorted())")               // 升序：[60, 72, 88, 88, 95]
print("降序：\(scores.sorted(by: >))")          // 降序：[95, 88, 88, 72, 60]
print("有满分吗：\(scores.contains(100))")      // 有满分吗：false