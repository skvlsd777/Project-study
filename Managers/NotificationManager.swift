import UserNotifications
import UIKit

enum NotificationManager {
    static let dailyId = "daily_watch_face_reminder"

    // Текущий системный статус разрешений
    static func authorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }

    // Просим разрешение при необходимости (повторно не тревожим)
    static func requestAuthorizationIfNeeded(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional, .ephemeral:
                completion(true)
            case .denied:
                completion(false)
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                    completion(granted)
                }
            @unknown default:
                completion(false)
            }
        }
    }

    // Планируем ежедневное уведомление на 09:00 (локальное время)
    static func scheduleDaily(at hour: Int = 9, minute: Int = 0) async throws {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [dailyId])

        let content = UNMutableNotificationContent()
        content.title = "Напоминание"
        content.body  = "Поставьте новый циферблат!"
        content.sound = .default

        var comps = DateComponents()
        comps.hour = hour
        comps.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        let req = UNNotificationRequest(identifier: dailyId, content: content, trigger: trigger)
        try await center.add(req)
    }

    // Отменяем ежедневное уведомление
    static func cancelDaily() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [dailyId])
    }

    // Синхронизация при старте приложения/возврате из настроек
    static func sync(enabled: Bool, hour: Int = 9, minute: Int = 0) {
        if enabled {
            requestAuthorizationIfNeeded { granted in
                guard granted else { return }
                Task { try? await scheduleDaily(at: hour, minute: minute) }
            }
        } else {
            cancelDaily()
        }
    }

    // Открыть системные настройки приложения (если доступ запрещён)
    static func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}

#if DEBUG
extension NotificationManager {
    static func scheduleTest(after seconds: Int = 10) {
        requestAuthorizationIfNeeded { granted in
            guard granted else { return }

            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: ["test_watch_face"])

            let content = UNMutableNotificationContent()
            content.title = "Тест"
            content.body  = "Это тест: баннер через \(seconds) сек."
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)
            let req = UNNotificationRequest(identifier: "test_watch_face", content: content, trigger: trigger)
            center.add(req, withCompletionHandler: nil)
        }
    }
}
#endif

