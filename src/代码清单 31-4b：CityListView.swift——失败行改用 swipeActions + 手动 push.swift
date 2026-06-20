@State private var path = NavigationPath()

// NavigationStack(path: $path) { ... }  // body 顶部换 path 绑定版本

ForEach(cities) { city in
    weatherRow(for: city)
        .contentShape(Rectangle())
        .onTapGesture {
            // 主动 push，避免 NavigationLink(value:) 与行内 button 的手势冲突
            // SwiftUI 6 / iOS 26 常见模拟器场景下行点击 + 内嵌 button 双触发会偶发丢事件（落地以本机实测为准）
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