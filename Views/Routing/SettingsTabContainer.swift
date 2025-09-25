import SwiftUI

struct SettingsTabContainer: View {
    @EnvironmentObject var themeVM: ThemeViewModel
    @EnvironmentObject var router: RootRouter

    var body: some View {
        SettingsView()
            .navigationTitle("Настройки")
        // .navigationDestination(...) не нужен, пока нет внутренних роутов
    }
}


