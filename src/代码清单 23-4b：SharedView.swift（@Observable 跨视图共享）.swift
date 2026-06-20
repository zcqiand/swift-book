import SwiftUI

/// 根视图：创建模型实例并通过 .environment(settings) 注入。
/// 注意这里用的是 @Environment 的「用法②」：读注入的 @Observable 对象，
/// 与代码清单 23-3 的「用法① 读系统值」语义不同，不可混用。
struct SharedView: View {
    // 根视图用 @State 持有模型实例本身：
    // @State 在这里托管「引用」，模型实例的属性变化由 @Observable 通知。
    @State private var settings = AppSettings()

    var body: some View {
        VStack(spacing: 24) {
            VolumeControlView()
            VolumeDisplayView()
        }
        .padding()
        // .environment(settings) 把模型注入子视图树的环境，
        // 任意深层子视图都能用 @Environment(AppSettings.self) 取出。
        // 这取代了旧 @EnvironmentObject（旧版要求类型可识别 + 注入路径不同）。
        .environment(settings)
    }
}

/// 子视图 A：含一个按钮，直接改 settings.volume。
struct VolumeControlView: View {
    // 用法②：@Environment(ModelType.self) 读取注入的 @Observable 对象。
    // 这里拿到的是根视图创建的那个唯一实例，改它的属性会通知所有读取方。
    @Environment(AppSettings.self) private var settings

    var body: some View {
        VStack(spacing: 8) {
            Text("音量控制")
                .font(.headline)

            // 按钮直接改模型属性：settings.volume += 0.1。
            // 本章只读模型属性 + 直接改写，不需要 @Bindable
            // （对 @Observable 模型属性建立双向绑定要用 @Bindable，留后续章节）。
            Button("音量 +0.1") {
                settings.volume = min(settings.volume + 0.1, 1.0)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

/// 子视图 B：纯显示模型属性，自己不改它。
/// 它和子视图 A 持有同一个 settings 实例：
/// A 改 volume，B 自动刷新。
struct VolumeDisplayView: View {
    @Environment(AppSettings.self) private var settings

    var body: some View {
        VStack(spacing: 8) {
            Text("音量显示")
                .font(.headline)

            // 显示模型属性。@Observable 让视图在 volume 变化时自动重算 body，
            // 无需手动通知，这就是「响应式共享」的核心。
            Text(String(format: "当前音量：%.1f", settings.volume))
                .font(.title2)
                .fontWeight(.medium)

            Text(settings.isMuted ? "已静音" : "未静音")
                .foregroundStyle(settings.isMuted ? .red : .green)
        }
    }
}

#Preview {
    SharedView()
}