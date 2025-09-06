import SwiftUI

struct Design: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let imageName: String
    let style: String // Стиль дизайна (например, "Минимализм")
    let wallpapers: [Wallpaper] // Массив обоев для этого стиля
}
