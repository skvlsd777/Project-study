import SwiftUI

struct CustomView: View {
    @StateObject private var viewModel = CustomizationViewModel()
    @State private var isImagePickerPresented = false
    @EnvironmentObject var themeViewModel: ThemeViewModel

    @AppStorage("selectedDevice") private var selectedDeviceName: String = "Apple Watch Series 8"

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Выберите циферблат")
                    .font(.largeTitle).bold()
                    .foregroundColor(themeViewModel.currentTheme == .dark ? .white : .black)

                // Текущая модель берётся из настроек
                let model = WatchCatalog.model(for: selectedDeviceName)

                WatchPreview(model: model,
                             userImage: viewModel.customizationData.userSelectedImage,
                             placeholder: viewModel.customizationData.selectedColor.opacity(0.5))
                .frame(maxWidth: 420)
                .padding(.vertical, 8)

                Button("Загрузить изображение для циферблата") {
                    isImagePickerPresented = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                ColorPicker("Выберите цвет", selection: $viewModel.customizationData.selectedColor)
                    .padding()

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
            PhotoPicker(selectedImage: $viewModel.customizationData.userSelectedImage)
        }
        .navigationTitle("Кастомизация")
        .preferredColorScheme(themeViewModel.currentTheme)
    }
}



struct CustomView_Previews: PreviewProvider {
    static var previews: some View {
        CustomView() // Теперь просто инициализируем без передачи viewModel
            .environmentObject(ThemeViewModel()) // Передаем ThemeViewModel
    }
}

