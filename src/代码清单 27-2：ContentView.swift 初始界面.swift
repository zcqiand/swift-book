import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Text("WeatherApp")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.primary)

                    Text("天气 App 骨架已创建")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("本章完成内容")
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text("1. 建立 iOS 26 SwiftUI 项目")
                    Text("2. 拆分 Models、Networking、Views、ViewModels 目录")
                    Text("3. 保持离线运行，为后续网络章节预留结构")
                }
                .font(.body)
                .foregroundStyle(.secondary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    .thinMaterial,
                    in: RoundedRectangle(cornerRadius: 24, style: .continuous)
                )

                Spacer()
            }
            .padding()
            .navigationTitle("天气")
        }
    }
}

#Preview {
    ContentView()
}