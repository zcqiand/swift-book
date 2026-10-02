func gradeScore(_ score: Int) -> String {
    switch score {
    // 90...100 是闭区间，含尾，对应第 4 章的三连点写法
    case 90...100:
        return "优秀"
    // 60..<90 是半开区间，含左不含右，对应第 4 章的两点加小于号写法
    case 60..<90:
        return "及格"
    // default 兜底所有未被上面区间命中的值（含 < 60 与边界外的值）
    default:
        return "不及格"
    }
}

print(gradeScore(95))   // 输出：优秀
print(gradeScore(75))   // 输出：及格
print(gradeScore(50))   // 输出：不及格