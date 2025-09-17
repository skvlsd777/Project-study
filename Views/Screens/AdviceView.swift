import SwiftUI

struct AdviceView: View {
    @StateObject private var viewModel = AdviceViewModel()
    @EnvironmentObject var themeViewModel: ThemeViewModel

    var body: some View {
        List(viewModel.adviceItems) { adviceItem in
            NavigationLink {
                DetailAdviceView(adviceItem: adviceItem)
                    .environmentObject(themeViewModel)
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(adviceItem.title)
                        .font(.headline)
                        .foregroundColor(themeViewModel.currentTheme == .dark ? .white : .black)
                    Text(adviceItem.description)
                        .font(.subheadline)
                        .lineLimit(2)
                        .foregroundColor(themeViewModel.currentTheme == .dark ? .white.opacity(0.8) : .gray)
                }
                .padding(10)
                .background((themeViewModel.currentTheme == .dark ? Color.black.opacity(0.3) : Color.blue.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 10)))
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Советы") // заголовок придёт от стека во вкладке
        .preferredColorScheme(themeViewModel.currentTheme)
    }
}

struct AdviceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AdviceView().environmentObject(ThemeViewModel())
        }
    }
}


