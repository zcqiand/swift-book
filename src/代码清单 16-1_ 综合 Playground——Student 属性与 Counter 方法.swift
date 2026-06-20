// 版本基线：Swift 6.2 / Xcode 26 / iOS 26 SDK
import Foundation

struct Student {
    var score: Int {
        willSet {
            // willSet 发生在赋值前：score 仍是旧值，newValue 是即将写入的新值。
            print("willSet: score 旧值 \(score) -> 新值 \(newValue)")
        }
        didSet {
            // didSet 发生在赋值后：score 已是新值，oldValue 保留赋值前的旧值。
            print("didSet: score 旧值 \(oldValue) -> 新值 \(score)")
        }
    }

    // grade 能由 score 稳定推导，写成计算属性可避免“分数改了，等级忘改”。
    var grade: String { score >= 60 ? "及格" : "不及格" }
}

struct Counter {
    var count: Int

    mutating func increment() {
        // Counter 是结构体，实例方法要修改自己的 count，必须显式标记 mutating。
        count += 1
    }

    static func defaultCount() -> Int {
        // 默认值由类型统一提供，不依赖任何一个具体 Counter 实例。
        0
    }
}

var student = Student(score: 85)
print("Student(score:85).grade -> \(student.grade)")

student.score = 50
print("Student 当前 score -> \(student.score)")
print("Student 当前 grade -> \(student.grade)")

var counter = Counter(count: Counter.defaultCount())
print("Counter.defaultCount() -> 默认计数 \(Counter.defaultCount())")
print("Counter 初始 count -> \(counter.count)")

counter.increment()
print("调用 increment 后 count -> \(counter.count)")