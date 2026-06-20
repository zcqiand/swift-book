import SwiftUI

/// 待办清单主视图（持久化版）。
///
/// 相对第 24 章清单 24-2 的三处升级：
/// 1) 启动加载：.onAppear 时调 TodoStore.load() 读出上次存档；
/// 2) 增删改后显式 save：在 add / delete / toggle 后立刻调用 TodoStore.save(items)；
/// 3) @AppStorage("nightMode") 顶部偏好：演示单值偏好的声明式持久化（呼应清单 25-1）。
struct TodoListView: View {
    // 初始值给空数组：真实数据在 .onAppear 里从 TodoStore.load() 拉取后覆盖。
    // 不在初始化器里直接 = TodoStore.load()：View 是值类型，SwiftUI 可能在某些场景
    // 重新构造 View 实例，直接初始化会导致每次重建都触发一次磁盘 IO。
    @State private var items: [TodoItem] = []

    // @AppStorage 是 UserDefaults 的 SwiftUI 响应式封装（C088）：
    // - 写入：用户拨动 Toggle 时，新值自动 set 进 UserDefaults.standard["nightMode"]；
    // - 读取：App 重启后自动从 UserDefaults 恢复，无需手动 load；
    // - 刷新：值变化时自动驱动本 View 重算（与 @State 同属响应式心智模型）。
    // 注意：@AppStorage 只支持 plist 基础类型（Bool/Int/Double/String/Data/URL...），
    // 不能直接存 [TodoItem]——数组那条路径仍走 TodoStore（清单 25-3）。
    @AppStorage("nightMode") private var nightMode = false

    var body: some View {
        NavigationStack {
            List {
                // ── 偏好区：单值持久化的声明式演示 ──
                Section {
                    Toggle("夜间模式", isOn: $nightMode)
                } header: {
                    Text("偏好（@AppStorage 持久化）")
                }

                // ── 待办区：[TodoItem] 走 Codable + UserDefaults ──
                Section {
                    ForEach(items) { item in
                        NavigationLink(value: item) {
                            todoRow(item)
                        }
                    }
                    // .onDelete 接管 List 的侧滑删除手势（系统提供 IndexSet），无需自己写滑动手势。
                    .onDelete(perform: delete)
                } header: {
                    Text("待办（\(items.count) 条）")
                }
            }
            .navigationDestination(for: TodoItem.self) { item in
                // 详情页沿用第 24 章清单 24-3 的 TodoDetailView（值副本展示）。
                TodoDetailView(item: item)
            }
            .navigationTitle("待办清单")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        addTodo()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            // 启动加载：视图首次出现时从 TodoStore 拉取持久化数据。
            // 用 .onAppear 而不是 init，与第 24 章 @State 心智一致，更直观，
            // 也避免在 init 中用 _items = State(initialValue:) 的特殊语法增加初学者负担。
            .onAppear {
                if items.isEmpty {
                    items = TodoStore.load()
                }
            }
        }
    }

    /// 单行视图：标题 + 行内 Toggle（通过 toggleCompletion(at:) 改数据源 + 显式 save）。
    ///
    /// 为什么 Toggle 不用 Binding 直接绑 $items[index].isCompleted？
    /// 那样写只改了 @State 数组里的值，不会自动调 TodoStore.save(items)，重启后勾选状态会丢。
    /// 抽成 toggleCompletion(at:) 方法后，「改数组 + 显式 save」与 addTodo / delete 完全同形，
    /// 三条修改路径都走同一套「修改 → save」模板，不会漏。
    ///
    /// Toggle 视觉保留：拨动后依然变绿、标题置灰；读者对 SwiftUI Toggle 在第 22 / 23 章已经熟悉，
    /// 这里不换成 Button，保持与顶部夜间模式 Toggle 的视觉一致。
    @ViewBuilder
    private func todoRow(_ item: TodoItem) -> some View {
        if let index = items.firstIndex(of: item) {
            // 用 Binding(get:set:) 包一层：get 读 isCompleted、set 把拨动转发给 toggleCompletion(at:)。
            // set 里不直接使用 newValue，而是统一交给 toggleCompletion(at:) 处理，集中保存逻辑。
            Toggle(isOn: Binding(
                get: { items[index].isCompleted },
                set: { _ in toggleCompletion(at: index) }
            )) {
                Text(item.title)
                    // 已完成项置灰：与第 24 章一致的视觉规范，用 .foregroundStyle 不用已弃用的 .foregroundColor。
                    .foregroundStyle(item.isCompleted ? .secondary : .primary)
            }
            .tint(item.isCompleted ? .green : .accentColor)
        }
    }

    // MARK: - 数据操作（每次修改后显式 save）

    /// 添加一条新待办。
    private func addTodo() {
        // 用「新待办 N」命名便于演示；真实 App 应弹输入框（第 26 章会做）。
        let newTitle = "新待办 \(items.count + 1)"
        items.append(TodoItem(title: newTitle))
        TodoStore.save(items)
    }

    /// 删除指定行（由 List 的 .onDelete 触发）。
    /// - Parameter indexSet: 用户侧滑选中的下标集合（系统传入）。
    private func delete(at indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
        TodoStore.save(items)
    }

    /// 切换指定行待办的完成状态，并在改完后显式 save。
    ///
    /// 为什么抽成方法而不是 Toggle 直接绑 $items[index].isCompleted？
    /// 1) 直接绑只能改 @State 内存值，不会自动触发 TodoStore.save(items)，
    ///    重启 App 后勾选状态会丢，和 25.7 重启验证的交付物直接矛盾。
    /// 2) 显式 save 的风格与 addTodo / delete 完全统一：「修改数组 + 立刻 save」同形。
    /// 3) 不挂 .onChange(of: item.isCompleted)：onChange 在「数组元素内部属性变化」与「整体替换」时
    ///    行为不完全一致，在每个明确修改点显式 save 更直观、更不容易踩边界。
    private func toggleCompletion(at index: Int) {
        items[index].isCompleted.toggle()
        TodoStore.save(items)
    }
}

#Preview {
    TodoListView()
}