import Foundation

// 为什么用元组返回最小最大值,而不是定义一个 MinMax 结构体?
// 因为这是「一次性临时组合」,无需长期复用、无需挂方法——元组无需定义类型,场景契合
// 若日后这个组合要长期复用、加方法,再升级为结构体(C039,第 14 章讲)
// 返回类型 (min: Int, max: Int) 是带标签的元组——标签让调用点可用 .min / .max 命名访问
func minMax(_ array: [Int]) -> (min: Int, max: Int) {
    // 用 guard 校验数组非空:空数组没有「最小值/最大值」,提前返回兜底值(此处用 Int 范围极值)
    // 为什么用 guard 而非 if:让主逻辑(遍历求值)保持扁平,不缩进(第 7 章 7.4 节风格)
    guard !array.isEmpty else {
        return (min: Int.min, max: Int.max)
    }

    // 取第一个元素作初始值——为什么不用 0?因为数组可能全负,0 会是错的初始最大值
    var currentMin = array[0]
    var currentMax = array[0]

    // 从第二个元素开始遍历,逐个比较更新最小/最大值
    for number in array[1...] {
        if number < currentMin {
            currentMin = number
        }
        if number > currentMax {
            currentMax = number
        }
    }

    // 返回带标签的元组——调用点可用 result.min / result.max 命名访问,无须记位置
    return (min: currentMin, max: currentMax)
}

// 用下划线 _ 省略参数标签(参数含义自明,清单 10-2 形态三),调用点写起来更轻
let result = minMax([3, 1, 4, 1, 5])

// 按标签访问元组字段——这正是「带标签的元组」相对「裸元组 (Int, Int)」的可读性优势
print(result.min)   // 输出:1
print(result.max)   // 输出:5