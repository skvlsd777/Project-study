import Foundation
import Combine

final class RegistrationViewModel: ObservableObject {
    // Ввод
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var email: String = ""

    // Состояния
    @Published var error: String?
    @Published var isBusy: Bool = false

    // Зависимости
    private let auth: AuthService
    private let profiles: ProfileStore

    /// Вызовется при успешной регистрации — вью закроет модалку
    var onSuccess: (() -> Void)?

    init(auth: AuthService = LocalAuthService(),
         profiles: ProfileStore = ProfileStore()) {
        self.auth = auth
        self.profiles = profiles
    }

    // Простая валидация (можно ужесточить позже)
    var canSubmit: Bool {
        let u = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let e = email.trimmingCharacters(in: .whitespacesAndNewlines)
        return u.count >= 3
        && password.count >= 6
        && e.contains("@")
        && e.contains(".")
    }

    func register() {
        error = nil
        guard canSubmit else {
            error = "Проверьте корректность полей"
            return
        }

        isBusy = true
        // нормализуем
        let u = username.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let e = email.trimmingCharacters(in: .whitespacesAndNewlines)

        switch auth.register(username: u, password: password) {
        case .success:
            _ = profiles.createProfile(username: u, email: e)
            isBusy = false
            onSuccess?()   // закрыть модалку
        case .failure(let err):
            error = err.localizedDescription
            isBusy = false
        }
    }
}
