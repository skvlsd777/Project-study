import SwiftUI

final class ExportViewModel: ObservableObject {
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage: String? = nil

    init() {}

    // Локальные дизайны (оставь, если нужно)
    func composition(from design: Design) -> Composition {
        Composition(background: .asset(design.imageName),
                    numerals: nil,
                    hands: .classic)
    }

    @MainActor
    func save(design: Design, for model: WatchModel) async {
        let exporter = ExportService()
        let canvas = WatchCanvasView(composition: composition(from: design),
                                     animated: false)
        do {
            try await exporter.saveToPhotos(view: canvas, pixelSize: model.exportSizePx)
            alertTitle = "Готово"
            alertMessage = "Сохранено в Фото"
        } catch ExportError.noPermission {
            alertTitle = "Нет доступа"
            alertMessage = "Разрешите доступ к Фото, чтобы сохранить изображение."
        } catch {
            alertTitle = "Ошибка"
            alertMessage = "Не удалось сохранить изображение."
        }
        showAlert = true
    }

    // 🔹 Сохранение удалённого дизайна из GitHub Pages
    @MainActor
    func save(remote item: RemoteDesignItem, for model: WatchModel) async {
        // Берём full-картинку из CDN (полноразмерную)
        let comp = Composition(
            background: .url(CDN.url(for: item.full)),
            numerals: nil,
            hands: .classic
        )
        let exporter = ExportService()
        let canvas = WatchCanvasView(composition: comp, animated: false)

        do {
            try await exporter.saveToPhotos(view: canvas, pixelSize: model.exportSizePx)
            alertTitle = "Готово"
            alertMessage = "Сохранено в Фото"
        } catch ExportError.noPermission {
            alertTitle = "Нет доступа"
            alertMessage = "Разрешите доступ к Фото, чтобы сохранить изображение."
        } catch {
            alertTitle = "Ошибка"
            alertMessage = "Не удалось сохранить изображение."
        }
        showAlert = true
    }
}


