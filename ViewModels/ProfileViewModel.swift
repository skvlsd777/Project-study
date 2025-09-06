import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var userProfile = UserProfile(
        username: "Владислав Скулкин",
        email: "skvlsd777@gmail.com",
        city: "Алматы, Казахстан"
    )
    
    func updateProfile(name: String, email: String, city: String) {
        self.userProfile = UserProfile(username: name, email: email, city: city)
    }
}

