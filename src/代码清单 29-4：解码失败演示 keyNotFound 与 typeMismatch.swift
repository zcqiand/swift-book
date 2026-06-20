import Foundation

struct DemoWeatherResponse: Codable {
    let current: DemoCurrentWeather
}

struct DemoCurrentWeather: Codable {
    let temperature: Double
    let weatherCode: Int
    let windSpeed: Double

    enum CodingKeys: String, CodingKey {
        case temperature = "temperature_2m"
        case weatherCode = "weather_code"
        case windSpeed = "wind_speed_10m"
    }
}

enum DecodingDemo {
    static func run() {
        let missingKeyJSON = """
        {
          "current": {
            "temperature_2m": 23.5,
            "wind_speed_10m": 3.2
          }
        }
        """

        let typeMismatchJSON = """
        {
          "current": {
            "temperature_2m": "twenty-three",
            "weather_code": 0,
            "wind_speed_10m": 3.2
          }
        }
        """

        decode(title: "缺少 weather_code 字段", jsonText: missingKeyJSON)
        decode(title: "temperature_2m 类型错误", jsonText: typeMismatchJSON)
    }

    private static func decode(title: String, jsonText: String) {
        print("开始测试：\(title)")
        let data = Data(jsonText.utf8)

        do {
            let response = try JSONDecoder().decode(DemoWeatherResponse.self, from: data)
            print("解码成功：\(response.current)")
        } catch DecodingError.keyNotFound(let key, let context) {
            print("缺少字段：\(key.stringValue)，位置：\(pathDescription(context.codingPath))")
        } catch DecodingError.typeMismatch(let expectedType, let context) {
            print("类型不匹配：期望 \(expectedType)，位置：\(pathDescription(context.codingPath))")
        } catch {
            print("其他错误：\(error.localizedDescription)")
        }
    }

    private static func pathDescription(_ codingPath: [CodingKey]) -> String {
        guard !codingPath.isEmpty else {
            return "JSON 根节点"
        }

        return codingPath.map(\.stringValue).joined(separator: ".")
    }
}

// Playground 或 Swift 脚本可直接取消注释运行；
// 普通 iOS App Swift 文件不要保留顶层调用，改从按钮、.task、.onAppear、单元测试或临时调试函数中调用。
// DecodingDemo.run()