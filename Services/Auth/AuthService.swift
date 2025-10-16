import Foundation

struct AuthAccount: Equatable, Hashable {
    let username: String
}

enum AuthError: Error, LocalizedError, Equatable {
    case userExists, userNotFound, badCredentials, storageFailure
    var errorDescription: String? {
        switch self {
        case .userExists:     return "Пользователь уже существует"
        case .userNotFound:   return "Пользователь не найден"
        case .badCredentials: return "Неверный логин или пароль"
        case .storageFailure: return "Ошибка хранилища"
        }
    }
}
