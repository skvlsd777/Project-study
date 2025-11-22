import Foundation

enum CDN {
    static let base = URL(string: "https://skvlsd777.github.io/watch-assets/")!

    static func url(for relativePath: String) -> URL {
        let clean = relativePath.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        return URL(string: clean, relativeTo: base)!.absoluteURL
    }
}

func composition(from design: Design) -> Composition {
    let bg: Background
    if design.imageName.contains("/") {
        bg = .url(CDN.url(for: design.imageName))      // "minimalizm/thumbs/m1.jpg"
    } else if let u = URL(string: design.imageName), u.scheme != nil {
        bg = .url(u)                                    // полный URL, если вдруг передали
    } else {
        bg = .asset(design.imageName)                   // локальный ассет
    }
    return Composition(background: bg, numerals: nil, hands: .classic)
}
