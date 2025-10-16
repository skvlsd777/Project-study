import SwiftUI

struct AppRoot: View {
    @StateObject private var themeVM: ThemeViewModel
    @StateObject private var router: RootRouter
    @StateObject private var authVM: AuthViewModel

    init() {
        let container = AppContainer() // сеть и провайдеры собраны здесь
        _themeVM = StateObject(wrappedValue: ThemeViewModel())
        _router  = StateObject(wrappedValue: RootRouter())
        _authVM  = StateObject(wrappedValue: AuthViewModel(auth: container.authService))
    }

    var body: some View {
        ContentView()
            .environmentObject(themeVM)
            .environmentObject(router)
            .environmentObject(authVM)
    }
}

