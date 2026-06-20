import SwiftUI

/// 跨视图共享的应用设置模型。
/// @Observable 宏（Observation 框架，Swift 5.9+/iOS 17+，iOS 26 SDK 内置）
/// 让视图自动追踪被读取的属性，属性变化时相关视图自动刷新。
//  取代旧版 ObservableObject + @Published，新项目统一走 @Observable。
@Observable
final class AppSettings {
    // @Observable class 是引用类型，生命周期由 ARC（第 20 章 C052）管理，
    // 与 struct 值类型状态（如 @State 的 count）不同：
    // 多个视图持有的是同一个实例，改一处全部可见。
    var volume: Double = 0.5
    var isMuted: Bool = false
}