import Foundation

/// 加载状态机
///
/// 三态语义:
/// - loading:请求已发起、尚未返回,UI 显示骨架/进度
/// - loaded(T):请求成功,UI 渲染数据
/// - failed(String):请求失败,UI 展示错误文案
enum LoadState<T> {
    case loading
    case loaded(T)
    case failed(String)
}