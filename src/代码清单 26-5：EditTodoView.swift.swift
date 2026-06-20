import SwiftUI

struct EditTodoView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String

    let navigationTitle: String
    let onSave: (String) -> Void

    private var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    init(
        initialTitle: String,
        navigationTitle: String,
        onSave: @escaping (String) -> Void
    ) {
        _title = State(initialValue: initialTitle)
        self.navigationTitle = navigationTitle
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("标题") {
                    TextField("例如：买牛奶", text: $title)
                        .textInputAutocapitalization(.never)
                        .submitLabel(.done)
                        .onSubmit(saveIfNeeded)
                }
            }
            .navigationTitle(navigationTitle)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        saveIfNeeded()
                    }
                    .disabled(trimmedTitle.isEmpty)
                }
            }
        }
    }

    private func saveIfNeeded() {
        guard trimmedTitle.isEmpty == false else { return }

        onSave(trimmedTitle)
        dismiss()
    }
}

#Preview("新增") {
    EditTodoView(initialTitle: "", navigationTitle: "新增待办") { title in
        print("新增：\(title)")
    }
}

#Preview("编辑") {
    EditTodoView(initialTitle: "整理 SwiftUI 项目", navigationTitle: "编辑待办") { title in
        print("编辑后：\(title)")
    }
}