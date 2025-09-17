import SwiftUI
import UserNotifications

@main
struct Project_studyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var themeVM = ThemeViewModel()
    @StateObject var router  = RootRouter()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeVM)
                .environmentObject(router)   // ← добавили
                .onAppear {
                    let enabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
                    NotificationManager.sync(enabled: enabled)
                }
        }
    }
}

