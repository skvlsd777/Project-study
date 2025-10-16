import Foundation

struct ProfileResponse: Codable, Equatable {
    let id: Int
    let username: String
    let email: String
    let firstName: String?
    let lastName: String?
    let city: String?
    let avatar: String?
}

struct ProfileUpdateRequest: Codable {
    var username: String?
    var firstName: String?
    var lastName: String?
    var city: String?
}

struct ErrorResponse: Codable, Error {
    let message: String
    let code: String?
}

