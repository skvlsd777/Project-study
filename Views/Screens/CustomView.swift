import SwiftUI

struct CustomView: View {
    @StateObject private var viewModel = CustomizationViewModel() // Инициализация внутри View
    @State private var isImagePickerPresented = false
    @EnvironmentObject var themeViewModel: ThemeViewModel // Подключаем ThemeViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Выберите циферблат")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(themeViewModel.currentTheme == .dark ? .white : .black) // Используем тему для текста
                
                ZStack {
                    // Если пользователь выбрал изображение, отображаем его
                    if let image = viewModel.customizationData.userSelectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 140, height: 170)
                            .clipped()
                            .padding()
                            .background(viewModel.customizationData.selectedColor.opacity(0.5))
                            .cornerRadius(50)
                            .padding(.bottom, 50)
                    } else {
                        Image("Dial1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 170)
                            .clipped()
                            .padding()
                            .background(viewModel.customizationData.selectedColor)
                            .cornerRadius(50)
                            .padding(.bottom, 50)
                    }
                    
                    Image("CustomWatch")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 500)
                        .clipped()
                }
                
                ColorPicker("Выберите цвет", selection: $viewModel.customizationData.selectedColor)
                    .padding()
                
                Button("Загрузить изображение для циферблата") {
                    isImagePickerPresented = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Spacer()
            }
            .padding()
            .background(
                Group {
                    if viewModel.customizationData.userSelectedImage == nil {
                        Image("Background1")
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                    }
                }
            )
        }
        .sheet(isPresented: $isImagePickerPresented) {
            // Передаем данные в PhotoPicker для обновления изображения в ViewModel
            PhotoPicker(selectedImage: $viewModel.customizationData.userSelectedImage)
        }
        .navigationTitle("Кастомизация")
        .preferredColorScheme(themeViewModel.currentTheme) // Применяем тему ко всему экрану
    }
}


struct CustomView_Previews: PreviewProvider {
    static var previews: some View {
        CustomView() // Теперь просто инициализируем без передачи viewModel
            .environmentObject(ThemeViewModel()) // Передаем ThemeViewModel
    }
}

