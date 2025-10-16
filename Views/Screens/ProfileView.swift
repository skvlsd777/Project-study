import SwiftUI

struct ProfileView: View {
    @Binding var isLoggedIn: Bool

    @EnvironmentObject var themeViewModel: ThemeViewModel
    @EnvironmentObject var router: RootRouter
    @EnvironmentObject var authVM: AuthViewModel      // было: auth
    @EnvironmentObject var viewModel: ProfileViewModel

    @State private var showAlert = false
    @AppStorage(AppStorageKeys.profileImageData) private var avatarData: Data?
    @State private var pickedImage: UIImage?
    @State private var showPicker = false

    // MARK: - Derived
    private var isDark: Bool { themeViewModel.currentTheme == .dark }
    private var background: Color { isDark ? .black : .white }
    private var avatarUIImage: UIImage? { pickedImage ?? avatarData.flatMap { UIImage(data: $0) } }

    // MARK: - Subviews
    private var header: some View {
        HStack(spacing: 20) {
            avatarBlock
            infoBlock
            Spacer()
        }
    }

    private var avatarBlock: some View {
        ZStack(alignment: .bottomTrailing) {
            avatarImageView
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white.opacity(0.9), lineWidth: 3))
                .shadow(radius: 10)
                .contentShape(Circle())
                .onTapGesture { showPicker = true }

            Image(systemName: "camera.fill")
                .imageScale(.small)
                .padding(8)
                .background(.ultraThinMaterial, in: Circle())
                .offset(x: -6, y: -6)
        }
    }

    private var infoBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(viewModel.username)
                .font(.title).bold()
                .foregroundColor(isDark ? .white : .black)

            Text(viewModel.email)
                .font(.subheadline)
                .foregroundColor(isDark ? .white : .gray)

            if !viewModel.city.isEmpty {
                Text(viewModel.city)
                    .font(.subheadline)
                    .foregroundColor(isDark ? .white : .gray)
            }
        }
    }

    private var actionsBlock: some View {
        VStack(alignment: .leading, spacing: 15) {
            Button {
                router.push(.profileEdit)
            } label: {
                Text("Редактировать профиль")
                    .font(.title3)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
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

    @ViewBuilder private var avatarImageView: some View {
        if let ui = avatarUIImage {
            Image(uiImage: ui).resizable().scaledToFill()
        } else {
            Image("AvatarProfile").resizable().scaledToFill()
        }
    }

    // MARK: - Actions
    private func handleLogout() {
        authVM.logout(router: router)
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            header
            actionsBlock
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(background.ignoresSafeArea())
        .confirmationDialog("Выход", isPresented: $showAlert) {
            Button("Да", role: .destructive) { handleLogout() }
            Button("Отмена", role: .cancel) { }
        } message: {
            Text("Вы уверены, что хотите выйти?")
        }
        .sheet(isPresented: $showPicker) {
            PhotoPicker(selectedImage: $pickedImage)
        }
        .onChange(of: pickedImage) { img in
            guard let img, let data = img.jpegData(compressionQuality: 0.9) else { return }
            avatarData = data
        }
        .navigationTitle("Профиль")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isLoggedIn: .constant(true))
            .environmentObject(ThemeViewModel())
            .environmentObject(RootRouter())
            .environmentObject(AuthViewModel(auth: PreviewDI.authService))
            .environmentObject(ProfileViewModel())
    }
}
