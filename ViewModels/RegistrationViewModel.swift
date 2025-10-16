import SwiftUI

@MainActor
final class RegistrationViewModel: ObservableObject {
    @Published var username = ""
    @Published var email    = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isBusy = false

    /// Коллбек — что делать после успешной регистрации (например, закрыть экран)
    var onSuccess: (() -> Void)?

    /// Удобный флаг для кнопки
    var canSubmit: Bool { !username.isEmpty && !email.isEmpty && !password.isEmpty && !isBusy }

    private let auth: AuthService

    init(auth: AuthService) { self.auth = auth }

    func register() {
        let u = username.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let e = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let p = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !u.isEmpty, !e.isEmpty, !p.isEmpty else {
            errorMessage = "Заполните все поля"; return
        }

        Task {
            isBusy = true; defer { isBusy = false }
            do {
                let req = RegisterRequest(username: u, email: e, password: p)
                _ = try await auth.register(req)
                errorMessage = nil
                onSuccess?()                  // <- сообщаем наверх об успехе
            } catch let er as ErrorResponse {
                errorMessage = er.message
            } catch {
                errorMessage = "Ошибка регистрации"
            }
        }
    }
}

