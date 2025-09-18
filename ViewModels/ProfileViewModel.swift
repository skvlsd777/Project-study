import Foundation

final class ProfileViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var city: String = ""   // раз у тебя есть город

    private let store = ProfileStore()

    func load(for username: String) {
        self.username = username
        if let p = store.loadProfile(username: username) {
            email     = p.email
            firstName = p.firstName ?? ""
            lastName  = p.lastName  ?? ""
            city      = p.city ?? ""
        } else {
            email = ""; firstName = ""; lastName = ""; city = ""
        }
    }

    func saveProfile(email: String, firstName: String, lastName: String, city: String) {
        var profile = store.loadProfile(username: username) ??
                      AccountProfile(username: username, email: email, firstName: nil, lastName: nil, city: nil)
        profile.email = email
        profile.firstName = firstName.isEmpty ? nil : firstName
        profile.lastName  = lastName.isEmpty  ? nil : lastName
        profile.city      = city.isEmpty      ? nil : city
        _ = store.updateProfile(profile)
        // обновим локальные published
        self.email = email; self.firstName = firstName; self.lastName = lastName; self.city = city
    }
}

