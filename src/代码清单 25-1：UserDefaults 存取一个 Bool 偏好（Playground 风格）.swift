import Foundation

// UserDefaults 是 Foundation 提供的轻量键值仓库：每个值通过一个字符串 key 寻址。
// .standard 是 App 主域的默认实例，写入内容会被 iOS 缓存到磁盘，正常情况下 App 杀进程重启后仍可读取。
let defaults = UserDefaults.standard

// ───────── 1. 存：把 Bool 偏好以指定 key 写入 ─────────
// key 是字符串，约定用功能名命名（不要用 0/1/单字母 key）。
// 值必须是 plist 基础类型：Bool / Int / Double / String / Data / Date / Array / Dictionary；
// 自定义 struct（如 TodoItem）不能直接 set，要先转成 Data（见清单 25-2 / 25-3）。
let nightModeKey = "nightMode"
defaults.set(true, forKey: nightModeKey)

// ───────── 2. 取（已存的 key）：用对应类型的专用读取方法 ─────────
// 专用方法返回非可选的 Bool/Int/...，调用方不必每次解包，写起来更顺手。
let readBack = defaults.bool(forKey: nightModeKey)
print("已存的 nightMode = \(readBack)")

// ───────── 3. 取（未存过的 key）：观察两种取值方式的行为差异 ─────────
let unknownKey = "thisKeyNeverExists"

// object(forKey:) 返回 Any?，未存过时是 nil，是「最诚实」的查询。
let honestProbe = defaults.object(forKey: unknownKey)
print("object(forKey:) 未存过的 key = \(String(describing: honestProbe))")

// bool(forKey:) 对未存过的 key 返回类型默认值 false，而不是 nil。
// 这个设计方便但也是陷阱：仅凭 == false 无法判断「用户真的设了 false」还是「从未设过」。
// 区分这两种情况要用 object(forKey:) == nil。
let boolProbe = defaults.bool(forKey: unknownKey)
print("bool(forKey:)   未存过的 key = \(boolProbe)  (类型默认值)")

// 清理：避免本示例污染后续运行环境（生产代码通常不会主动 remove 自己的偏好）。
defaults.removeObject(forKey: nightModeKey)