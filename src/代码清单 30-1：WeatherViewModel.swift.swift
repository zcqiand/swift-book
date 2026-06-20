import Foundation
import Observation

// @MainActor 把整个类的所有成员都钉在主线程隔离域；
// @Observable 由 Swift 6.2 的宏在编译期自动生成属性追踪，让 SwiftUI 视图按需重绘。
// 两者组合的好处：UI 状态读写天然线程安全，且无需 ObservableObject / @Published 样板。
@MainActor
@Observable
final class WeatherViewModel {

    // 视图直接读取的状态：当前天气、加载标志、错误文案。
    var currentWeather: CurrentWeather? = nil
    var isLoading: Bool = false
    var errorMessage: String? = nil

    // 必须把 Task 句柄保存下来，原因有二：
    // 1. 用户连续点刷新时，要先 cancel 上一次未完成的请求，避免「后发先到」覆盖新结果（race condition）。
    // 2. 视图消失时要主动取消，防止泄漏。
    // 注意：@Observable 默认会追踪存储属性的读写，private 属性同样会被追踪，
    // 但本属性仅作内部生命周期管理，UI 不读它，所以不影响重绘。
    private var task: Task<Void, Never>? = nil

    private let service = WeatherService()

    /// 统一的取消识别：Swift Concurrency 原语会抛 CancellationError，
    /// 而 URLSession.data(for:) 在父 Task 被取消时抛 URLError(.cancelled)；
    /// 再加上 Task.isCancelled 兜底，确保任何取消路径都被识别为「协作信号」而非「失败」。
    private func isCancellation(_ error: Error) -> Bool {
        if error is CancellationError { return true }
        if (error as? URLError)?.code == .cancelled { return true }
        if Task.isCancelled { return true }
        return false
    }

    /// 按经纬度加载天气。可重复调用，新调用会自动取消上一次未完成的请求。
    func loadWeather(latitude: Double, longitude: Double) {
        // 取消上一次未完成的请求：cancel() 只是设置标志位，
        // 真正的退出由 await 返回点抛错（CancellationError 或 URLError(.cancelled)）来完成。
        task?.cancel()

        isLoading = true
        errorMessage = nil

        // Task { } 在 @MainActor 上下文中创建时，闭包默认继承 MainActor 隔离，
        // 所以闭包内对 self 属性的读写依然在 MainActor 上，无需手动跳转。
        // [weak self] 防止 ViewModel 被任务强引用导致延迟释放。
        task = Task { [weak self] in
            guard let self else { return }
            do {
                // await 挂起期间线程被释放给系统调度；
                // 当 fetchWeather 完成后，Swift 运行时会自动把执行权交回 MainActor，
                // 因此下面这一行赋值仍在 MainActor 上，可安全更新 UI 状态。
                let weather = try await self.service.fetchWeather(
                    latitude: latitude,
                    longitude: longitude
                )
                self.currentWeather = weather
            } catch {
                // 顺序很重要：先识别取消信号并静默返回，
                // 否则用户每次切换请求都会看到一次「已取消」的红字，体验糟糕。
                // 注意 URLSession 的取消抛的是 URLError(.cancelled)，不是 CancellationError，
                // 所以必须用 isCancellation(_:) 同时识别两种来源。
                if self.isCancellation(error) {
                    return
                }
                self.errorMessage = error.localizedDescription
            }
            // 不论成功失败（取消除外），都把 loading 关掉。
            // 取消分支已 return，不会走到这里，loading 由下一次 loadWeather 的开头重置。
            self.isLoading = false
        }
    }

    /// 便捷方法：默认加载北京（39.9042, 116.4074）的天气。
    func refresh() {
        loadWeather(latitude: 39.9042, longitude: 116.4074)
    }

    /// 视图消失或用户主动取消时调用。
    /// 注意：DispatchQueue.main.async 在结构化并发体系下已不需要，cancel() 本身就是同步且线程安全的。
    func cancelLoading() {
        task?.cancel()
        task = nil
        isLoading = false
    }
}