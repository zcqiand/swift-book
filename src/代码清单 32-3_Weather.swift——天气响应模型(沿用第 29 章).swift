import Foundation

/// Open-Meteo forecast 接口的顶层响应
struct WeatherResponse: Codable {
    let current: CurrentWeather
}

/// 当前天气(嵌套在 WeatherResponse.current 下)
///
/// 字段名通过 CodingKeys 翻译:
/// - temperature_2m  -> temperature
/// - weather_code    -> weatherCode
/// - wind_speed_10m  -> windSpeed
struct CurrentWeather: Codable, Hashable {
    let temperature: Double
    let weatherCode: Int
    let windSpeed: Double

    enum CodingKeys: String, CodingKey {
        case temperature = "temperature_2m"
        case weatherCode = "weather_code"
        case windSpeed = "wind_speed_10m"
    }
}