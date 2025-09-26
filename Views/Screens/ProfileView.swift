import SwiftUI

struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @EnvironmentObject var router: RootRouter
    @EnvironmentObject var auth: AuthViewModel
    @EnvironmentObject var viewModel: ProfileViewModel

    @State private var showAlert = false

    @AppStorage(AppStorageKeys.profileImageData) private var avatarData: Data?
    @State private var pickedImage: UIImage?
    @State private var showPicker = false

    private var avatarUIImage: UIImage? {
        avatarData.flatMap { UIImage(data: $0) }
    }

    var body: some View {
        ZStack {
            (themeViewModel.currentTheme == .dark ? Color.black : Color.white).ignoresSafeArea()

            VStack(spacing: 20) {
                HStack(spacing: 20) {

                    // --- АВАТАР С ВОЗМОЖНОСТЬЮ ВЫБОРА ИЗ ГАЛЕРЕИ ---
                    ZStack(alignment: .bottomTrailing) {
                        Group {
                            if let ui = avatarUIImage {
                                Image(uiImage: ui)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Image("AvatarProfile")
                                    .resizable()
                                    .scaledToFill()
                            }
                        }
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white.opacity(0.9), lineWidth: 3))
                        .shadow(radius: 10)
                        .contentShape(Circle())           // чтобы тап по кругу попадал
                        .onTapGesture { showPicker = true } // открыть галерею

                        // маленькая иконка камеры
                        Image(systemName: "camera.fill")
                            .imageScale(.small)
                            .padding(8)
                            .background(.ultraThinMaterial, in: Circle())
                            .offset(x: -6, y: -6)
                    }

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
                    Spacer()
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
        .sheet(isPresented: $showPicker) {
            // используем твой готовый PhotoPicker
            PhotoPicker(selectedImage: $pickedImage)
        }
        .onChange(of: pickedImage) { img in
            // сохраняем В ОТДЕЛЬНОЕ хранилище профиля (не влияет на CustomView)
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
            .environmentObject(AuthViewModel())
            .environmentObject(ProfileViewModel())
    }
}

