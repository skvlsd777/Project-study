import Foundation

struct AccountProfile: Codable, Equatable {
    var id: Int
    var username: String
    var password: String?
    var email: String
    var firstName: String?
    var lastName: String?
    var city: String?
    var avatar: String?
}
