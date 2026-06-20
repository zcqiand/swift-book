import SwiftUI

/// 城市搜索页
///
/// 交互流程:
/// 1. TextField 输入城市名 -> onChange 触发 viewModel.searchCities(name:)
/// 2. List 渲染 searchState(loading / loaded / failed)
/// 3. 点击候选 -> viewModel.addCity(city) -> dismiss
struct CitySearchView: View {

    let viewModel: WeatherViewModel
    let onDismiss: () -> Void

    @State private var query: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TextField("输入城市名(如 北京)", text: $query)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .onChange(of: query) { _, newValue in
                        viewModel.searchCities(name: newValue)
                    }

                content
            }
            .navigationTitle("搜索城市")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("取消") {
                        onDismiss()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.searchState {
        case .loading:
            VStack(spacing: 12) {
                ProgressView("搜索中…")
                    .controlSize(.large)
                Text("正在查询 \"\(query)\"")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded(let cities):
            if cities.isEmpty {
                ContentUnavailableView(
                    "暂无结果",
                    systemImage: "magnifyingglass",
                    description: Text("试试输入 \"北京\" 或 \"上海\"")
                )
            } else {
                List(cities) { city in
                    Button {
                        _ = viewModel.addCity(city)
                        onDismiss()
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(city.name)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Text(String(format: "经度 %.4f · 纬度 %.4f", city.longitude, city.latitude))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

        case .failed(let message):
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                    .foregroundStyle(.red)
                Text("搜索失败")
                    .font(.headline)
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Button("重试") {
                    viewModel.searchCities(name: query)
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    CitySearchView(
        viewModel: WeatherViewModel(),
        onDismiss: { print("dismiss") }
    )
}