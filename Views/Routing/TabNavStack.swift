import SwiftUI

// ОБЁРТКА ДЛЯ КАЖДОЙ ВКЛАДКИ: NavigationStack + единая карта маршрутов
struct TabNavStack<Content: View>: View {
    let tab: AppTab
    @Binding var isLoggedIn: Bool

    @EnvironmentObject private var router: RootRouter
    @EnvironmentObject private var themeVM: ThemeViewModel
    @ViewBuilder var content: () -> Content

    var body: some View {
        NavigationStack(path: router.binding(for: tab)) {
            content()
                .appDestinations(isLoggedIn: $isLoggedIn, themeVM: themeVM)
        }
    }
}

