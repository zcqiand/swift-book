struct Student {
    var score: Int

    var grade: String { score >= 60 ? "及格" : "不及格" }
}