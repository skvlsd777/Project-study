import SwiftUI

struct RegistrationView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeViewModel: ThemeViewModel

    @StateObject private var vm: RegistrationViewModel

    // DEBUG: можно вызывать RegistrationView() без параметров
    #if DEBUG
    init(auth: AuthService = PreviewDI.authService) {
        _vm = StateObject(wrappedValue: RegistrationViewModel(auth: auth))
    }
    #else
    // RELEASE: сервис обязателен
    init(auth: AuthService) {
        _vm = StateObject(wrappedValue: RegistrationViewModel(auth: auth))
    }
    #endif

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Регистрация")
                    .font(.title.bold())
                    .padding(88)

                TextField("", text: $vm.username,
                          prompt: Text("Логин").foregroundColor(.gray))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textContentType(.username)
                    .keyboardType(.asciiCapable)
                    .padding()
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .foregroundColor(.black)
                    .tint(.black)

                SecureField("", text: $vm.password,
                            prompt: Text("Пароль").foregroundColor(.gray))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textContentType(.password)
                    .keyboardType(.asciiCapable)
                    .submitLabel(.go)
                    .padding()
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .foregroundColor(.black)
                    .tint(.black)

                TextField("", text: $vm.email,
                          prompt: Text("Email").foregroundColor(.gray))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .foregroundColor(.black)
                    .tint(.black)

                if let e = vm.errorMessage {
                    Text(e).foregroundColor(.red).font(.footnote)
                }

                HStack(spacing: 12) {
                    Button("Зарегистрироваться") { vm.register() }
                        .frame(width: 180)
                        .padding()
                        .background(vm.canSubmit ? Color.green : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .disabled(!vm.canSubmit)

                    Button("Отмена") { dismiss() }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

                if vm.isBusy { ProgressView().padding(.top, 6) }
                Spacer(minLength: 32)
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: 560)
            .padding(.bottom, 24)
            .frame(maxWidth: .infinity)
        }
        .background(
            Group {
                themeViewModel.currentTheme == .dark
                    ? Color.black.opacity(0.6)
                    : Color.clear
            }
            .ignoresSafeArea()
        )
        .background(
            Image("Wallpaper")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
        .onAppear { vm.onSuccess = { dismiss() } }
        .preferredColorScheme(themeViewModel.currentTheme)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(auth: PreviewDI.authService)
            .environmentObject(ThemeViewModel())
    }
}


