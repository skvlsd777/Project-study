import SwiftUI

class ThemeViewModel: ObservableObject {
    // @AppStorage автоматически хранит данные и уведомляет SwiftUI
    @AppStorage("isDarkMode") var isDarkMode: Bool = false

    // Текущая тема
    var currentTheme: ColorScheme {
        isDarkMode ? .dark : .light
    }

    // Переключение темы
    func toggleTheme() {
        isDarkMode.toggle() // Это автоматически обновляет AppStorage и уведомляет UI
    }
}

