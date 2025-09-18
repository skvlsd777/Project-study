import SwiftUI

struct ProfileTabContainer: View {
    @Binding var isLoggedIn: Bool

    @EnvironmentObject var themeVM: ThemeViewModel
    @EnvironmentObject var router: RootRouter
    @EnvironmentObject var auth: AuthViewModel

    @StateObject private var profileVM = ProfileViewModel()

    var body: some View {
        ProfileView(isLoggedIn: $isLoggedIn)
            .environmentObject(themeVM)
            .environmentObject(profileVM)
            .onAppear {
                // Подхватываем профиль текущего пользователя
                profileVM.load(for: auth.username.lowercased())
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .profileEdit:
                    ProfileEditView()
                        .environmentObject(themeVM)
                        .environmentObject(profileVM)
                default:
                    EmptyView()
                }
            }
    }
}

