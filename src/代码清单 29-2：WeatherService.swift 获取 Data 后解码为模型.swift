import Foundation

enum WeatherServiceError: Error, LocalizedError {
    case badURL
    case invalidResponse
    case badStatusCode(Int)
    case unreadableData

    var errorDescription: String? {
        switch self {
        case .badURL:
            return "无法生成有效的天气请求 URL。"
        case .invalidResponse:
            return "服务器返回的不是有效的 HTTP 响应。"
        case .badStatusCode(let statusCode):
            return "天气请求失败，HTTP 状态码：\(statusCode)。"
        case .unreadableData:
            return "原始数据无法按 UTF-8 文本读取。"
        }
    }
}

final class WeatherService {
    func fetchRawWeather(latitude: Double, longitude: Double) async throws -> Data {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.open-meteo.com"
        components.path = "/v1/forecast"
        components.queryItems = [
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(name: "current", value: "temperature_2m,weather_code,wind_speed_10m")
        ]

        guard let url = components.url else {
            throw WeatherServiceError.badURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw WeatherServiceError.invalidResponse
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw WeatherServiceError.badStatusCode(httpResponse.statusCode)
        }

        return data
    }

    func fetchWeather(latitude: Double, longitude: Double) async throws -> CurrentWeather {
        let data = try await fetchRawWeather(latitude: latitude, longitude: longitude)
        let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
        return response.current
    }

    static func rawJSONPreview(from data: Data, limit: Int = 300) throws -> String {
        guard let jsonText = String(data: data, encoding: .utf8) else {
            throw WeatherServiceError.unreadableData
        }

        return String(jsonText.prefix(limit))
    }

    static func readableDecodingError(_ error: DecodingError) -> String {
        switch error {
        case .keyNotFound(let key, let context):
            let path = codingPathDescription(context.codingPath)
            return "缺少字段：\(key.stringValue)，位置：\(path)，说明：\(context.debugDescription)"
        case .typeMismatch(let expectedType, let context):
            let path = codingPathDescription(context.codingPath)
            return "类型不匹配：期望 \(expectedType)，位置：\(path)，说明：\(context.debugDescription)"
        case .valueNotFound(let expectedType, let context):
            let path = codingPathDescription(context.codingPath)
            return "值为空：期望 \(expectedType)，位置：\(path)，说明：\(context.debugDescription)"
        case .dataCorrupted(let context):
            let path = codingPathDescription(context.codingPath)
            return "数据损坏，位置：\(path)，说明：\(context.debugDescription)"
        @unknown default:
            return "未知解码错误：\(error.localizedDescription)"
        }
    }

    static func printDecodingError(_ error: Error) {
        if let decodingError = error as? DecodingError {
            print(readableDecodingError(decodingError))
        } else {
            print("非 JSON 解码错误：\(error.localizedDescription)")
        }
    }

    private static func codingPathDescription(_ codingPath: [CodingKey]) -> String {
        guard !codingPath.isEmpty else {
            return "JSON 根节点"
        }

        return codingPath.map(\.stringValue).joined(separator: ".")
    }
}