import SwiftUI

struct ProfileEditView: View {
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var usernameDraft: String = ""
    @State private var emailDraft: String = ""
    @State private var firstNameDraft: String = ""
    @State private var lastNameDraft: String = ""
    @State private var cityDraft: String = ""

    @State private var isBusy = false
    @State private var error: String?
    @State private var info: String?

    var body: some View {
        Form {
            Section(header: Text("Аккаунт")) {
                TextField("Логин", text: $usernameDraft)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                TextField("Email", text: $emailDraft)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }

            Section(header: Text("Профиль")) {
                TextField("Имя", text: $firstNameDraft)
                TextField("Фамилия", text: $lastNameDraft)
                TextField("Город", text: $cityDraft)
            }

            if let e = error { Section { Text(e).foregroundColor(.red) } }
            if let i = info  { Section { Text(i).foregroundColor(.green) } }

            Section {
                Button {
                    saveTapped()
                } label: {
                    Text(isBusy ? "Сохранение..." : "Сохранить изменения")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .disabled(isBusy || !canSave)
            }
        }
        .navigationTitle("Редактирование")
        .onAppear { loadDrafts() }
        .preferredColorScheme(themeViewModel.currentTheme)
    }

    private var canSave: Bool {
        !usernameDraft.trimmingCharacters(in: .whitespaces).isEmpty &&
        emailDraft.contains("@")
    }

    private func loadDrafts() {
        usernameDraft  = profileVM.username
        emailDraft     = profileVM.email
        firstNameDraft = profileVM.firstName
        lastNameDraft  = profileVM.lastName
        cityDraft      = profileVM.city
        error = nil; info = nil
    }

    private func saveTapped() {
        error = nil; info = nil; isBusy = true

        // Изменение логина добавим следующим шагом (нужны методы в AuthService)
        if usernameDraft != profileVM.username {
            error = "Изменение логина добавим на следующем шаге"
            isBusy = false
            return
        }

        profileVM.saveProfile(
            email: emailDraft,
            firstName: firstNameDraft,
            lastName: lastNameDraft,
            city: cityDraft
        )

        isBusy = false
        info = "Сохранено"
        // dismiss() — по желанию сразу закрывать экран
    }
}

struct ProfileEditView_Previews: PreviewProvider {
    // подготовим VM с данными для превью
    static var vm: ProfileViewModel = {
        let vm = ProfileViewModel()
        vm.username = "gorilla"
        vm.email = "gorilla@wallpaper.app"
        vm.firstName = "Gor"
        vm.lastName  = "Rilla"
        vm.city      = "Moscow"
        return vm
    }()

    static var previews: some View {
        NavigationStack {
            ProfileEditView()
                .environmentObject(ThemeViewModel())
                .environmentObject(vm)            // ← вместо init(viewModel:)
        }
    }
}

