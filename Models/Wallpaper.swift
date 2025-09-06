import SwiftUI

struct Wallpaper: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let imageName: String
}
