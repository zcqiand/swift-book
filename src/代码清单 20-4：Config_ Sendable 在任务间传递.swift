import Foundation

struct Config: Sendable {
    let baseURL: String
    let timeout: Int
}

Task {
    let config = Config(baseURL: "https://api.example.com", timeout: 30)

    await withTaskGroup(of: Void.self) { group in
        group.addTask {
            print("任务 A 读取配置：\(config.baseURL)，超时 \(config.timeout) 秒")
        }

        group.addTask {
            print("任务 B 读取配置：\(config.baseURL)，超时 \(config.timeout) 秒")
        }
    }
}