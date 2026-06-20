import Foundation

struct Stack<Element> {
    private var storage: [Element] = []

    var isEmpty: Bool {
        storage.isEmpty
    }

    mutating func push(_ element: Element) {
        storage.append(element)
    }

    mutating func pop() -> Element? {
        storage.popLast()
    }

    func peek() -> Element? {
        storage.last
    }
}

var taskStack = Stack<String>()

taskStack.push("学习泛型函数")
taskStack.push("练习扩展语法")
taskStack.push("实现一个栈")

if let topTask = taskStack.peek() {
    print("栈顶任务：\(topTask)")
}

if let completedTask = taskStack.pop() {
    print("弹出任务：\(completedTask)")
}

if let newTopTask = taskStack.peek() {
    print("新的栈顶任务：\(newTopTask)")
}

print("栈是否为空：\(taskStack.isEmpty)")