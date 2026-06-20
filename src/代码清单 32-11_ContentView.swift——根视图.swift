import SwiftUI

/// 项目根视图
///
/// 实际渲染 CityListView,本文件仅作根引用保留,方便后续章节扩展为
/// TabView 多模块架构时只换根而不动列表代码。
struct ContentView: View {
    var body: some View {
        CityListView()
    }
}

#Preview {
    ContentView()
}