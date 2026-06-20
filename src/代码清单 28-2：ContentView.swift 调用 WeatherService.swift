import SwiftUI

struct ContentView: View {
    private let service = WeatherService()

    @State private var message = "点击按钮，请求一份原始天气数据。"
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("WeatherApp")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("本章只获取原始 Data，不解析 JSON。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text(message)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(isLoading ? .secondary : .primary)

                Button {
                    fetchWeather()
                } label: {
                    Text(isLoading ? "请求中..." : "请求北京天气")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
                .disabled(isLoading)

                Spacer()
            }
            .padding()
            .navigationTitle("原始天气数据")
        }
    }

    private func fetchWeather() {
        isLoading = true
        message = "正在请求 Open-Meteo..."

        Task {
            do {
                let data = try await service.fetchRawWeather(
                    latitude: 39.9042,
                    longitude: 116.4074
                )

                print("响应字节数：\(data.count)")
                message = "请求成功：\(data.count) 字节"
            } catch {
                print("请求失败：\(error.localizedDescription)")
                message = "请求失败：\(error.localizedDescription)"
            }

            isLoading = false
        }
    }
}

#Preview {
    ContentView()
}