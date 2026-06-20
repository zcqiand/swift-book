import Foundation

/// 天气服务错误类型
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
            return "天气请求失败,HTTP 状态码:\(statusCode)。"
        case .unreadableData:
            return "原始数据无法按 UTF-8 文本读取。"
        }
    }
}

/// 天气查询服务
///
/// 延续第 28 章的 REST 调用风格:URLComponents 构造 + URLRequest + async throws。
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
}