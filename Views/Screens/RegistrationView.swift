import SwiftUI

struct RegistrationView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeViewModel: ThemeViewModel

    @StateObject private var vm = RegistrationViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Регистрация")
                    .font(.title).bold()
                    .padding(88)

                TextField("Логин", text: $vm.username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textContentType(.username)
                    .keyboardType(.asciiCapable)
                    .padding()
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(12)
                    .shadow(radius: 5)

                SecureField("Пароль", text: $vm.password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textContentType(.password)
                    .keyboardType(.asciiCapable)
                    .submitLabel(.go)
                    .padding()
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(12)
                    .shadow(radius: 5)

                TextField("Email", text: $vm.email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(12)
                    .shadow(radius: 5)

                if let e = vm.error {
                    Text(e).foregroundColor(.red).font(.footnote)
                }

                HStack(spacing: 12) {
                    Button("Зарегистрироваться") { vm.register() }
                        .frame(width: 180)
                        .padding()
                        .background(vm.canSubmit && !vm.isBusy ? Color.green : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .disabled(!vm.canSubmit || vm.isBusy)

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
        // твой фон «без ZStack»
        .background(
            Group {
                if themeViewModel.currentTheme == .dark {
                    Color.black.opacity(0.6)
                } else {
                    Color.clear
                }
            }.ignoresSafeArea()
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
        RegistrationView()
            .environmentObject(ThemeViewModel())
    }
}


