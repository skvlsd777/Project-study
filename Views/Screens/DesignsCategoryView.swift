import SwiftUI

struct DesignsCategoryView: View {
    enum Category: String, CaseIterable {
        case minimalism = "Минимализм"
        case classic    = "Классика"
        case brands     = "Мировые бренды"
    }

    let category: Category

    @StateObject private var designVM  = DesignViewModel()
    @StateObject private var exportVM  = ExportViewModel()
    @AppStorage("selectedDevice") private var selectedDeviceName = "Apple Watch Series 8"

    private var currentModel: WatchModel { WatchModel.model(for: selectedDeviceName) }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(filteredDesigns, id: \.id) { design in   // ⬅️ явный id
                    VStack(spacing: 8) {
                        WatchPreview(model: currentModel) {
                            WatchCanvasView(
                                composition: composition(from: design),
                                animated: false
                            )
                        }
                        .frame(height: 200)

                        HStack {
                            Text(design.name)                // ⬅️ у тебя поле name
                                .font(.subheadline)
                                .lineLimit(1)
                            Spacer()
                            Button {
                                Task { await exportVM.save(design: design, for: currentModel) }
                            } label: { Image(systemName: "square.and.arrow.down") }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(category.rawValue)
        .alert(exportVM.alertTitle, isPresented: $exportVM.showAlert) {
            Button("OK", role: .cancel) { }
        } message: { Text(exportVM.alertMessage ?? "") }
    }

    // MARK: - Данные для экрана категории
    private var filteredDesigns: [Design] {
        let all = Array(designVM.designs)              // ⬅️ приводим к [Design], чтобы не ловить Predicate<Design>
        return all.filter { belongs($0, to: category) }
    }

    /// Временная эвристика: определяем категорию по имени дизайна
    private func belongs(_ d: Design, to cat: Category) -> Bool {
        let key = d.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch cat {
        case .minimalism:
            return key.contains("min") || key.contains("миним")
        case .classic:
            return key.contains("classic") || key.contains("класс")
        case .brands:
            return key.contains("brand") || key.contains("бренд")
        }
    }

    private func composition(from design: Design) -> Composition {
        // если позже добавишь URL: String? → вернём .url(URL)
        Composition(background: .asset(design.imageName), numerals: nil, hands: .classic)
    }
}

