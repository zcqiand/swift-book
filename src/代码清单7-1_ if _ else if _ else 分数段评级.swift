// 用四个不同分数演示四档分支
func gradeScoreByIf(_ score: Int) -> String {
    // 条件必须从最严格开始：若先判 >= 60，95 会被并到「及格」档，逻辑就错了
    if score >= 90 {
        return "优秀"
    } else if score >= 75 {
        return "良好"
    } else if score >= 60 {
        return "及格"
    } else {
        return "不及格"
    }
}

print(gradeScoreByIf(95))   // 输出：优秀
print(gradeScoreByIf(80))   // 输出：良好
print(gradeScoreByIf(65))   // 输出：及格
print(gradeScoreByIf(50))   // 输出：不及格