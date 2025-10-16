import SwiftUI

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var errorMessage: String?   // ← было `error`
    @Published var isBusy = false
    @Published var loginFailed = false
    @AppStorage(AppStorageKeys.isLoggedIn) var isLoggedIn = false
    @AppStorage(AppStorageKeys.rememberMe) var rememberMe = true

    private let auth: AuthService
    var authService: AuthService { auth }
    var canSubmit: Bool { !username.isEmpty && !password.isEmpty && !isBusy }

    init(auth: AuthService) { self.auth = auth }

    func setRemember(_ value: Bool) { rememberMe = value }

    func login() {
        let u = username.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !u.isEmpty, !password.isEmpty else {
            self.errorMessage = "Введите логин и пароль"
            self.loginFailed = true
            return
        }
        Task {
            self.isBusy = true
            defer { self.isBusy = false }
            do {
                let req = LoginRequest(emailOrUsername: u, password: self.password)
                _ = try await auth.login(req)
                self.errorMessage = nil
                self.loginFailed = false
                self.isLoggedIn = true
                self.username = u
                self.password = ""
            } catch let e as ErrorResponse {
                self.errorMessage = e.message
                self.loginFailed = true
            } catch {
                self.errorMessage = "Ошибка входа"
                self.loginFailed = true
            }
        }
    }

    func register(username: String, email: String, password: String) {
        let u = username.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let p = password.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !u.isEmpty, !p.isEmpty, !email.isEmpty else {
            self.errorMessage = "Заполните все поля"
            self.loginFailed = true
            return
        }
        Task {
            self.isBusy = true
            defer { self.isBusy = false }
            do {
                let req = RegisterRequest(username: u, email: email, password: p)
                _ = try await auth.register(req)
                self.errorMessage = nil
                self.loginFailed = false
                self.isLoggedIn = true
                self.username = u
                self.password = ""
            } catch let e as ErrorResponse {
                self.errorMessage = e.message
                self.loginFailed = true
            } catch {
                self.errorMessage = "Ошибка регистрации"
                self.loginFailed = true
            }
        }
    }
}
