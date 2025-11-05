import SwiftUI

struct WatchPreview<Content: View>: View {
    // Базовые свойства
    let model: WatchModel
    let userImage: UIImage?
    let placeholder: Color

    // Необязательный контент-холст (если используем @ViewBuilder-инициализатор)
    private let contentBuilder: (() -> Content)?

    // Инициализация через SwiftUI-контент (наш WatchCanvasView и т.п.)
    init(
        model: WatchModel,
        placeholder: Color = .gray.opacity(0.1),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.userImage = nil
        self.placeholder = placeholder
        self.contentBuilder = content
    }

    var body: some View {
        GeometryReader { geo in
            let base   = model.screenRect(in: geo.size)
            let screen = base.insetBy(dx: base.width  * model.safetyInsetPercent,
                                      dy: base.height * model.safetyInsetPercent)
            let corner = model.cornerRadius(for: screen)

            ZStack {
                Group {
                    if let contentBuilder {
                        contentBuilder()
                            .frame(width: screen.width, height: screen.height)
                    } else if let img = userImage {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(width: screen.width, height: screen.height)
                    } else {
                        placeholder
                    }
                }
                .mask(RoundedRectangle(cornerRadius: corner, style: .continuous))
                .position(x: screen.midX, y: screen.midY)

                Image(model.overlayImageName)
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .aspectRatio(model.overlayAspect, contentMode: .fit)
    }
}

// Конструктор «как раньше» — когда даём UIImage.
// Ограничиваем инициализатор: он доступен только если Content == EmptyView.
// Благодаря этому вызов без content автоматически выводит Content = EmptyView.
extension WatchPreview where Content == EmptyView {
    init(
        model: WatchModel,
        userImage: UIImage?,
        placeholder: Color = .gray.opacity(0.1)
    ) {
        self.model = model
        self.userImage = userImage
        self.placeholder = placeholder
        self.contentBuilder = nil
    }
}


