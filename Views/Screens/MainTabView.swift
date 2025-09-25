import SwiftUI

struct MainTabView: View {
    @Binding var isLoggedIn: Bool
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @EnvironmentObject var router: RootRouter


    var body: some View {
        TabView(selection: $router.selectedTab) {

            // ДИЗАЙНЫ
            TabNavStack(tab: .designs, isLoggedIn: $isLoggedIn) {
                DesignsTabContainer()
            }
            .tabItem { Label("Дизайны", systemImage: "paintbrush.fill") }
            .tag(AppTab.designs)

            // СОВЕТЫ
            TabNavStack(tab: .advice, isLoggedIn: $isLoggedIn) {
                AdviceTabContainer()
            }
            .tabItem { Label("Советы", systemImage: "lightbulb.fill") }
            .tag(AppTab.advice)

            // НАСТРОЙКИ
            TabNavStack(tab: .settings, isLoggedIn: $isLoggedIn) {
                SettingsTabContainer()
            }
            .tabItem { Label("Настройки", systemImage: "gearshape.fill") }
            .tag(AppTab.settings)

            // ПРОФИЛЬ
            TabNavStack(tab: .profile, isLoggedIn: $isLoggedIn) {
                ProfileTabContainer(isLoggedIn: $isLoggedIn)
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
    @StateObject private var router  = RootRouter()

    var body: some View {
        MainTabView(isLoggedIn: $isLoggedIn)
            .environmentObject(themeVM)
            .environmentObject(router)
    }
}

