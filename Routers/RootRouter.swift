import SwiftUI

// MARK: - Tabs
enum AppTab: Hashable { case designs, advice, settings, profile }

// MARK: - Routes
// Держим тут же, в этом файле (верхний уровень)
enum Route: Hashable {
    case designsCategory(DesignsCategory)
    case designDetail(Design)
    case wallpaperDetail(Wallpaper)
    case adviceDetail(AdviceItem)
    case settingsRoot
    case profileRoot
    case profileEdit
    case customization
}

// MARK: - Root Router
final class RootRouter: ObservableObject {
    @Published var selectedTab: AppTab = .designs

    // Отдельные стеки истории для каждой вкладки
    @Published private var pathDesigns  = NavigationPath()
    @Published private var pathAdvice   = NavigationPath()
    @Published private var pathSettings = NavigationPath()
    @Published private var pathProfile  = NavigationPath()

    // Доступ к нужному пути
    private func keyPath(for tab: AppTab) -> ReferenceWritableKeyPath<RootRouter, NavigationPath> {
        switch tab {
        case .designs:  return \.pathDesigns
        case .advice:   return \.pathAdvice
        case .settings: return \.pathSettings
        case .profile:  return \.pathProfile
        }
    }

    /// Биндинг для NavigationStack(path:)
    func binding(for tab: AppTab) -> Binding<NavigationPath> {
        let kp = keyPath(for: tab)
        return Binding(get: { self[keyPath: kp] }, set: { self[keyPath: kp] = $0 })
    }

    // MARK: - Навигация
    func push(_ route: Route, on tab: AppTab? = nil) {
        let t = tab ?? selectedTab
        let kp = keyPath(for: t)
        var p = self[keyPath: kp]
        p.append(route)
        self[keyPath: kp] = p
    }

    func pop(on tab: AppTab? = nil) {
        let t = tab ?? selectedTab
        let kp = keyPath(for: t)
        var p = self[keyPath: kp]
        if !p.isEmpty { p.removeLast() }
        self[keyPath: kp] = p
    }

    func popToRoot(on tab: AppTab? = nil) {
        let t = tab ?? selectedTab
        let kp = keyPath(for: t)
        self[keyPath: kp] = NavigationPath()
    }

    func switchTo(_ tab: AppTab) { selectedTab = tab }

    /// Переключить вкладку и сразу перейти
    func go(to tab: AppTab, _ route: Route) {
        if selectedTab == tab {
            push(route, on: tab)
        } else {
            selectedTab = tab
            // избегаем "Modifying state during update"
            DispatchQueue.main.async { self.push(route, on: tab) }
        }
    }
}




