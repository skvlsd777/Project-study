import SwiftUI

struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @EnvironmentObject var router: RootRouter
    @EnvironmentObject var auth: AuthViewModel
    @EnvironmentObject var viewModel: ProfileViewModel

    @State private var showAlert = false

    var body: some View {
        ZStack {
            (themeViewModel.currentTheme == .dark ? Color.black : Color.white).ignoresSafeArea()

            VStack(spacing: 20) {

                // Аватар + данные
                HStack(spacing: 20) {
                    Image("AvatarProfile")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(viewModel.username)
                            .font(.title).bold()
                            .foregroundColor(themeViewModel.currentTheme == .dark ? .white : .black)

                        Text(viewModel.email)
                            .font(.subheadline)
                            .foregroundColor(themeViewModel.currentTheme == .dark ? .white : .gray)

                        if !viewModel.city.isEmpty {
                            Text(viewModel.city)
                                .font(.subheadline)
                                .foregroundColor(themeViewModel.currentTheme == .dark ? .white : .gray)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 15) {
                    Button {
                        router.push(.profileEdit)
                    } label: {
                        Text("Редактировать профиль")
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(
                                gradient: Gradient(colors: [.blue, .purple]),
                                startPoint: .topLeading, endPoint: .bottomTrailing))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Spacer()

                    Button {
                        showAlert = true
                    } label: {
                        Text("Выйти")
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 20)
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Выход"),
                    message: Text("Вы уверены, что хотите выйти?"),
                    primaryButton: .destructive(Text("Да")) {
                        auth.logout(router: router)
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .navigationTitle("Профиль")
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isLoggedIn: .constant(true))
            .environmentObject(ThemeViewModel())
    }
}


