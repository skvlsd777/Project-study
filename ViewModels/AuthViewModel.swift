import SwiftUI

final class AuthViewModel: ObservableObject {
    // Поля формы
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var error: String?
    @Published var isBusy: Bool = false
    @Published var loginFailed: Bool = false // оставил, если где-то используешь

    // Персистентные флаги
    @AppStorage(AppStorageKeys.isLoggedIn) var isLoggedIn: Bool = false
    @AppStorage(AppStorageKeys.rememberMe) var rememberMe: Bool = true

    private let auth: AuthService

    // По умолчанию — локальная реализация (Keychain + @AppStorage)
    init(auth: AuthService = LocalAuthService()) {
        self.auth = auth
        // Синхронизируем тумблер RememberMe с сервисом
        self.rememberMe = auth.rememberMe

        // Автовход, если в сервисе уже есть текущий пользователь
        if let u = auth.currentUser?.username {
            self.username = u
            self.isLoggedIn = true
        }
    }

    // MARK: - Actions

    func setRemember(_ value: Bool) {
        rememberMe = value
        // если реализация локальная — обновим её флаг
        if let local = auth as? LocalAuthService {
            local.rememberMe = value
        }
    }

    func login() {
        guard !username.isEmpty, !password.isEmpty else {
            error = "Введите логин и пароль"
            loginFailed = true
            return
        }
        isBusy = true
        switch auth.login(username: username, password: password) {
        case .success:
            error = nil
            loginFailed = false
            isLoggedIn = true
        case .failure(let e):
            error = e.localizedDescription
            loginFailed = true
        }
        isBusy = false
    }

    func register() {
        guard !username.isEmpty, !password.isEmpty else {
            error = "Заполните поля"
            loginFailed = true
            return
        }
        isBusy = true
        switch auth.register(username: username, password: password) {
        case .success:
            error = nil
            loginFailed = false
            isLoggedIn = true
        case .failure(let e):
            error = e.localizedDescription
            loginFailed = true
        }
        isBusy = false
    }

    func logout(router: RootRouter) {
        auth.logout()
        isLoggedIn = false
        // Очистим историю во всех вкладках, чтобы нельзя было «назад» в приватные экраны
        router.popToRoot(on: .designs)
        router.popToRoot(on: .advice)
        router.popToRoot(on: .settings)
        router.popToRoot(on: .profile)
        // Сбросим поля формы
        username = ""
        password = ""
        error = nil
        loginFailed = false
    }

    func resetLogin() {
        username = ""
        password = ""
        error = nil
        loginFailed = false
    }
}

