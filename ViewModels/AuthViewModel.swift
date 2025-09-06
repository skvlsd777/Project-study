import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var loginFailed: Bool = false
    @Published var username: String = ""
    @Published var password: String = ""
    
    private let validUsername = "admin"
    private let validPassword = "password"
    
    // Метод для проверки логина
    func login() {
        if username == validUsername && password == validPassword {
            withAnimation {
                isLoggedIn = true
                loginFailed = false
            }
        } else {
            loginFailed = true
        }
    }
    
    // Метод для сброса данных после неудачного входа
    func resetLogin() {
        username = ""
        password = ""
        loginFailed = false
    }
}
