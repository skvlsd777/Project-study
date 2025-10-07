import SwiftUI

class SettingsViewModel: ObservableObject {
    @AppStorage("isDarkMode") private var isDarkMode = false // Сохранение состояния темной темы в UserDefaults
    @Published var settings: Settings
    let appleWatchModels = [
        "Apple Watch (1st generation)",
        "Apple Watch Series 1",
        "Apple Watch Series 2",
        "Apple Watch Series 3",
        "Apple Watch Series 4",
        "Apple Watch Series 5",
        "Apple Watch Series 6",
        "Apple Watch SE (1st generation)",
        "Apple Watch Series 7",
        "Apple Watch Series 8",
        "Apple Watch SE (2nd generation)",
        "Apple Watch Ultra",
        "Apple Watch Series 9",
        "Apple Watch Ultra 2",
        "Apple Watch Ultra 3",
        "Apple Watch Series 10 (X)"
    ]
    
    init(settings: Settings = Settings(selectedDevice: "Apple Watch Series 8", isDarkMode: false, notificationsEnabled: true)) {
        self.settings = settings
    }
    
    // Переключить тему
    func toggleTheme() {
        isDarkMode.toggle()
        settings.isDarkMode = isDarkMode
    }
    
    // Переключить уведомления
    func toggleNotifications() {
        settings.notificationsEnabled.toggle()
    }
    
    // Выбрать модель Apple Watch
    func selectDevice(_ device: String) {
        settings.selectedDevice = device
    }
}
