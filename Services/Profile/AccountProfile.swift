import Foundation

struct AccountProfile: Codable, Equatable {
    var username: String
    var email: String
    var firstName: String?
    var lastName: String?
    var city: String?
    // позже добавишь avatarData и пр.
}
