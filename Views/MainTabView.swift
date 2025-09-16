import SwiftUI

struct MainTabView: View {
    @Binding var isLoggedIn: Bool
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @EnvironmentObject var router: Router

    var body: some View {
        TabView(selection: $router.selectedTab) {

            // ДИЗАЙНЫ
            NavigationStack(path: router.pathBinding(for: .designs)) {
                DesignsListView()
                    .navigationTitle("Стили дизайна")
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .designDetail(let design):
                            DesignDetailView(design: design)
                                .environmentObject(themeViewModel)

                        case .wallpaperDetail(let w):
                            // Инлайн «деталь обоев» (без отдельного файла)
                            ScrollView {
                                VStack(spacing: 16) {
                                    Image(w.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(16)
                                    Text(w.name)
                                        .font(.title2).bold()
                                }
                                .padding()
                            }
                            .navigationTitle(w.name)
                            .navigationBarTitleDisplayMode(.inline)

                        case .adviceDetail(let item):
                            DetailAdviceView(adviceItem: item)

                        case .settingsRoot:
                            SettingsView().environmentObject(themeViewModel)

                        case .profileRoot:
                            ProfileView(isLoggedIn: $isLoggedIn).environmentObject(themeViewModel)
                        }
                    }
            }
            .tabItem { Label("Дизайны", systemImage: "paintbrush.fill") }
            .tag(AppTab.designs)

            // СОВЕТЫ
            NavigationStack(path: router.pathBinding(for: .advice)) {
                AdviceView()
                    .navigationTitle("Советы")
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .adviceDetail(let item):
                            DetailAdviceView(adviceItem: item)
                        case .designDetail(let design):
                            DesignDetailView(design: design).environmentObject(themeViewModel)
                        case .settingsRoot:
                            SettingsView().environmentObject(themeViewModel)
                        case .profileRoot:
                            ProfileView(isLoggedIn: $isLoggedIn).environmentObject(themeViewModel)
                        case .wallpaperDetail:
                            EmptyView()
                        }
                    }
            }
            .tabItem { Label("Советы", systemImage: "lightbulb.fill") }
            .tag(AppTab.advice)

            // НАСТРОЙКИ
            NavigationStack(path: router.pathBinding(for: .settings)) {
                SettingsView()
                    .navigationTitle("Настройки")
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .designDetail(let design):
                            DesignDetailView(design: design).environmentObject(themeViewModel)
                        case .adviceDetail(let item):
                            DetailAdviceView(adviceItem: item)
                        case .profileRoot:
                            ProfileView(isLoggedIn: $isLoggedIn).environmentObject(themeViewModel)
                        case .settingsRoot, .wallpaperDetail:
                            EmptyView()
                        }
                    }
            }
            .tabItem { Label("Настройки", systemImage: "gearshape.fill") }
            .tag(AppTab.settings)

            // ПРОФИЛЬ
            NavigationStack(path: router.pathBinding(for: .profile)) {
                ProfileView(isLoggedIn: $isLoggedIn)
                    .environmentObject(themeViewModel)
                    .navigationTitle("Профиль")
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .designDetail(let design):
                            DesignDetailView(design: design).environmentObject(themeViewModel)
                        case .adviceDetail(let item):
                            DetailAdviceView(adviceItem: item)
                        case .settingsRoot:
                            SettingsView().environmentObject(themeViewModel)
                        case .profileRoot, .wallpaperDetail:
                            EmptyView()
                        }
                    }
            }
            .tabItem { Label("Профиль", systemImage: "person.fill") }
            .tag(AppTab.profile)
        }
        .preferredColorScheme(themeViewModel.currentTheme)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewMainTab()
    }
}

private struct PreviewMainTab: View {
    @State private var isLoggedIn = true
    @StateObject private var themeVM = ThemeViewModel()
    @StateObject private var router  = Router()

    var body: some View {
        MainTabView(isLoggedIn: $isLoggedIn)
            .environmentObject(themeVM)
            .environmentObject(router)
    }
}
