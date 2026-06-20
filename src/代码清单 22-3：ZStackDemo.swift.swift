import SwiftUI

/// 演示 ZStack 的层叠顺序。
/// ZStack 中先写的子视图位于底层，后写的子视图盖在前面之上。
struct ZStackDemo: View {
    var body: some View {
        ZStack {
            // 第 1 个写：圆形作为底层背景
            // .frame 把 Circle 限定为 160x160，否则 Circle 会撑满父容器
            Circle()
                .foregroundStyle(.blue)
                .frame(width: 160, height: 160)

            // 第 2 个写：文字在圆形之上
            // 后写的子视图盖在前面之上，所以白字会浮在蓝圆上
            Text("Hello")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    ZStackDemo()
        .padding()
}