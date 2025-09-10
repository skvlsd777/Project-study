import UserNotifications
import UIKit

enum NotificationManager {
    static let dailyId = "daily_watch_face_reminder"

    /// Разрешение на уведомления (просим один раз)
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

    /// Запланировать ежедневное уведомление на 09:00
    static func scheduleDaily(at hour: Int = 9, minute: Int = 0) async throws {
        // уберём дубликаты
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [dailyId])

        let content = UNMutableNotificationContent()
        content.title = "Напоминание"
        content.body  = "Поставьте новый циферблат!"
        content.sound = .default

        var comps = DateComponents()
        comps.hour = hour
        comps.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        let request = UNNotificationRequest(identifier: dailyId, content: content, trigger: trigger)
        try await UNUserNotificationCenter.current().add(request)
    }

    /// Отменить ежедневное уведомление
    static func cancelDaily() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [dailyId])
    }

    /// Синхронизировать состояние при старте приложения
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

    /// Открыть системные настройки приложения (если юзер запретил уведомления)
    static func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}
