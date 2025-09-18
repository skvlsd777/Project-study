import SwiftUI

struct ContentView: View {
    @State private var showRegistration = false
    @EnvironmentObject private var auth: AuthViewModel
    @EnvironmentObject private var themeViewModel: ThemeViewModel
    
    private var canLogin: Bool {
        !auth.username.isEmpty && !auth.password.isEmpty && !auth.isBusy
    }
    
    
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
            
            if auth.isLoggedIn {
                MainTabView(isLoggedIn: $auth.isLoggedIn)
            } else {
                loginView
            }
        }
        .sheet(isPresented: $showRegistration) {
            RegistrationView()
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
                
                if let error = auth.error, !error.isEmpty {
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
                
                TextField("Логин", text: $auth.username)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .keyboardType(.asciiCapable)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textContentType(.username)
                    .onChange(of: auth.username) { s in
                        auth.username = s.filter { $0.isASCII }
                    }
                
                SecureField("Пароль", text: $auth.password)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .keyboardType(.asciiCapable)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textContentType(.password)
                    .submitLabel(.go)
                    .onSubmit { auth.login() }
                
                Toggle("Запомнить меня", isOn: Binding(
                    get: { auth.rememberMe },
                    set: { auth.setRemember($0) }
                ))
                
                HStack(spacing: 15) {
                    Button("Войти") { auth.login() }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(canLogin ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(!canLogin)
                    
                    Button("Регистрация") { showRegistration = true }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)          // без завязки на disabled
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    // можно разве что не давать повторно жать, пока модалка уже открыта:
                    // .disabled(showRegistration || auth.isBusy)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ThemeViewModel())
            .environmentObject(AuthViewModel()) // превью с простым VM
    }
}

