import SwiftUI
import UserNotifications

@main
struct Project_studyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var themeVM = ThemeViewModel()
    // если у тебя где-то хранится isNotificationsEnabled — подставь его ниже в .onAppear

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeVM)
                .onAppear {
                    // при старте подтянем сохранённый флаг и синхронизируем планирование
                    let enabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
                    NotificationManager.sync(enabled: enabled)
                }
        }
    }
}

