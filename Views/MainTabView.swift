import SwiftUI

struct MainTabView: View {
    @Binding var isLoggedIn: Bool
    @EnvironmentObject var themeViewModel: ThemeViewModel

    // По одному стеку на таб
    @State private var designsPath = NavigationPath()
    @State private var advicePath  = NavigationPath()
    @State private var settingsPath = NavigationPath()
    @State private var profilePath = NavigationPath()

    var body: some View {
        TabView {
            NavigationStack(path: $designsPath) {
                DesignsListView()
                    .environmentObject(themeViewModel)
                    .navigationTitle("Стили дизайна")
                    .navigationDestination(for: Design.self) { design in
                        DesignDetailView(design: design,
                                         viewModel: DesignViewModel()) // или пробрось VM
                            .environmentObject(themeViewModel)
                    }
            }
            .tabItem { Label("Дизайны", systemImage: "paintbrush.fill") }

            // Вкладка "Советы"
            NavigationStack(path: $advicePath) {
                AdviceView()
                    .environmentObject(themeViewModel)
                    .navigationTitle("Советы")
                    .navigationDestination(for: AdviceItem.self) { item in
                        DetailAdviceView(adviceItem: item)
                            .environmentObject(themeViewModel)
                    }
            }
            .tabItem { Label("Советы", systemImage: "lightbulb.fill") }

            // Вкладка "Настройки"
            NavigationStack(path: $settingsPath) {
                SettingsView()
                    .environmentObject(themeViewModel)
                    .navigationTitle("Настройки")
            }
            .tabItem { Label("Настройки", systemImage: "gearshape.fill") }

            // Вкладка "Профиль"
            NavigationStack(path: $profilePath) {
                ProfileView(isLoggedIn: $isLoggedIn)
                    .environmentObject(themeViewModel)
                    .navigationTitle("Профиль")
            }
            .tabItem { Label("Профиль", systemImage: "person.fill") }
        }
        .preferredColorScheme(themeViewModel.currentTheme)
    }
}


struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(isLoggedIn: .constant(true))
            .environmentObject(ThemeViewModel())
    }
}

