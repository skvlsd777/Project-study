import SwiftUI

final class ExportViewModel: ObservableObject {
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage: String? = nil

    init() {}

    // MARK: - Локальные дизайны (экран с ассетами / старый список)

    @MainActor
    func save(design: Design, for model: WatchModel) async {
        // Используем фабрику, которая сама решает: asset / относительный путь / полный URL
        let composition = Composition.from(design: design)

        let exporter = ExportService()
        let canvas = WatchCanvasView(
            composition: composition,
            animated: false
        )

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

    // MARK: - Удалённые дизайны с GitHub Pages (m1, m2 и т.п.)

    @MainActor
    func save(remote item: RemoteDesignItem, for model: WatchModel) async {
        let comp = Composition(
            background: .url(CDN.url(for: item.full)),
            numerals: nil,
            hands: .classic
        )

        let exporter = ExportService()
        let canvas = WatchCanvasView(
            composition: comp,
            animated: false
        )

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

