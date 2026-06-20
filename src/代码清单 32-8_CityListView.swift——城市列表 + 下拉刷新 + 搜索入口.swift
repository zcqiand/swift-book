import SwiftUI

/// 城市列表页(项目二收束版)
///
/// 关键点:
/// 1. `.refreshable` 触发下拉刷新,调用 viewModel.refreshAll()
/// 2. toolbar 提供「搜索城市」入口,sheet 弹出 CitySearchView
/// 3. value-based 导航:NavigationLink(value:) + navigationDestination(for:)
/// 4. 失败态重试走 swipeActions(沿用第 31 章方案 A),避免行内 button 与
///    NavigationLink 手势冲突
struct CityListView: View {

    @State private var viewModel = WeatherViewModel()
    @State private var isShowingSearch = false
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(viewModel.cities) { city in
                    weatherRow(for: city)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            path.append(city)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            if case .failed = viewModel.loadStates[city.id] {
                                Button("重试") {
                                    viewModel.retry(
                                        cityId: city.id,
                                        latitude: city.latitude,
                                        longitude: city.longitude
                                    )
                                }
                                .tint(.blue)
                            }
                        }
                }
            }
            .navigationTitle("城市天气")
            .navigationDestination(for: City.self) { city in
                WeatherDetailView(city: city, viewModel: viewModel)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingSearch = true
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    .accessibilityLabel("搜索城市")
                }
            }
            .refreshable {
                await viewModel.refreshAll()
            }
            .onAppear {
                viewModel.loadAllWeather()
            }
            .onDisappear {
                viewModel.cancelAll()
            }
            .sheet(isPresented: $isShowingSearch) {
                CitySearchView(viewModel: viewModel) {
                    isShowingSearch = false
                }
            }
        }
    }

    @ViewBuilder
    private func weatherRow(for city: City) -> some View {
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
            }
        }
    }
}

#Preview {
    CityListView()
}