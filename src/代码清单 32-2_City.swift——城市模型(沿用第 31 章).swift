import Foundation

/// 城市模型
///
/// Identifiable:让 List + ForEach(cities) 能直接以 id 作为 diff key。
/// Codable:为后续章节做收藏持久化时可以直接 JSONEncoder/JSONDecoder;本章不落盘,仅声明。
/// Hashable:值类型导航 `.navigationDestination(for: City.self)` 需要。
struct City: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double

    init(id: UUID = UUID(), name: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}