// 在 ContentView 的 VStack 中，紧接「刷新（北京）」按钮下方加入：
Button("同时获取北京 + 上海") {
    viewModel.loadTwoCities()
}
.buttonStyle(.bordered)