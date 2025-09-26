import SwiftUI

@MainActor
final class AuthViewModel: ObservableObject {
    // MARK: - Form state (ввод пользователя)
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var error: String?
    @Published var isBusy: Bool = false
    @Published var loginFailed: Bool = false
    
    // MARK: - Persistent UI flags (@AppStorage = локальная память устройства)
    @AppStorage(AppStorageKeys.isLoggedIn) var isLoggedIn: Bool = false
    @AppStorage(AppStorageKeys.rememberMe) var rememberMe: Bool = true
    
    // MARK: - Dependencies
    private let auth: AuthService
    
    // Удобно иметь вычисляемый флаг для кнопки "Войти"
    var canSubmit: Bool { !username.isEmpty && !password.isEmpty && !isBusy }
    
    // MARK: - Init
    /// По умолчанию используем локальную реализацию авторизации (Keychain + @AppStorage)
    init(auth: AuthService = LocalAuthService()) {
        self.auth = auth
        
        // Синхронизируем тумблер "Запомнить меня" с сервисом (единая точка правды)
        self.rememberMe = auth.rememberMe
        
        // Автовход: если сервис уже знает текущего пользователя — сразу в приложение
        if let u = auth.currentUser?.username {
            self.username = u
            self.isLoggedIn = true
        }
    }
    
    // MARK: - Private
    private func normalizedUsername() -> String {
        // Приводим к единому виду (без пробелов по краям, нижний регистр)
        username.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
    
    // MARK: - Actions
    func setRemember(_ value: Bool) {
        // Держим флаг и в VM (@AppStorage), и в сервисе (через протокол)
        rememberMe = value
        auth.rememberMe = value
    }
    
    func login() {
        let u = normalizedUsername()
        guard !u.isEmpty, !password.isEmpty else {
            error = "Введите логин и пароль"
            loginFailed = true
            return
        }
        
        isBusy = true
        defer { isBusy = false }
        
        switch auth.login(username: u, password: password) {
        case .success:
            // Успех: чистим ошибки, отмечаем, что вошли, чистим пароль из памяти
            error = nil
            loginFailed = false
            isLoggedIn = true
            username = u
            password = ""
        case .failure(let e):
            error = e.localizedDescription
            loginFailed = true
        }
    }
    
    func register() {
        let u = normalizedUsername()
        guard !u.isEmpty, !password.isEmpty else {
            error = "Заполните поля"
            loginFailed = true
            return
        }
        
        isBusy = true
        defer { isBusy = false }
        
        switch auth.register(username: u, password: password) {
        case .success:
            error = nil
            loginFailed = false
            isLoggedIn = true
            username = u
            password = ""
        case .failure(let e):
            error = e.localizedDescription
            loginFailed = true
        }
    }
    
    func logout(router: RootRouter) {
        auth.logout()
        isLoggedIn = false
        
        // Чистим стек навигации, чтобы нельзя было "вернуться" в приватные экраны
        router.popToRoot(on: .designs)
        router.popToRoot()
    }
}
