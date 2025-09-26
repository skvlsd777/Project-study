import SwiftUI

struct DesignsListView: View {
    @StateObject var viewModel = DesignViewModel()
    @EnvironmentObject var themeViewModel: ThemeViewModel

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(viewModel.designs) { design in
                    let isCustom = design.name
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .lowercased() == "кастом"

                    NavigationLink(
                        value: isCustom
                            ? Route.customization
                            : Route.designDetail(design)
                    ) {
                        DesignCard(design: design)
                            .padding()
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
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

struct DesignsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DesignsListView()
                .environmentObject(ThemeViewModel())
        }
    }
}



