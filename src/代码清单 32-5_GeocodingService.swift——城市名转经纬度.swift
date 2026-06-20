import Foundation

/// Geocoding 服务错误类型
enum GeocodingServiceError: Error, LocalizedError {
    case badURL
    case invalidResponse
    case badStatusCode(Int)

    var errorDescription: String? {
        switch self {
        case .badURL:
            return "无法生成有效的城市搜索 URL。"
        case .invalidResponse:
            return "城市搜索返回的不是有效的 HTTP 响应。"
        case .badStatusCode(let statusCode):
            return "城市搜索失败,HTTP 状态码:\(statusCode)。"
        }
    }
}

/// Open-Meteo 内部响应模型(私有)
private struct GeocodingResponse: Decodable {
    let results: [GeocodingResult]?
}

private struct GeocodingResult: Decodable {
    let latitude: Double
    let longitude: Double
    let name: String
    let country: String?
    let admin1: String?
    let id: Int?

    /// 把 Open-Meteo 结果映射成本地 City
    func toCity() -> City {
        let displayName: String
        if let country, !country.isEmpty {
            displayName = "\(name), \(country)"
        } else {
            displayName = name
        }
        return City(
            id: UUID(),
            name: displayName,
            latitude: latitude,
            longitude: longitude
        )
    }
}

/// 城市地理编码服务
final class GeocodingService {
    func fetch(name: String) async throws -> [City] {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "geocoding-api.open-meteo.com"
        components.path = "/v1/search"
        components.queryItems = [
            URLQueryItem(name: "name", value: name),
            URLQueryItem(name: "count", value: "5"),
            URLQueryItem(name: "language", value: "zh"),
            URLQueryItem(name: "format", value: "json")
        ]

        guard let url = components.url else {
            throw GeocodingServiceError.badURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw GeocodingServiceError.invalidResponse
        }
        guard 200..<300 ~= httpResponse.statusCode else {
            throw GeocodingServiceError.badStatusCode(httpResponse.statusCode)
        }

        let decoded = try JSONDecoder().decode(GeocodingResponse.self, from: data)
        let results = decoded.results ?? []
        return results.map { $0.toCity() }
    }
}