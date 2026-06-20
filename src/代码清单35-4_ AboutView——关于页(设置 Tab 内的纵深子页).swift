import SwiftUI

/// 关于页:作为设置 Tab 内部的 push 目标,展示 App 名称与版本号。
struct AboutView: View {
    // 从 Info.plist 读取,而非硬编码常量:版本号在打包时由 Xcode 注入,
    // 写死会导致显示值与实际构建版本不一致。读取结果可能为 nil(字段缺失),
    // 用 ?? 给出可读的兜底文案,保证任何情况下界面都不为空白。
    private var appName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
            ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
            ?? "笔记"
    }

    private var versionNumber: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }

    private var buildNumber: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
    }

    var body: some View {
        List {
            Section {
                VStack(spacing: 8) {
                    Image(systemName: "note.text")
                        .font(.system(size: 56))
                        // 用 foregroundStyle 而非已不推荐的 foregroundColor,
                        // 前者支持渐变/材质等更丰富的样式来源。
                        .foregroundStyle(.tint)
                    Text(appName)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("版本 \(versionNumber) (\(buildNumber))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)   // 让内容水平居中
                .padding(.vertical, 12)
            }

            Section("说明") {
                Text("这是一个用 SwiftUI 与 SwiftData 构建的本地笔记应用,支持创建、编辑与删除笔记。")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("关于")
        // 子页用 inline 标题,视觉上与上级「设置」的 large 标题区分层级。
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    // 预览时单独包一层 NavigationStack,才能看到导航栏与标题效果;
    // 真实运行时它由 SettingsView 的 NavigationStack 提供,不会重复嵌套。
    NavigationStack {
        AboutView()
    }
}