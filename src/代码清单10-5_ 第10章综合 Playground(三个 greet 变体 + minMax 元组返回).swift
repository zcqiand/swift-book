import Foundation

// 一、带参数标签(默认形态):调用点必须写 name 标签
// 为什么默认带标签?让调用点读起来像一句话「给 name 打招呼」,可读性优先
func greet(name: String) -> String {
    return "你好,\(name)"
}

print("一、带参数标签:")
print(greet(name: "Tom"))   // 输出:你好,Tom

// 二、省略参数标签(_ name):调用点直接传值,圆括号里不写标签
// 为什么省略标签?参数含义自明(如本例「Tom 就是打招呼对象」)、或运算符式调用时,省略让写法更轻
// 第 7 章 gradeScoreByIf(_ score:)、第 9 章 ?? 都属此类
func greet(_ name: String) -> String {
    return "你好,\(name)"
}

print("\n二、省略参数标签:")
print(greet("Tom"))         // 输出:你好,Tom

// 三、带默认值参数(name: String = "朋友"):调用时可省略参数,使用默认值
// 默认值参数必须放在参数列表末尾——否则编译报「non-default argument follows default argument」
// 为什么用默认值?让函数「开箱即用」处理最常见的兜底场景(此处为「不传名字」)
func greetWithDefault(name: String = "朋友") -> String {
    return "你好,\(name)"
}

print("\n三、带默认值参数:")
print(greetWithDefault(name: "Tom"))   // 显式传参,覆盖默认值,输出:你好,Tom
print(greetWithDefault())              // 不传参,使用默认值「朋友」,输出:你好,朋友

// 四、元组多返回值:minMax 返回 (min: Int, max: Int),无需定义专用类型
// 为什么用元组而非定义结构体?这是「一次性临时组合」,无需长期复用——元组无需定义类型,契合场景
// 回扣第 6 章 6.4 节 (city, weather) 与第 8 章 enumerated() 返回 (offset, element):
// 它们早就是元组了,本章只是把它正式命名为可作返回类型的复合值
// 用 guard 校验空数组边界(第 7 章 7.4 节风格),主逻辑保持扁平
func minMax(_ array: [Int]) -> (min: Int, max: Int) {
    guard !array.isEmpty else {
        return (min: Int.min, max: Int.max)
    }

    // 取第一个元素作初始值——为什么不用 0?数组可能全负,0 会是错的初始最大值
    var currentMin = array[0]
    var currentMax = array[0]

    for number in array[1...] {
        if number < currentMin {
            currentMin = number
        }
        if number > currentMax {
            currentMax = number
        }
    }

    // 返回带标签的元组——调用点可用 .min / .max 命名访问,无须记位置
    return (min: currentMin, max: currentMax)
}

print("\n四、元组多返回值:")
let result = minMax([3, 1, 4, 1, 5])
// 按标签访问元组字段:这正是「带标签的元组」相对「裸 (Int, Int)」的可读性优势
print("最小值: \(result.min)")   // 输出:最小值: 1
print("最大值: \(result.max)")   // 输出:最大值: 5