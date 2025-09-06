import SwiftUI

@main
struct Project_studyApp: App {
    @StateObject private var themeViewModel = ThemeViewModel() // Создаем ViewModel для управления темой
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(themeViewModel.currentTheme) // Применяем тему через ViewModel
                .environmentObject(themeViewModel) // Передаем ViewModel во все представления
        }
    }
}
