# WeatherApp

WeatherApp 是本书项目二的练习应用。本章只完成需求拆解与工程骨架搭建，不联网，不解析真实天气数据。

## 本章交付

- 能在 iOS 26 模拟器中启动。
- 首页显示“天气 App 骨架已创建”。
- 工程中拆分 Models、Networking、Views、ViewModels。
- 不访问网络，不申请定位权限，不处理真实天气数据。

## 目录职责

- `WeatherApp.swift`：App 入口，只负责启动根界面。
- `Views/ContentView.swift`：首页界面，本章只显示静态骨架。
- `Models/Weather.swift`：天气数据模型预留位置，本章不实现 Codable 解析。
- `Networking/WeatherService.swift`：网络访问层预留位置，本章不写真实请求。
- `ViewModels/WeatherViewModel.swift`：界面状态层预留位置，本章不实现业务状态机。

## Open-Meteo 候选 URL

后续章节可考虑使用 Open-Meteo 的公开接口，例如：

`https://api.open-meteo.com/v1/forecast?latitude=31.2304&longitude=121.4737&current=temperature_2m,weather_code,wind_speed_10m`

Open-Meteo 是第三方免费天气 API，通常免 API key。字段名称、单位和响应结构以后续核验为准。本章只记录候选地址，不在代码中请求该 URL。

## 后续 TODO

- 第 28 章：调用真实天气 API。
- 第 29 章：设计 Codable 数据模型并解析 JSON。
- 第 30 章：把结果接回 SwiftUI 界面。
- 第 31 章：补齐加载、错误和刷新状态。