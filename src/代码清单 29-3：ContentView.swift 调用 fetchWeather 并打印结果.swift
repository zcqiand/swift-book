import SwiftUI

struct ContentView: View {
    private let service = WeatherService()

    var body: some View {
        VStack(spacing: 16) {
            Text("第29章：解析实时天气 JSON")
                .font(.title2)
                .fontWeight(.semibold)

            Button("获取北京当前天气") {
                Task {
                    await loadBeijingWeather()
                }
            }
            .buttonStyle(.borderedProminent)

            Button("打印原始 JSON 前 300 字") {
                Task {
                    await printRawJSONPreview()
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }

    private func loadBeijingWeather() async {
        do {
            let weather = try await service.fetchWeather(
                latitude: 39.9042,
                longitude: 116.4074
            )

            print("当前温度：\(weather.temperature)℃")
            print("天气代码：\(weather.weatherCode)")
            print("风速：\(weather.windSpeed)")
        } catch {
            print("获取天气失败：\(error.localizedDescription)")
            WeatherService.printDecodingError(error)
        }
    }

    private func printRawJSONPreview() async {
        do {
            let data = try await service.fetchRawWeather(
                latitude: 39.9042,
                longitude: 116.4074
            )
            let preview = try WeatherService.rawJSONPreview(from: data)
            print("原始 JSON 前 300 字：")
            print(preview)
        } catch {
            print("读取原始 JSON 失败：\(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}