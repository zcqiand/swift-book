import SwiftUI

/// 外观偏好的三种取值。用枚举而非裸字符串,是为了让取值集合在编译期封闭、
/// 避免写错字符串;rawValue 为 String 以便直接存入 @AppStorage(UserDefaults)。
enum AppearanceMode: String, CaseIterable, Identifiable {
    case system = "system"
    case light = "light"
    case dark = "dark"

    var id: String { rawValue }

    /// 给 Picker 显示的中文标题。
    var label: String {
        switch self {
        case .system: return "跟随系统"
        case .light: return "浅色"
        case .dark: return "深色"
        }
    }

    /// 映射成 SwiftUI 的 ColorScheme。system 返回 nil,
    /// 表示「不强制」,由系统当前外观决定。
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

/// 设置标签的根视图。自带 NavigationStack,因为它要 push 到「关于」子页。
struct SettingsView: View {
    // @AppStorage 把这个值与 UserDefaults 里键名 "appearanceMode" 绑定:
    // 用户切换 Picker 时自动写盘,App 重启后自动读回,无需任何手写持久化代码。
    // 存的是 AppearanceMode.RawValue(String),读出后再转回枚举。
    @AppStorage("appearanceMode") private var storedAppearance: String = AppearanceMode.system.rawValue

    // 把存储的字符串包装成枚举类型的计算绑定,供 Picker 使用,
    // 这样 Picker 直接操作枚举,读写两侧各自做一次 String 与枚举的转换。
    private var appearanceBinding: Binding<AppearanceMode> {
        Binding(
            get: { AppearanceMode(rawValue: storedAppearance) ?? .system },
            set: { storedAppearance = $0.rawValue }
        )
    }

    private var currentAppearance: AppearanceMode {
        AppearanceMode(rawValue: storedAppearance) ?? .system
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("外观") {
                    // Picker 的选中项直接驱动 @AppStorage,用户一选即持久化。
                    Picker("主题", selection: appearanceBinding) {
                        ForEach(AppearanceMode.allCases) { mode in
                            Text(mode.label).tag(mode)
                        }
                    }
                }

                Section("关于") {
                    // 基于值的导航:声明跳转目标的「数据」,具体目的地视图
                    // 由下方 .navigationDestination 统一决定。与第 34 章笔记列表
                    // 的 NavigationLink(value:) 范式保持一致,不用旧式 destination:。
                    NavigationLink(value: SettingsRoute.about) {
                        Label("关于本应用", systemImage: "info.circle")
                    }
                }
            }
            .navigationTitle("设置")
            // 把 SettingsRoute.about 这个值映射到 AboutView。
            // 路由用专门的枚举而非 String,便于未来扩展更多设置子页。
            .navigationDestination(for: SettingsRoute.self) { route in
                switch route {
                case .about:
                    AboutView()
                }
            }
        }
        // 把用户选的外观应用到整个设置 Tab 的视图树。
        // .preferredColorScheme(nil) 表示跟随系统,传具体值则强制浅/深色。
        .preferredColorScheme(currentAppearance.colorScheme)
    }
}

/// 设置页的导航路由。用枚举集中管理可跳转的子页,
/// 新增子页时只需加一个 case 并在 navigationDestination 里补一个分支。
enum SettingsRoute: Hashable {
    case about
}

#Preview {
    SettingsView()
}