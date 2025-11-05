import SwiftUI

struct DesignsTabContainer: View {
    @EnvironmentObject var themeVM: ThemeViewModel
    @EnvironmentObject var router: RootRouter

    var body: some View {
        DesignsListView()
            .navigationTitle("Стили дизайна")
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .designDetail(let design):
                    DesignDetailView(design: design)
                        .environmentObject(themeVM)
                    
                case .customization:
                    CustomView()
                    
                case .category(let cat):
                    DesignsCategoryView(category: cat)
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

                default:
                    EmptyView() // чужие роуты игнорируем
                }
            }
    }
}

