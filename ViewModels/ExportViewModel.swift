import SwiftUI

final class ExportViewModel: ObservableObject {
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage: String? = nil

    init() {}

    func composition(from design: Design) -> Composition {
        Composition(background: .asset(design.imageName), numerals: nil, hands: .classic)
    }

    @MainActor
    func save(design: Design, for model: WatchModel) async {
        // Сервис создаём тут, на MainActor — компилятор доволен
        let exporter = ExportService()

        let canvas = WatchCanvasView(composition: composition(from: design), animated: false)
        do {
            try await exporter.saveToPhotos(view: canvas, pixelSize: model.exportSizePx)
            alertTitle = "Готово"
            alertMessage = "Сохранено в Фото"
        } catch ExportError.noPermission {
            alertTitle = "Нет доступа"
            alertMessage = "Разрешите доступ к Фото, чтобы сохранять изображения."
        } catch {
            alertTitle = "Ошибка"
            alertMessage = "Не удалось сохранить изображение."
        }
        showAlert = true
    }
}

