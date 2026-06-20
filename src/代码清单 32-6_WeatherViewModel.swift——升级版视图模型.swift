import Foundation
import Observation

/// 天气视图模型(项目二收束版)
///
/// 状态结构:
/// - cities:可变城市列表(本章新增可变语义,配合下拉刷新与城市搜索)
/// - loadStates:以 City.ID 为 key 的状态字典,每个城市一个槽位
/// - searchState:城市搜索的 LoadState<[City]>(loading / loaded / failed)
/// - tasks:以 City.ID 为 key 的 Task 字典,便于按城市取消
@MainActor
@Observable
final class WeatherViewModel {

    var loadStates: [City.ID: LoadState<CurrentWeather>] = [:]
    private var tasks: [City.ID: Task<Void, Never>] = [:]
    var searchState: LoadState<[City]> = .loaded([])
    private var searchTask: Task<Void, Never>?

    private let weatherService = WeatherService()
    private let geocodingService = GeocodingService()

    var cities: [City] = [
        City(name: "北京", latitude: 39.9042, longitude: 116.4074),
        City(name: "上海", latitude: 31.2304, longitude: 121.4737),
        City(name: "广州", latitude: 23.1291, longitude: 113.2644)
    ]

    // MARK: - 天气加载

    func loadWeather(cityId: City.ID, latitude: Double, longitude: Double) {
        loadStates[cityId] = .loading
        tasks[cityId]?.cancel()
        tasks[cityId] = Task { [weak self] in
            guard let self else { return }
            do {
                let weather = try await self.weatherService.fetchWeather(
                    latitude: latitude,
                    longitude: longitude
                )
                if Task.isCancelled { return }
                self.loadStates[cityId] = .loaded(weather)
            } catch {
                if self.isCancellation(error) { return }
                self.loadStates[cityId] = .failed(error.localizedDescription)
            }
        }
    }

    func loadAllWeather() {
        for city in cities {
            loadWeather(
                cityId: city.id,
                latitude: city.latitude,
                longitude: city.longitude
            )
        }
    }

    /// 下拉刷新入口:`.refreshable { await viewModel.refreshAll() }`
    func refreshAll() async {
        for (_, task) in tasks { task.cancel() }
        tasks.removeAll()
        loadAllWeather()
        // 简化等待:让 Task 真正启动
        try? await Task.sleep(for: .milliseconds(100))
    }

    func retry(cityId: City.ID, latitude: Double, longitude: Double) {
        loadWeather(cityId: cityId, latitude: latitude, longitude: longitude)
    }

    func cancelAll() {
        for (_, task) in tasks { task.cancel() }
        tasks.removeAll()
    }

    // MARK: - 城市搜索与收藏

    func searchCities(name: String) {
        searchTask?.cancel()
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            searchState = .loaded([])
            return
        }
        searchState = .loading
        searchTask = Task { [weak self] in
            guard let self else { return }
            do {
                let results = try await self.geocodingService.fetch(name: trimmed)
                if Task.isCancelled { return }
                self.searchState = .loaded(results)
            } catch {
                if self.isCancellation(error) { return }
                self.searchState = .failed(error.localizedDescription)
            }
        }
    }

    @discardableResult
    func addCity(_ city: City) -> City? {
        if cities.contains(where: { $0.id == city.id }) {
            return nil
        }
        cities.append(city)
        loadWeather(
            cityId: city.id,
            latitude: city.latitude,
            longitude: city.longitude
        )
        return city
    }

    // MARK: - 私有辅助

    /// 三源识别取消信号(沿用第 30/31 章)
    private func isCancellation(_ error: Error) -> Bool {
        if error is CancellationError { return true }
        if let urlError = error as? URLError, urlError.code == .cancelled {
            return true
        }
        if Task.isCancelled { return true }
        return false
    }
}