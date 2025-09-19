import SwiftUI

struct AdviceTabContainer: View {
    @EnvironmentObject var themeVM: ThemeViewModel
    @EnvironmentObject var router: RootRouter

    var body: some View {
        AdviceView()
            .navigationTitle("Советы")
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .adviceDetail(let item):
                    DetailAdviceView(adviceItem: item)
                default:
                    EmptyView()
                }
            }
    }
}

