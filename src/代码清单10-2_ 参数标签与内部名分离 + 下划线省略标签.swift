import Foundation

// 形态一:带参数标签(Swift 默认形态)
// 调用点写 name:,函数体内也用 name——标签与参数名同名,这是最常见的写法
func greet(name: String) -> String {
    // 函数体内用参数名 name(此处与标签同名,无需区分)
    return "你好,\(name)"
}

// 形态二:参数标签与参数名分离(person 是标签,name 是参数名)
// 为什么要把标签与参数名分离?让调用点更接近自然语言「向这个人打招呼」(person),
// 而函数体内部仍用更短的参数名 name 书写,减少重复
func greet(person name: String) -> String {
    // 函数体内只能用参数名 name,不能用 person——person 只在调用点存在
    return "你好,\(name)"
}

// 形态三:用下划线 _ 省略参数标签
// 为什么省略标签?当参数含义自明(如运算符、单参数数学函数)时,省略标签让调用点更像数学表达式
// 第 7 章 gradeScoreByIf(_ score:)、第 9 章 ?? 都属于此类;本章下一节的 minMax 也会用
func greet(_ name: String) -> String {
    return "你好,\(name)"
}

// 三种调用点写法对照(注意圆括号里写什么):
print(greet(name: "Tom"))    // 形态一:必须写 name 标签,输出「你好,Tom」
print(greet(person: "Tom"))  // 形态二:必须写 person 标签,输出「你好,Tom」
print(greet("Tom"))          // 形态三:省略标签,直接传值,输出「你好,Tom」