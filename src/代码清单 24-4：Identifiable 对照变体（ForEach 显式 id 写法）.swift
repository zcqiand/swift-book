import SwiftUI

/// 同一组数据，演示「不依赖 Identifiable」的显式 id 写法。
///
/// 何时用这种写法：
/// - 元素类型不便（或不能）加 Identifiable 的临时场景——例如第三方类型、
///   或一次性渲染纯字符串/数字数组。
/// 首选仍是让类型实现 Identifiable（如 24-1 的 TodoItem）：
/// - id 由模型集中维护，散落的 ForEach 不用每次重复指定 id；
/// - id 稳定（UUID 而非 \.self），删除/插入时 diff 更准确，避免误判行身份变化。
struct TodoListByIdSelfView: View {
    @State private var items: [TodoItem] = todoSamples

    var body: some View {
        NavigationStack {
            List {
                // id: \.self 表示「用元素自身（这里是整个 struct）作 id」。
                // Swift 会用结构化比较判等；对值类型可行，但对 class / 含引用字段
                // 的类型判等可能不直观。临时演示可用，生产代码请走 Identifiable。
                ForEach(items, id: \.self) { item in
                    NavigationLink(value: item) {
                        HStack {
                            Text(item.title)
                            Spacer()
                            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(item.isCompleted ? .green : .secondary)
                        }
                    }
                }
            }
            .navigationDestination(for: TodoItem.self) { item in
                TodoDetailView(item: item)
            }
            .navigationTitle("对照：id: \\.self")
        }
    }
}

#Preview {
    TodoListByIdSelfView()
}