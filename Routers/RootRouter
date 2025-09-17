import SwiftUI

// Вкладки
enum AppTab: Hashable { case designs, advice, settings, profile }

// Маршруты
enum Route: Hashable {
    case designDetail(Design)
    case wallpaperDetail(Wallpaper)
    case adviceDetail(AdviceItem)
    case settingsRoot
    case profileRoot
}

// Роутер приложения
final class Router: ObservableObject {
    @Published var selectedTab: AppTab = .designs

    @Published var pathDesigns  = NavigationPath()
    @Published var pathAdvice   = NavigationPath()
    @Published var pathSettings = NavigationPath()
    @Published var pathProfile  = NavigationPath()

    // биндинг для NavigationStack(path:)
    func pathBinding(for tab: AppTab) -> Binding<NavigationPath> {
        switch tab {
        case .designs:  return Binding(get: { self.pathDesigns  }, set: { self.pathDesigns  = $0 })
        case .advice:   return Binding(get: { self.pathAdvice   }, set: { self.pathAdvice   = $0 })
        case .settings: return Binding(get: { self.pathSettings }, set: { self.pathSettings = $0 })
        case .profile:  return Binding(get: { self.pathProfile  }, set: { self.pathProfile  = $0 })
        }
    }

    // Переходы
    func push(_ route: Route, on tab: AppTab? = nil) {
        let t = tab ?? selectedTab
        switch t {
        case .designs:  pathDesigns.append(route)
        case .advice:   pathAdvice.append(route)
        case .settings: pathSettings.append(route)
        case .profile:  pathProfile.append(route)
        }
    }

    private func popOne(_ path: inout NavigationPath) {
        if !path.isEmpty { path.removeLast() }
    }

    func pop(on tab: AppTab? = nil) {
        let t = tab ?? selectedTab
        switch t {
        case .designs:  popOne(&pathDesigns)
        case .advice:   popOne(&pathAdvice)
        case .settings: popOne(&pathSettings)
        case .profile:  popOne(&pathProfile)
        }
    }

    func popToRoot(on tab: AppTab? = nil) {
        let t = tab ?? selectedTab
        switch t {
        case .designs:  pathDesigns  = NavigationPath()
        case .advice:   pathAdvice   = NavigationPath()
        case .settings: pathSettings = NavigationPath()
        case .profile:  pathProfile  = NavigationPath()
        }
    }

    func switchTo(_ tab: AppTab) { selectedTab = tab }

    /// Переключить вкладку и сразу запушить маршрут
    func go(to tab: AppTab, _ route: Route) {
        if selectedTab == tab {
            push(route, on: tab)
        } else {
            selectedTab = tab
            DispatchQueue.main.async { self.push(route, on: tab) }
        }
    }
}



