import SwiftUI

struct WatchModel: Identifiable, Hashable {
    let id = UUID()
    let name: String                 // что видит пользователь
    let overlayImageName: String     // имя PNG корпуса в Assets
    let overlayAspect: CGFloat       // width/height PNG корпуса
    let unitRect: CGRect             // окно экрана в долях [0...1]
    let cornerRadiusRatio: CGFloat   // скругление экрана (доля от min(w,h))
    let exportSizePx: CGSize         // рекомендуемый размер экспорта

    func screenRect(in size: CGSize) -> CGRect {
        CGRect(x: unitRect.origin.x * size.width,
               y: unitRect.origin.y * size.height,
               width:  unitRect.size.width  * size.width,
               height: unitRect.size.height * size.height)
    }

    func cornerRadius(for rect: CGRect) -> CGFloat {
        min(rect.width, rect.height) * cornerRadiusRatio
    }
}

extension WatchModel {
    /// Крошечный inset для капризных корпусов (0…0.01 = 0…1%)
    var safetyInsetPercent: CGFloat {
        switch overlayImageName {
        case "Applewatch-ultra2": return 0.010   // Ultra 2 / 3
        case "Applewatchultra":   return 0.010   // Ultra 1
        case "Applewatch45m":     return 0.003   // 45 мм
        default:                  return 0.0     // остальные — без поджима
        }
    }
}

enum WatchCatalog {
    static let series_41 = WatchModel(
        name: "Apple Watch 41 мм",
        overlayImageName: "Applewatch41",
        overlayAspect: 480.0/760.0,
        unitRect: CGRect(x: 0.129, y: 0.206, width: 0.764, height: 0.580),
        cornerRadiusRatio: 0.11,
        exportSizePx: CGSize(width: 352, height: 430)
    )

    static let series_45 = WatchModel(
        name: "Apple Watch 45 мм",
        overlayImageName: "Applewatch45m",
        overlayAspect: 540.0/860.0,
        unitRect: CGRect(x: 0.090, y: 0.206, width: 0.815, height: 0.568),
        cornerRadiusRatio: 0.135,
        exportSizePx: CGSize(width: 396, height: 484)
    )

    static let ultra = WatchModel(
        name: "Apple Watch Ultra",
        overlayImageName: "Applewatchultra",
        overlayAspect: 600.0/940.0,
        unitRect: CGRect(x: 0.060, y: 0.206, width: 0.815, height: 0.568),
        cornerRadiusRatio: 0.095,
        exportSizePx: CGSize(width: 410, height: 502)
    )

    static let ultra2 = WatchModel(
        name: "Apple Watch Ultra 2",
        overlayImageName: "Applewatch-ultra2",
        overlayAspect: 800.0/1309.0,
        unitRect: CGRect(x: 0.070, y: 0.206, width: 0.815, height: 0.568),
        cornerRadiusRatio: 0.095,
        exportSizePx: CGSize(width: 410, height: 502)
    )

    static let all: [WatchModel] = [series_41, series_45, ultra, ultra2]

    static func model(for selected: String) -> WatchModel {
        let s = selected.lowercased()
        if s.contains("ultra 3") { return ultra2 }
        if s.contains("ultra 2") { return ultra2 }
        if s.contains("ultra")   { return ultra }
        if s.contains("series 10") { return series_45 }
        if s.contains("series 9")  { return series_45 }
        if s.contains("series 8")  { return series_45 }
        if s.contains("series 7")  { return series_45 }
        if s.contains("series 6")  { return series_45 }
        if s.contains("series 5")  { return series_45 }
        if s.contains("series 4")  { return series_45 }
        if s.contains("series 3")  { return series_41 }
        if s.contains("series 2")  { return series_41 }
        if s.contains("series 1")  { return series_41 }
        if s.contains("1st")       { return series_41 }
        return series_45
    }
}

