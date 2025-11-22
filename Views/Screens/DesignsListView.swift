import SwiftUI

struct DesignsListView: View {
    @StateObject var viewModel = DesignViewModel()
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @EnvironmentObject var router: RootRouter

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(viewModel.designs) { design in
                    Button {
                        router.push(route(for: design))
                    } label: {
                        DesignCard(design: design)
                            .padding()
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .background(themeViewModel.currentTheme == .dark ? Color.black : Color.white)
        .navigationTitle("Стили дизайна")
    }

    private func route(for design: Design) -> Route {
        let key = normalize(design.name)

        if key == "кастом" {
            return .customization
        } else if key.contains("миним") || key.contains("min") {
            return .designsCategory(.minimalism)
        } else if key.contains("класс") || key.contains("classic") {
            return .designsCategory(.classic)
        } else if key.contains("мировые бренды") || key.contains("бренды") || key.contains("brand") {
            return .designsCategory(.brands)
        } else {
            return .designDetail(design)
        }
    }

    // Нормализация имени (срез пробелов, в нижний регистр)
    private func normalize(_ s: String) -> String {
        s.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
}

struct DesignCard: View {
    let design: Design
    var body: some View {
        VStack {
            Image(design.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: (UIScreen.main.bounds.width / 2) - 32, height: 200)
                .clipped()
                .cornerRadius(25)

            Text(design.name)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 5)
        }
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.2))
        .cornerRadius(16)
        .shadow(radius: 1)
        .padding(4)
    }
}

// Обнови превью, чтобы был router в окружении
struct DesignsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DesignsListView()
                .environmentObject(ThemeViewModel())
                .environmentObject(RootRouter())
        }
    }
}

