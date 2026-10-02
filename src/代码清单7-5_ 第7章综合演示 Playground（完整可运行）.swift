import Foundation

// 一、条件分支：func gradeScoreByIf 用 if / else if / else 做四档评级
func gradeScoreByIf(_ score: Int) -> String {
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

print("一、条件分支：")
print("95 -> \(gradeScoreByIf(95))")   // 输出：95 -> 优秀
print("80 -> \(gradeScoreByIf(80))")   // 输出：80 -> 良好
print("65 -> \(gradeScoreByIf(65))")   // 输出：65 -> 及格
print("50 -> \(gradeScoreByIf(50))")   // 输出：50 -> 不及格

// 二、提前退出：func greet 用 guard 校验空字符串
func greet(name: String) -> String {
    // 不满足（name 为空）就提前 return；满足则主逻辑无需缩进
    guard !name.isEmpty else {
        return "匿名用户"
    }
    return "你好，\(name)！"
}

print("\n二、提前退出：")
print(greet(name: "小琪"))   // 输出：你好，小琪！
print(greet(name: ""))       // 输出：匿名用户

// 三、多分支：func gradeScore 用 switch 区间匹配
func gradeScore(_ score: Int) -> String {
    switch score {
    case 90...100:
        return "优秀"
    case 60..<90:
        return "及格"
    default:
        return "不及格"
    }
}

print("\n三、多分支（区间匹配）：")
print("95 -> \(gradeScore(95))")   // 输出：95 -> 优秀
print("75 -> \(gradeScore(75))")   // 输出：75 -> 及格
print("50 -> \(gradeScore(50))")   // 输出：50 -> 不及格

// 四、枚举 + switch：交通灯穷尽性演示
// 提示：枚举是 Swift 一等类型，可携带关联值与原始值，第 13 章系统讲
// 本章只借它最简形态体会 switch 的穷尽性
// 若漏掉任意一个 case，Swift 编译器会报：
//   error: switch must be exhaustive, missing case 'xxx'
enum TrafficLight {
    case red, yellow, green
}

func describe(light: TrafficLight) -> String {
    switch light {
    case .red:
        return "停"
    case .yellow:
        return "注意"
    case .green:
        return "行"
    }
}

print("\n四、枚举 + switch（穷尽性）：")
print("红灯 -> \(describe(light: .red))")     // 输出：红灯 -> 停
print("黄灯 -> \(describe(light: .yellow))")  // 输出：黄灯 -> 注意
print("绿灯 -> \(describe(light: .green))")   // 输出：绿灯 -> 行