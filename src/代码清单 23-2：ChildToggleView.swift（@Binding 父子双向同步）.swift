import SwiftUI

/// 子视图：通过 @Binding 拿到对父状态的「可读写引用」。
/// 拨动 Toggle 改写 isOpen，写的是父视图那份状态，而非本地副本。
struct ChildToggleView: View {
    // @Binding 不存储状态，只持有指向父状态的可读写引用。
    // 父视图传入时必须用 $ 投影值（$isOpen），不能传普通值 isOpen。
    @Binding var isOpen: Bool

    var body: some View {
        VStack(spacing: 8) {
            // Toggle 的 $isOpen 双向绑定走的是「绑定到绑定」：
            // $isOpen（Binding<Bool>）直接喂给 Toggle(isOn:)，
            // Toggle 内部改写会沿引用一路写回父视图的 @State。
            Toggle("开关（子视图控制）", isOn: $isOpen)

            // 用文字显式展示当前值，方便观察父子是否同步
            Text(isOpen ? "已打开" : "已关闭")
                .foregroundStyle(isOpen ? .green : .red)
        }
        .padding()
        .background(in: RoundedRectangle(cornerRadius: 12))
    }
}

/// 父视图：用 @State 持有真正的状态，并把 $isOpen 传给子视图。
struct ParentView: View {
    // 状态的真实归属在父视图。$isOpen 投影出的 Binding<Bool>
    // 是一条「可读写引用」，子视图改它等于改这里的 isOpen。
    @State private var isOpen: Bool = false

    var body: some View {
        VStack(spacing: 24) {
            Text("父视图看到的状态：\(isOpen ? "开" : "关")")
                .font(.headline)

            // 关键一步：传 $isOpen（投影值），不是 isOpen（普通值）。
            // 传普通值会让子视图拿到一份只读快照，无法双向同步。
            ChildToggleView(isOpen: $isOpen)
        }
        .padding()
    }
}

#Preview {
    ParentView()
}