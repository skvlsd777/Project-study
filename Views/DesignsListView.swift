import SwiftUI

struct DesignsListView: View {
    @StateObject private var viewModel = DesignViewModel()
    @EnvironmentObject var themeViewModel: ThemeViewModel

    private let cols = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: cols, spacing: 16) {
                ForEach(viewModel.designs) { design in
                    NavigationLink(value: design) {
                        DesignCard(design: design)
                            .padding(4)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Стили дизайна")
        .background(themeViewModel.currentTheme == .dark ? Color.black : Color.white)
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

// Превью только для Xcode — оборачиваем в NavigationStack, чтобы увидеть заголовок
struct DesignsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DesignsListView()
                .environmentObject(ThemeViewModel())
        }
    }
}


