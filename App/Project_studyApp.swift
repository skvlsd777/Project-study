import SwiftUI
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // Показ в форграунде как баннер + звук
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}

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

