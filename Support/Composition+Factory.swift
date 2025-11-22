import SwiftUI

extension Composition {
    /// Строим композицию по твоему Design.imageName:
    /// - абсолютный URL -> .url
    /// - относительный путь (с "/") -> .url(CDN.url(for:))
    /// - иначе -> .asset
    static func from(design: Design) -> Composition {
        let name = design.imageName
        let background: Background

        if let u = URL(string: name), u.scheme != nil {
            background = .url(u)                          // полный URL
        } else if name.contains("/") {
            background = .url(CDN.url(for: name))         // относительный путь к GitHub Pages
        } else {
            background = .asset(name)                     // локальный ассет
        }

        return Composition(background: background,
                           numerals: nil,
                           hands: .classic)
    }
}

