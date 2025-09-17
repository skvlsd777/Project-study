import SwiftUI

struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    @StateObject var viewModel = ProfileViewModel()
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @State private var navigationPath = NavigationPath()
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                themeViewModel.currentTheme == .dark ? Color.black.ignoresSafeArea() : Color.white.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Аватар и основные данные
                    HStack(spacing: 20) {
                        Image("AvatarProfile")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                        
                        VStack(alignment: .leading) {
                            Text(viewModel.userProfile.username)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(themeViewModel.currentTheme == .dark ? .white : .black)
                            
                            Text(viewModel.userProfile.email)
                                .font(.subheadline)
                                .foregroundColor(themeViewModel.currentTheme == .dark ? .white : .gray)
                            
                            Text(viewModel.userProfile.city)
                                .font(.subheadline)
                                .foregroundColor(themeViewModel.currentTheme == .dark ? .white : .gray)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        // Навигация на редактирование
                        NavigationLink(value: viewModel.userProfile) {
                            Text("Редактировать профиль")
                                .font(.title3)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showAlert = true
                        }) {
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
                            isLoggedIn = false
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            // Навигация через Hashable UserProfile
            .navigationDestination(for: UserProfile.self) { profile in
                ProfileEditView(viewModel: viewModel)
                    .environmentObject(themeViewModel)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isLoggedIn: .constant(true))
            .environmentObject(ThemeViewModel())
    }
}


