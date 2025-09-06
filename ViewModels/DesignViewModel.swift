import SwiftUI

class DesignViewModel: ObservableObject {
    // Массив дизайнов
    @Published var designs: [Design] = [
        Design(name: "Минимализм", imageName: "MinimalizmDesign", style: "Minimal", wallpapers: []),
        Design(name: "Классика", imageName: "ClassicDesign", style: "Classic", wallpapers: []),
        Design(name: "Кастом", imageName: "CustomDesign", style: "Кастом", wallpapers: []),
        Design(name: "Мировые бренды", imageName: "WorldBrandsDesign", style: "Мировые бренды", wallpapers: [
            Wallpaper(name: "Обои 1", imageName: "WorldBrandsWallpaper1"),
            Wallpaper(name: "Обои 2", imageName: "WorldBrandsWallpaper2")
        ]),
        Design(name: "Спортивные", imageName: "SportDesign", style: "Спортивные", wallpapers: [
            Wallpaper(name: "Обои 1", imageName: "WorldBrandsWallpaper1"),
            Wallpaper(name: "Обои 2", imageName: "WorldBrandsWallpaper2")
        ])
    ] // <- закрываем массив полностью
    
    // Функции для добавления/удаления дизайнов
    func addDesign(_ design: Design) {
        designs.append(design)
    }
    
    func removeDesign(at index: Int) {
        designs.remove(at: index)
    }
}
