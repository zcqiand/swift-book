import SwiftUI

/// 待办清单主视图：列表 + 跳转详情页。
///
/// 导航主路径：
/// - 用 NavigationStack（iOS 16+）。NavigationView 已弃用，本书统一用 NavigationStack。
/// - 用 value-based 导航：NavigationLink(value: item) 携带数据，
///   再在父视图用 .navigationDestination(for: TodoItem.self) 声明对应目标。
///   旧式 NavigationLink(destination:) 不写进教学代码（见 24.5 节版本对照）。
struct TodoListView: View {
    // @State 持有列表数据。本章不持久化：App 重启后状态清空，第 25 章才解决。
    // 数组是值类型（C016），@State 包裹后任何 append / remove / 下标改写
    // 都会被 SwiftUI 察觉，触发 List 重算并做差量刷新（回扣第 23 章 @State）。
    @State private var items: [TodoItem] = todoSamples

    var body: some View {
        NavigationStack {
            List {
                // items 的元素是 Identifiable（TodoItem 有 id），
                // ForEach(items) 能直接用；无需写 id: \.self（见清单 24-4 对照变体）。
                ForEach(items) { item in
                    // 把 item 作为导航值塞进 NavigationLink：
                    // 点击这行时，SwiftUI 会查找 .navigationDestination(for: TodoItem.self)
                    // 并把 item 传给它，由后者决定目标视图。
                    NavigationLink(value: item) {
                        todoRow(item)
                    }
                }
            }
            // 声明「TodoItem 类型的导航值 → TodoDetailView」的映射。
            // 写在 List 外层（NavigationStack 内容的下级），可被多层子视图共享。
            .navigationDestination(for: TodoItem.self) { item in
                // 注意：item 在这里是值副本（TodoItem 是 struct），
                // 详情页内修改不会自动回传列表，见清单 24-3 注释与 24.8 节说明。
                TodoDetailView(item: item)
            }
            .navigationTitle("待办清单")
        }
    }

    /// 单行视图抽成私有方法，保持 body 清爽。
    /// 用 HStack：左侧标题、右侧状态图标，对齐稳定不抖动。
    @ViewBuilder
    private func todoRow(_ item: TodoItem) -> some View {
        HStack {
            Text(item.title)
                // 已完成项标题置灰，视觉上与未完成项拉开层次。
                // 用 .foregroundStyle，不用已弃用的 .foregroundColor（第 22 章 C061）。
                .foregroundStyle(item.isCompleted ? .secondary : .primary)

            Spacer()

            // SF Symbols 内置图标：checkmark.circle.fill / circle，
            // 无需额外资源，跨深浅色模式自动适配。
            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(item.isCompleted ? .green : .secondary)
        }
    }
}

#Preview {
    TodoListView()
}