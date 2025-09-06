import SwiftUI

class AdviceViewModel: ObservableObject {
    @Published var adviceItems: [AdviceItem] = []

    // Массив всех доступных советов
    init() {
        loadAdviceItems()
    }
    
    func loadAdviceItems() {
        // Здесь ты можешь добавить логику для загрузки данных, например, из API или локального хранилища
        adviceItems = [
            AdviceItem(title: "Что нового в watchOS ?", description: "Описание изменений в watchOS 8 и новшества", imageName: "watchOSNew", iconName: "clock.fill"),
            AdviceItem(title: "Встречайте лучшее приложение AppleWatch Wallpaper!", description: "Как приложение AppleWatch Wallpaper помогает вам персонализировать свои часы", imageName: "AppleWatchWallpaper", iconName: "photo.fill"),
            AdviceItem(title: "Персонализируйте свои часы", description: "Как изменить обои и стиль интерфейса на вашем Apple Watch", imageName: "CustomizeWatch", iconName: "paintbrush.fill"),
            AdviceItem(title: "Просмотр полезных приложений", description: "Какие приложения действительно полезны для пользователей Apple Watch", imageName: "UsefulApps", iconName: "app.fill")
        ]
    }
}
