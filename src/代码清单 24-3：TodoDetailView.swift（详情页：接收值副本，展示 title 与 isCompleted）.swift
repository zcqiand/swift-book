import SwiftUI

/// 待办详情页：展示单个 TodoItem 的标题与完成状态。
///
/// 关键点（值语义）：
/// 入参 item: TodoItem 接收的是 caller 传来的值副本——因为 TodoItem 是 struct。
/// 所以本页内即便把 Toggle 拨来拨去，改的也只是这份副本，列表里的原数据不会跟着变，
/// 也不会自动回传。要实现「详情页改完同步回列表」需要配合：
///   - 第 25 章持久化，把改完的值写回数据源；或
///   - 用 @Binding（第 23 章 C064）让父子共用一份原件。
/// 本章不展开，本页只做「读 + 本地展示」演示，Toggle 仅改本地副本用于观察行为。
struct TodoDetailView: View {
    // 值类型入参：调用方传入时拷贝一份。声明为 @State 才能在本页内修改它
    // （普通 let 不能改；@State 让 SwiftUI 托管这个本地副本的生命周期）。
    @State var item: TodoItem

    var body: some View {
        // Form 适合「键值对」式详情页，自带分组样式与深浅色适配。
        Form {
            Section("标题") {
                Text(item.title)
                    .font(.title2)
                    .fontWeight(.semibold)
            }

            Section("完成状态") {
                Toggle("已完成", isOn: $item.isCompleted)
                    // 用 SF Symbol 直观提示当前状态，与 Toggle 同步。
                    .overlay(alignment: .trailing) {
                        Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(item.isCompleted ? .green : .secondary)
                            // 留出 Toggle 文字与开关之间的空间，避免重叠。
                            .padding(.trailing, 64)
                    }
            }

            Section {
                Text(statusHint)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("详情")
        .navigationBarTitleDisplayMode(.inline)
    }

    /// 给读者点破值语义：详情页 Toggle 只改副本。
    private var statusHint: String {
        "提示：详情页内拨动开关只改本地副本，不会回传列表（详见 24.8 节）。"
    }
}

#Preview {
    // 详情页 Preview 需要外层包 NavigationStack，
    // 否则 .navigationTitle / 返回栏无宿主，预览会异常。
    NavigationStack {
        TodoDetailView(item: TodoItem(title: "预览项", isCompleted: false))
    }
}