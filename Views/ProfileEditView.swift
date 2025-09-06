import SwiftUI

struct ProfileEditView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @EnvironmentObject var themeViewModel: ThemeViewModel

    @State private var username: String
    @State private var email: String
    @State private var city: String

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        _username = State(initialValue: viewModel.userProfile.username)
        _email = State(initialValue: viewModel.userProfile.email)
        _city = State(initialValue: viewModel.userProfile.city)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Редактирование профиля")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            TextField("Имя", text: $username)
                .padding()
                .background(themeViewModel.currentTheme == .dark ? Color.gray.opacity(0.5) : Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            TextField("Email", text: $email)
                .padding()
                .background(themeViewModel.currentTheme == .dark ? Color.gray.opacity(0.5) : Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            TextField("Город", text: $city)
                .padding()
                .background(themeViewModel.currentTheme == .dark ? Color.gray.opacity(0.5) : Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            Button(action: {
                viewModel.updateProfile(name: username, email: email, city: city)
            }) {
                Text("Сохранить")
                    .font(.title3)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .padding()
        .background(themeViewModel.currentTheme == .dark ? Color.black : Color.white)
    }
}

struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView(viewModel: ProfileViewModel())
            .environmentObject(ThemeViewModel())
    }
}
