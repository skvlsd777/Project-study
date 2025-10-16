#if DEBUG
import Foundation

extension AuthViewModel {
    static func preview() -> AuthViewModel {
        AuthViewModel(auth: PreviewDI.authService)
    }
}
#endif

