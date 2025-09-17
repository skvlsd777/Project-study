import SwiftUI

// ЕДИНАЯ КАРТА МАРШРУТОВ ДЛЯ ВСЕГО ПРИЛОЖЕНИЯ
extension View {
    @ViewBuilder
    func appDestinations(
        isLoggedIn: Binding<Bool>,
        themeVM: ThemeViewModel
    ) -> some View {
        self.navigationDestination(for: Route.self) { route in
            switch route {
            case .designDetail(let design):
                DesignDetailView(design: design)
                    .environmentObject(themeVM)

            case .wallpaperDetail(let w):
                ScrollView {
                    VStack(spacing: 16) {
                        Image(w.imageName)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(16)
                        Text(w.name).font(.title2).bold()
                    }
                    .padding()
                }
                .navigationTitle(w.name)
                .navigationBarTitleDisplayMode(.inline)

            case .adviceDetail(let item):
                DetailAdviceView(adviceItem: item)

            case .settingsRoot:
                SettingsView()
                    .environmentObject(themeVM)

            case .profileRoot:
                ProfileView(isLoggedIn: isLoggedIn)
                    .environmentObject(themeVM)
            }
        }
    }
}

