import SwiftUI

struct DetailAdviceView: View {
    let adviceItem: AdviceItem  // Получаем совет с данными

    var body: some View {
        VStack {
            Image(adviceItem.imageName)  // Используем переданное имя изображения
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 300)
                .clipped()
                .cornerRadius(12)

            Text(adviceItem.title)
                .font(.title)
                .padding()

            Text(adviceItem.description)  // Добавляем описание совета
                .font(.body)
                .padding()

            Spacer()
        }
        .padding()
        .navigationBarTitle("Подробности", displayMode: .inline)
    }
}

struct DetailAdviceView_Previews: PreviewProvider {
    static var previews: some View {
        DetailAdviceView(adviceItem: AdviceItem(title: "Что нового в watchOS ?", description: "Описание изменений в watchOS 8", imageName: "watchOSNew", iconName: "clock.fill"))
    }
}
