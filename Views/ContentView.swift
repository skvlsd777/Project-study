import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AuthViewModel()
    @EnvironmentObject private var themeViewModel: ThemeViewModel

    var body: some View {
        ZStack {
            Image("Waterwatch")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height)
                .clipped()
                .opacity(themeViewModel.currentTheme == .dark ? 0.5 : 1.0)
                .ignoresSafeArea()

            Color(themeViewModel.currentTheme == .dark ? .black : .white)
                .opacity(themeViewModel.currentTheme == .dark ? 0.7 : 0.0)
                .ignoresSafeArea()

            if viewModel.isLoggedIn {
                MainTabView(isLoggedIn: $viewModel.isLoggedIn)
                    .environmentObject(themeViewModel)
            } else {
                loginView
            }
        }
        .preferredColorScheme(themeViewModel.currentTheme)
    }

    var loginView: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer(minLength: 50)

                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 500, maxHeight: 400)
                    .shadow(radius: 5)

                if viewModel.loginFailed {
                    Text("Неверный логин или пароль")
                        .foregroundColor(.red)
                        .padding(.bottom, 10)
                }

                TextField("Логин", text: $viewModel.username)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .keyboardType(.asciiCapable)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textContentType(.username)
                    .onChange(of: viewModel.username) { s in
                        viewModel.username = s.filter { $0.isASCII }
                    }

                SecureField("Пароль", text: $viewModel.password)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .keyboardType(.asciiCapable)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textContentType(.password)
                    .submitLabel(.go)

                HStack(spacing: 15) {
                    Button("Войти") {
                        viewModel.login()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Button("Регистрация") {
                        print("Открыть экран регистрации")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.top, 20)

                Spacer(minLength: 50)
            }
            .padding(.horizontal, 20)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ThemeViewModel())
    }
}


