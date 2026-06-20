import Foundation

/// 城市模型
///
/// Identifiable 让 List + ForEach(cities) 能直接以 id 作为 diff key，
/// 避免视图重建时的整表重渲，与第 24 章 TodoItem 同构（回扣 C043 协议）。
/// Codable 是为后续章节做收藏持久化时可以直接 JSONEncoder/JSONDecoder，
/// 本章只声明、不落盘（持久化属于第 34 章 SwiftData 范畴）。
struct City: Identifiable, Codable, Hashable {
    /// 城市唯一标识，使用 UUID 保证跨设备/跨启动期稳定
    let id: UUID
    /// 城市展示名（如 "北京"）
    let name: String
    /// 纬度，Open-Meteo 接口使用
    let latitude: Double
    /// 经度，Open-Meteo 接口使用
    let longitude: Double

    init(id: UUID = UUID(), name: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}