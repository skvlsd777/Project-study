import Foundation

struct RegisterRequest: Codable { let username, email, password: String }
struct LoginRequest: Codable { let emailOrUsername, password: String }

struct AuthResponse: Codable {
    let user: ProfileResponse
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
}

