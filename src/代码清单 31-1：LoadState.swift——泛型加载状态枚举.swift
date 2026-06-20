import Foundation

/// 加载状态机
///
/// 三态语义：
/// - loading：请求已发起、尚未返回，UI 显示骨架/进度
/// - loaded(T)：请求成功，UI 渲染数据
/// - failed(String)：请求失败，UI 展示错误文案
///
/// 注意：本章故意不引入 Equatable。理由是工程层面而非并发层面：
/// 1. 合成 Equatable 会让泛型 `LoadState<T>` 自动加 `T: Equatable` 约束，
///    在本章 LoadState 只用于视图三态渲染、不进入 List diff 也不做
///    `==` 比较的场景下，这个约束会沿用到所有使用方的泛型实参上，
///    徒增「明明只想区分状态、却被要求 T 可比较」的模板噪音；
/// 2. 视图层只通过 switch 模式匹配三个 case，不需要 `==`。
/// 如未来 LoadState 需要进入 List diff 或测试断言，可在第 36/38 章再扩展。
/// 同样不引入 Identifiable——LoadState 不是数据行，是状态标签。
enum LoadState<T> {
    case loading
    case loaded(T)
    case failed(String)
}