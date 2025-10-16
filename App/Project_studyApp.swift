import SwiftUI
import UserNotifications

@main
struct Project_studyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            AppRoot()
                .onAppear {
                    let enabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
                    NotificationManager.sync(enabled: enabled)
                }
        }
    }
}

