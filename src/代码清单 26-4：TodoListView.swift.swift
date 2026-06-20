import SwiftUI

struct TodoListView: View {
    @State private var items: [TodoItem] = TodoStore.load()
    @State private var isPresentingEditor = false
    @State private var editingItem: TodoItem?

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    HStack(spacing: 12) {
                        Toggle(
                            isOn: Binding(
                                get: { item.isCompleted },
                                set: { newValue in
                                    toggleCompletion(for: item, isCompleted: newValue)
                                }
                            )
                        ) {
                            EmptyView()
                        }
                        .labelsHidden()

                        Button {
                            beginEditing(item)
                        } label: {
                            Text(item.title)
                                .strikethrough(item.isCompleted)
                                .foregroundStyle(item.isCompleted ? .secondary : .primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .buttonStyle(.plain)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(item.title)
                    .accessibilityValue(item.isCompleted ? "已完成" : "未完成")
                }
                .onDelete(perform: deleteItems)
                .onMove(perform: moveItems)
            }
            .overlay {
                if items.isEmpty {
                    ContentUnavailableView(
                        "还没有待办",
                        systemImage: "checklist",
                        description: Text("点右上角加号添加第一条待办")
                    )
                }
            }
            .navigationTitle("待办清单")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        beginAdding()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("新增待办")
                }
            }
            .sheet(isPresented: $isPresentingEditor) {
                if let editingItem {
                    EditTodoView(
                        initialTitle: editingItem.title,
                        navigationTitle: "编辑待办"
                    ) { newTitle in
                        updateTitle(for: editingItem, newTitle: newTitle)
                    }
                } else {
                    EditTodoView(
                        initialTitle: "",
                        navigationTitle: "新增待办"
                    ) { title in
                        addItem(title: title)
                    }
                }
            }
        }
    }

    private func beginAdding() {
        editingItem = nil
        isPresentingEditor = true
    }

    private func beginEditing(_ item: TodoItem) {
        editingItem = item
        isPresentingEditor = true
    }

    private func addItem(title: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedTitle.isEmpty == false else { return }

        items.append(TodoItem(title: trimmedTitle))
        TodoStore.save(items)
    }

    private func updateTitle(for item: TodoItem, newTitle: String) {
        let trimmedTitle = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedTitle.isEmpty == false else { return }
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }

        items[index].title = trimmedTitle
        TodoStore.save(items)
    }

    private func toggleCompletion(for item: TodoItem, isCompleted: Bool) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }

        items[index].isCompleted = isCompleted
        TodoStore.save(items)
    }

    private func deleteItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        TodoStore.save(items)
    }

    private func moveItems(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
        TodoStore.save(items)
    }
}

#Preview {
    TodoListView()
}