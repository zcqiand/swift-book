import SwiftUI

/// 天气详情页
struct WeatherDetailView: View {
    /// 入参：目标城市
    let city: City
    /// 共享视图模型（与列表页同一实例）
    let viewModel: WeatherViewModel

    var body: some View {
        VStack(spacing: 16) {
            // 顶部城市名卡片
            Text(city.name)
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundStyle(.white)
                .background(.blue.opacity(0.6), in: RoundedRectangle(cornerRadius: 16))

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            Spacer()
        }
        .padding()
        .navigationTitle(city.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadWeather(
                cityId: city.id,
                latitude: city.latitude,
                longitude: city.longitude
            )
        }
        .onDisappear {
            // 简化策略：列表页 .onAppear 会重新触发 loadAllWeather
            viewModel.cancelAll()
        }
    }

    /// 状态内容视图：根据 loadStates[city.id] 切换三态
    @ViewBuilder
    private var content: some View {
        switch viewModel.loadStates[city.id] {
        case .none, .loading:
            VStack(spacing: 12) {
                ProgressView("加载中…")
                    .controlSize(.large)
                Text("正在获取 \(city.name) 的实时天气")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        case .loaded(let weather):
            VStack(spacing: 12) {
                Text(String(format: "%.1f°C", weather.temperature))
                    .font(.system(size: 64, weight: .bold))
                Label("天气代码 \(weather.weatherCode)", systemImage: "cloud")
                    .font(.headline)
                Label("风速 \(String(format: "%.1f", weather.windSpeed)) m/s", systemImage: "wind")
                    .font(.headline)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
        case .failed(let message):
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                    .foregroundStyle(.red)
                Text("加载失败")
                    .font(.headline)
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                Button("重试") {
                    viewModel.retry(
                        cityId: city.id,
                        latitude: city.latitude,
                        longitude: city.longitude
                    )
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}

#Preview {
    NavigationStack {
        WeatherDetailView(
            city: City(name: "北京", latitude: 39.9042, longitude: 116.4074),
            viewModel: WeatherViewModel()
        )
    }
}