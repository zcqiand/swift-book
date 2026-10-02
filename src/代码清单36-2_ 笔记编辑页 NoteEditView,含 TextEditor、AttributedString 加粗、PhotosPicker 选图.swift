import SwiftUI
import SwiftData
import PhotosUI

struct NoteEditView: View {
    // @Bindable 让我们能直接对 @Model 实例的属性做双向绑定,
    // 写回 note.title / note.content 时,SwiftData 会自动持久化。
    @Bindable var note: Note

    // 拿到当前数据库上下文,用于保存(这里依赖 @Model 的自动持久化,
    // 仅在显式保存按钮里 try? context.save() 立即落盘,提升可预期性)。
    @Environment(\.modelContext) private var modelContext

    // 富文本演示片段:用 AttributedString 持有「带格式的文本」,
    // 它和普通 String 的区别在于每个字符可携带 font、颜色、加粗等属性。
    @State private var styledText = AttributedString("点下方按钮,让这段示例文字变粗")

    // PhotosPicker 的绑定状态:它代表「用户在相册里选中的那一项」,
    // 选中项本身不含图片数据,需要再异步加载才能拿到 Data。
    @State private var selectedPhotoItem: PhotosPickerItem?

    // 从选中项加载出来、用于界面展示的图片;nil 表示当前没有配图。
    @State private var selectedImage: Image?

    // 加载图片时若失败,用这个文案在界面上提示用户,而不是静默吞掉错误。
    @State private var photoLoadError: String?

    var body: some View {
        Form {
            Section("标题") {
                TextField("输入标题", text: $note.title)
            }

            Section("正文") {
                // 正文是多行内容,必须用 TextEditor 而非 TextField,
                // TextField 只适合单行短文本,无法自然换行编辑大段文字。
                TextEditor(text: $note.content)
                    .frame(minHeight: 160)
            }

            Section("富文本加粗演示") {
                // 直接把 AttributedString 交给 Text 渲染,
                // 它会忠实呈现其中携带的加粗等格式,这才是真正的富文本,
                // 而不是用 **xx** 这类 Markdown 字符串拼接冒充。
                Text(styledText)
                    .padding(.vertical, 4)

                Button("整段加粗") {
                    applyBoldToWholeText()
                }
            }

            Section("配图") {
                photoSection
            }
        }
        .navigationTitle("编辑笔记")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("保存") {
                    save()
                }
            }
        }
        // onChange 监听用户的新选择:每选一次就触发一次异步加载。
        // 用新版双参数闭包(oldValue, newValue)是 iOS 17+ 起的标准写法。
        .onChange(of: selectedPhotoItem) { _, newItem in
            loadImage(from: newItem)
        }
        // 视图首次出现时,若笔记已有配图,把它还原成 Image 展示出来。
        .onAppear {
            restoreExistingImage()
        }
    }

    // 把配图区域抽成计算属性,让 body 的结构更易读。
    @ViewBuilder
    private var photoSection: some View {
        PhotosPicker(
            selection: $selectedPhotoItem,
            matching: .images  // 限定只允许选图片,过滤掉视频等其它素材
        ) {
            Label("从相册选择图片", systemImage: "photo.on.rectangle")
        }

        if let photoLoadError {
            Text(photoLoadError)
                .font(.footnote)
                .foregroundStyle(.red)  // 用 .foregroundStyle,.foregroundColor 已弃用
        }

        if let selectedImage {
            selectedImage
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 220)
                // 用 clipShape + RoundedRectangle 做圆角,.cornerRadius 已弃用
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // 对整段文字设置加粗。AttributedString 支持用范围下标统一改属性,
    // 这里用 inlinePresentationIntent = .stronglyEmphasized 表达「加粗」语义,
    // 它比直接写死字号更语义化,能适配系统的动态字体。
    private func applyBoldToWholeText() {
        let fullRange = styledText.startIndex..<styledText.endIndex
        styledText[fullRange].inlinePresentationIntent = .stronglyEmphasized
    }

    // 异步加载选中图片的 Data。loadTransferable 是 async 且会 throw 的方法,
    // 必须放进 Task 并用 do/catch 包住,避免加载失败时崩溃或静默无反馈。
    private func loadImage(from item: PhotosPickerItem?) {
        // 用户取消选择时 item 为 nil,直接清空状态即可。
        guard let item else {
            selectedImage = nil
            return
        }

        Task {
            do {
                // 取出图片的原始二进制数据;返回可选值,nil 表示该项无法转成 Data。
                if let data = try await item.loadTransferable(type: Data.self) {
                    // UIImage 是把 Data 解码成图像的桥梁,再包成 SwiftUI 的 Image 展示。
                    if let uiImage = UIImage(data: data) {
                        selectedImage = Image(uiImage: uiImage)
                        note.imageData = data   // 立即写回模型,待保存时随笔记落盘
                        photoLoadError = nil
                    } else {
                        photoLoadError = "无法识别该图片格式,请换一张试试。"
                    }
                } else {
                    photoLoadError = "未能读取到图片数据。"
                }
            } catch {
                // 捕获真实错误并展示给用户,而不是吞掉,方便排查权限或读取问题。
                photoLoadError = "图片加载失败:\(error.localizedDescription)"
            }
        }
    }

    // 进入编辑页时,把已持久化的 imageData 还原为可展示的 Image。
    private func restoreExistingImage() {
        guard let data = note.imageData, let uiImage = UIImage(data: data) else { return }
        selectedImage = Image(uiImage: uiImage)
    }

    // 显式保存:更新时间戳并调用 save()。@Model 属性变更本会自动持久化,
    // 这里主动 save 是为了让「点保存即落盘」的行为对读者可预期、可验证。
    private func save() {
        note.updatedAt = .now
        try? modelContext.save()
    }
}

#Preview {
    // 预览用内存数据库(isStoredInMemoryOnly: true),不污染真实数据,
    // 每次预览都是干净环境,关闭后自动销毁。
    let container = try! ModelContainer(
        for: Note.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let sampleNote = Note(title: "示例笔记", content: "这是一段可以多行编辑的正文内容。")
    container.mainContext.insert(sampleNote)

    return NavigationStack {
        NoteEditView(note: sampleNote)
    }
    .modelContainer(container)
}