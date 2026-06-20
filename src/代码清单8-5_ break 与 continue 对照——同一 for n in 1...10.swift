import Foundation

// 上半段：break 在命中 5 时立即跳出整个循环，后续 6~10 不再打印
print("上半段：break 命中 5 立即跳出整个循环")
for n in 1...10 {
    // 命中 5 就跳出，整个循环到此终结，后续数字连 print 都进不来
    if n == 5 {
        break
    }
    print(n)
}

print("")

// 下半段：continue 在命中 5 时仅跳过本次 print，循环本身继续跑到 10
print("下半段：continue 命中 5 仅跳过本次进下一轮")
for n in 1...10 {
    // 命中 5 跳过本次 print，但循环还在继续，6~10 仍会被打印
    if n == 5 {
        continue
    }
    print(n)
}