import SwiftUI

struct DesignDetailView: View {
    let design: Design
    @EnvironmentObject var themeViewModel: ThemeViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Image(design.imageName)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(16)

                Text(design.name)
                    .font(.title).bold()

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)], spacing: 12) {
                    ForEach(design.wallpapers) { w in
                        NavigationLink(value: Route.wallpaperDetail(w)) {
                            WallpaperTile(wallpaper: w)
                        }
                    }
                }
            }
            .padding()
        }
        .background(themeViewModel.currentTheme == .dark ? Color.black : Color.white)
        .navigationTitle(design.name)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(themeViewModel.currentTheme)
    }
}

private struct WallpaperTile: View {
    let wallpaper: Wallpaper
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(wallpaper.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 180)
                .clipped()
                .cornerRadius(12)
            Text(wallpaper.name)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .lineLimit(1)
        }
    }
}

struct DesignDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DesignDetailView(design: sampleDesign)
                .environmentObject(ThemeViewModel())
        }
    }

    // Пример данных для превью
    private static var sampleDesign: Design {
        Design(
            name: "Минимализм",
            imageName: "Minimalism",
            style: "Minimal",
            wallpapers: [
                Wallpaper(name: "Обои 1", imageName: "WorldBrandsWallpaper1"),
                Wallpaper(name: "Обои 2", imageName: "WorldBrandsWallpaper2")
            ]
        )
    }
}

