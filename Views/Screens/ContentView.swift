import SwiftUI

struct ContentView: View {
    @State private var showRegistration = false
    @EnvironmentObject private var auth: AuthViewModel
    @EnvironmentObject private var themeViewModel: ThemeViewModel

    var body: some View {
        ZStack {
            // Фон
            Image("Waterwatch")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height)
                .clipped()
                .opacity(themeViewModel.currentTheme == .dark ? 0.5 : 1.0)
                .ignoresSafeArea()

            // Тонирующая подложка в тёмной теме
            Color(themeViewModel.currentTheme == .dark ? .black : .white)
                .opacity(themeViewModel.currentTheme == .dark ? 0.7 : 0.0)
                .ignoresSafeArea()

            // Контент: логин или основной таббар
            if auth.isLoggedIn {
                MainTabView(isLoggedIn: $auth.isLoggedIn)
            } else {
                loginView
            }
        }
        .sheet(isPresented: $showRegistration) {
            RegistrationView(auth: auth.authService)   // ← главное: передать AuthService
                .environmentObject(themeViewModel)
        }
        .preferredColorScheme(themeViewModel.currentTheme)
    }

    // MARK: - Login UI
    private var loginView: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer(minLength: 50)

                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 500, maxHeight: 400)
                    .shadow(radius: 5)

                // Ошибки
                if let error = auth.errorMessage, !error.isEmpty {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.bottom, 4)
                } else if auth.loginFailed {
                    Text("Неверный логин или пароль")
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.bottom, 4)
                }

                // Логин
                TextField("", text: $auth.username,
                          prompt: Text("Логин").foregroundColor(.gray))
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .keyboardType(.asciiCapable)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textContentType(.username)
                    .foregroundColor(.black)
                    .tint(.black)
                    .onChange(of: auth.username) { s in
                        auth.username = s.filter { $0.isASCII }
                    }

                // Пароль
                SecureField("", text: $auth.password,
                            prompt: Text("Пароль").foregroundColor(.gray))
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .keyboardType(.asciiCapable)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textContentType(.password)
                    .foregroundColor(.black)
                    .tint(.black)
                    .submitLabel(.go)
                    .onSubmit { auth.login() }

                // Запомнить меня
                Toggle("Запомнить меня", isOn: Binding(
                    get: { auth.rememberMe },
                    set: { auth.setRemember($0) }
                ))

                // Кнопки
                HStack(spacing: 15) {
                    Button("Войти") { auth.login() }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(auth.canSubmit ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(!auth.canSubmit)

                    Button("Регистрация") { showRegistration = true }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 12)

                if auth.isBusy {
                    ProgressView().padding(.top, 8)
                }

                Spacer(minLength: 50)
            }
            .padding(.horizontal, 20)
        }
    }
}

#if DEBUG
private struct PreviewAuthService: AuthService {
    func login(_ r: LoginRequest) async throws -> ProfileResponse {
        ProfileResponse(
            id: 1,
            username: r.emailOrUsername,
            email: "demo@ex.com",
            firstName: "Demo",
            lastName: "User",
            city: "Almaty",
            avatar: nil
        )
    }

    func register(_ r: RegisterRequest) async throws -> ProfileResponse {
        ProfileResponse(
            id: 2,
            username: r.username,
            email: r.email,
            firstName: "New",
            lastName: "User",
            city: nil,
            avatar: nil
        )
    }

    func logout() {}
}
#endif

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ThemeViewModel())
            .environmentObject(AuthViewModel.preview())
    }
}
