import SwiftUI

struct ContentView: View {

    // 用 @State 持有 @Observable class 实例是 SwiftUI 在 iOS 17+ 推荐的写法，
    // 它取代了过去的 @StateObject / ObservableObject 组合，由编译期宏完成依赖追踪。
    @State private var viewModel = WeatherViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("第30章：天气 ViewModel")
                .font(.title2)
                .fontWeight(.semibold)

            // 三态视图：加载中 / 已有数据 / 既无数据也未在加载（首次进入）。
            if viewModel.isLoading {
                ProgressView("加载中…")
            } else if let weather = viewModel.currentWeather {
                weatherCard(for: weather)
            } else {
                Text("点击下方按钮获取天气")
                    .foregroundStyle(.secondary)
            }

            // 错误文案独立于上面的三态，加载失败也要保留，便于用户看到原因后重试。
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }

            Button("刷新（北京）") {
                viewModel.refresh()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        // 视图消失时主动取消请求，避免无谓的网络与状态写入。
        .onDisappear {
            viewModel.cancelLoading()
        }
    }

    // 抽取卡片为局部函数，body 表达式更清爽。
    @ViewBuilder
    private func weatherCard(for weather: CurrentWeather) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("温度：\(weather.temperature, specifier: "%.1f") °C")
            Text("天气代码：\(weather.weatherCode)")
            Text("风速：\(weather.windSpeed, specifier: "%.1f") km/h")
        }
        .padding()
        // iOS 26 推荐用 background(in:) 直接接收形状，
        // 取代已弃用的 .cornerRadius(_:)。
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    ContentView()
}