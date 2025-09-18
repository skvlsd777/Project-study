import SwiftUI
import UserNotifications

@main
struct Project_studyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var themeVM = ThemeViewModel()
    @StateObject var router  = RootRouter()
    @StateObject var authVM = AuthViewModel()


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeVM)
                .environmentObject(router)
                .environmentObject(authVM)
                .onAppear {
                    let enabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
                    NotificationManager.sync(enabled: enabled)
                }
        }
    }
}

