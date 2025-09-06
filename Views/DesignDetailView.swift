import SwiftUI

struct DesignDetailView: View {
    let design: Design
    @ObservedObject var viewModel: DesignViewModel // Используем ViewModel для получения данных
    @EnvironmentObject var themeViewModel: ThemeViewModel
    
    var body: some View {
        VStack {
            Text(design.name)
                .font(.largeTitle)
                .padding()
            
            // Загружаем обои для выбранного дизайна
            ScrollView {
                ForEach(design.wallpapers) { wallpaper in
                    VStack {
                        Image(wallpaper.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width - 32, height: 200)
                            .clipped()
                            .cornerRadius(12)
                        
                        Text(wallpaper.name)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.top, 5)
                    }
                    .padding()
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.black.opacity(0.6))
        .cornerRadius(16)
        .preferredColorScheme(themeViewModel.currentTheme) // Применяем тему
    }
}

struct DesignDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Создаем примерный объект Design для превью
        let design = Design(name: "Минимализм", imageName: "Minimalism", style: "Minimal", wallpapers: [
            Wallpaper(name: "Обои 1", imageName: "WorldBrandsWallpaper1"),
            Wallpaper(name: "Обои 2", imageName: "WorldBrandsWallpaper2")
        ])
        
        // Создаем ViewModel для Design
        let viewModel = DesignViewModel()

        // Передаем design и viewModel в DesignDetailView
        return DesignDetailView(design: design, viewModel: viewModel)
            .environmentObject(ThemeViewModel()) // Передаем тему
    }
}

