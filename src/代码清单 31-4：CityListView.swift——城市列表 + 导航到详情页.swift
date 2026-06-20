import SwiftUI

/// 城市列表页
struct CityListView: View {

    /// 写死的三个示例城市。坐标沿用第 27 章 Open-Meteo 数据
    private let cities: [City] = [
        City(name: "北京", latitude: 39.9042, longitude: 116.4074),
        City(name: "上海", latitude: 31.2304, longitude: 121.4737),
        City(name: "广州", latitude: 23.1291, longitude: 113.2644)
    ]

    /// 共享视图模型。详情页通过入参复用同一实例
    @State private var viewModel = WeatherViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(cities) { city in
                    // value-based NavigationLink：跳转目标通过 .navigationDestination 注册
                    NavigationLink(value: city) {
                        weatherRow(for: city)
                    }
                }
            }
            .navigationTitle("城市天气")
            // 注册 City 类型的目标视图
            .navigationDestination(for: City.self) { city in
                WeatherDetailView(city: city, viewModel: viewModel)
            }
            .onAppear {
                viewModel.loadAllWeather(cities: cities)
            }
            .onDisappear {
                viewModel.cancelAll()
            }
        }
    }

    /// 单个城市行：根据 loadStates 槽位渲染三态
    @ViewBuilder
    private func weatherRow(for city: City) -> some View {
        // 字典下标返回可选值，缺失时等同于「未加载」
        switch viewModel.loadStates[city.id] {
        case .none, .loading:
            HStack {
                Text(city.name).font(.headline)
                Spacer()
                ProgressView()
            }
        case .loaded(let weather):
            VStack(alignment: .leading, spacing: 4) {
                Text(city.name).font(.headline)
                Text(String(format: "%.1f°C", weather.temperature))
                    .font(.title2)
                Text("天气代码: \(weather.weatherCode) · 风速 \(String(format: "%.1f", weather.windSpeed)) m/s")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
        case .failed(let message):
            VStack(alignment: .leading, spacing: 4) {
                Text(city.name).font(.headline)
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.red)
                Button("点此重试") {
                    viewModel.retry(
                        cityId: city.id,
                        latitude: city.latitude,
                        longitude: city.longitude
                    )
                }
                .buttonStyle(.borderless)
                .foregroundStyle(.blue)
            }
        }
    }
}

#Preview {
    CityListView()
}