import Foundation
import Observation

/// 天气视图模型（多槽位升级版）
///
/// 状态结构：
/// - loadStates：以 City.ID 为 key 的状态字典，每个城市一个槽位，互不污染。
///   视图层通过 viewModel.loadStates[city.id] 读取自身状态。
/// - tasks：以 City.ID 为 key 的 Task 字典，便于按城市取消。
///
/// 并发模型：@MainActor 隔离保证所有属性读写在主线程；
/// @Observable 让 SwiftUI 视图能精细订阅字典键变化。
@MainActor
@Observable
final class WeatherViewModel {

    /// 各城市当前的加载状态。键缺失等同于「未发起加载」
    var loadStates: [City.ID: LoadState<CurrentWeather>] = [:]

    /// 各城市正在进行的 Task 句柄，离开详情页时按 key 取消
    private var tasks: [City.ID: Task<Void, Never>] = [:]

    /// 天气服务（沿用第 30 章实现，单例够用）
    private let service = WeatherService()

    // MARK: - 公开 API

    /// 加载单个城市天气
    func loadWeather(cityId: City.ID, latitude: Double, longitude: Double) {
        // 1. 抢占有序：先把 UI 切到 loading，避免「点完没反应」的错觉
        loadStates[cityId] = .loading
        // 2. 取消旧任务：新请求总是最新意图，旧请求即使回来也该被丢弃
        tasks[cityId]?.cancel()
        // 3. 启动新任务
        tasks[cityId] = Task { [weak self] in
            guard let self else { return }
            do {
                let weather = try await self.service.fetchWeather(
                    latitude: latitude,
                    longitude: longitude
                )
                if Task.isCancelled { return }
                self.loadStates[cityId] = .loaded(weather)
            } catch {
                // 取消产生的 CancellationError 不暴露给用户——它不是业务错误
                if self.isCancellation(error) { return }
                self.loadStates[cityId] = .failed(error.localizedDescription)
            }
        }
    }

    /// 一次性触发所有城市（列表页 .onAppear 用）
    func loadAllWeather(cities: [City]) {
        for city in cities {
            loadWeather(
                cityId: city.id,
                latitude: city.latitude,
                longitude: city.longitude
            )
        }
    }

    /// 重试便捷入口：直接复用 loadWeather 的取消+启动逻辑
    func retry(cityId: City.ID, latitude: Double, longitude: Double) {
        loadWeather(cityId: cityId, latitude: latitude, longitude: longitude)
    }

    /// 取消所有进行中的任务
    /// 语义对齐第 30 章的 cancelLoading()，改名 cancelAll 是因为它现在
    /// 作用于「多任务」而非「单任务」。
    func cancelAll() {
        for (_, task) in tasks { task.cancel() }
        tasks.removeAll()
    }

    // MARK: - 私有辅助

    /// 识别取消错误（沿用第 30 章三源识别实现）
    ///
    /// 三个分支并行兜底：
    /// - `CancellationError`：Task 自身的取消信号
    /// - `URLError(.cancelled)`：URLSession 抛出的网络层取消
    /// - `Task.isCancelled`：并发上下文兜底，处理「未抛错但任务已被标记取消」
    ///   的边缘情况（如 `Task.checkCancellation()` 触发的静默退出）
    private func isCancellation(_ error: Error) -> Bool {
        if error is CancellationError { return true }
        if let urlError = error as? URLError, urlError.code == .cancelled {
            return true }
        if Task.isCancelled { return true }
        return false
    }
}