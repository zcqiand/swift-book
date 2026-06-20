// 在 ContentView body 末尾按钮组中加：手动取消
Button("取消当前请求") {
    viewModel.cancelLoading()
}
.buttonStyle(.bordered)