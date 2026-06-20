// 在 WeatherViewModel 类内新增
func loadTwoCities() {
    task?.cancel()
    isLoading = true
    errorMessage = nil

    task = Task { [weak self] in
        guard let self else { return }
        do {
            // async let 在等号右侧立即启动一个子任务，并不等待其完成；
            // 两行连写即等于两个请求并发飞出去，总耗时约等于较慢的那一个。
            // 对比串行 await：总耗时 ≈ t(beijing) + t(shanghai)。
            async let beijing = self.service.fetchWeather(
                latitude: 39.9042, longitude: 116.4074
            )
            async let shanghai = self.service.fetchWeather(
                latitude: 31.2304, longitude: 121.4737
            )

            // try await (a, b) 一次性收集两个 async let 的结果；
            // 任意一个抛错都会触发整个表达式抛错，并自动取消另一个仍在运行的子任务（结构化并发的兜底）。
            let (beijingWeather, shanghaiWeather) = try await (beijing, shanghai)

            // 双城市结果仅打印到控制台用于教学演示，UI 仍以北京为主显示，
            // 避免为了演示并发而污染 ViewModel 的主数据模型。
            print("北京温度：\(beijingWeather.temperature) °C")
            print("上海温度：\(shanghaiWeather.temperature) °C")

            self.currentWeather = beijingWeather
        } catch {
            // 与 loadWeather 同款取消识别：URLSession 抛 URLError(.cancelled)、
            // Concurrency 原语抛 CancellationError，统一交给 isCancellation(_:) 处理。
            if self.isCancellation(error) {
                return
            }
            self.errorMessage = error.localizedDescription
        }
        self.isLoading = false
    }
}