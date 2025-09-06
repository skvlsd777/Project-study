import SwiftUI

class CustomizationViewModel: ObservableObject {
    @Published var customizationData: CustomizationData
    
    init(customizationData: CustomizationData = CustomizationData(selectedColor: .blue, userSelectedImage: nil)) {
        self.customizationData = customizationData
    }
    
    // Метод для изменения цвета
    func updateColor(_ color: Color) {
        customizationData.selectedColor = color
    }
    
    // Метод для обновления выбранного изображения
    func updateImage(_ image: UIImage?) {
        customizationData.userSelectedImage = image
    }
}
