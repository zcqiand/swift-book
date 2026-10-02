import SwiftUI

struct SyncDemoView: View {
    // @State 持有 @MainActor + @Observable 的 SyncDemo，状态变化自动驱动视图刷新。
    @State private var demo = SyncDemo()

    var body: some View {
        NavigationStack {
            List {
                Section("状态") {
                    Text(demo.statusText)
                        .foregroundStyle(.secondary)
                }
                Section("已同步笔记") {
                    // displayedNotes 由后台同步在 MainActor.run 中写入，
                    // 写入即触发 List 刷新，无需手动通知 UI。
                    ForEach(demo.displayedNotes) { note in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(note.title).font(.headline)
                            Text(note.content).font(.subheadline).foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("后台同步演示")
            .toolbar {
                Button("开始同步") {
                    demo.startBackgroundSync()
                }
            }
        }
    }
}

#Preview {
    SyncDemoView()
}