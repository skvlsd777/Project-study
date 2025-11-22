import SwiftUI

struct DesignsCategoryView: View {
    let category: DesignsCategory                

    @StateObject private var designVM  = DesignViewModel()
    @StateObject private var exportVM  = ExportViewModel()
    @AppStorage("selectedDevice") private var selectedDeviceName = "Apple Watch Series 8"

    private var currentModel: WatchModel { WatchModel.model(for: selectedDeviceName) }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(filteredDesigns, id: \.id) { design in
                    VStack(spacing: 8) {
                        WatchPreview(model: currentModel) {
                            WatchCanvasView(
                                composition: composition(from: design),
                                animated: false
                            )
                        }
                        .frame(height: 200)

                        HStack {
                            Text(design.name).font(.subheadline).lineLimit(1)
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
        .navigationTitle(category.title) // см. расширение ниже
        .alert(exportVM.alertTitle, isPresented: $exportVM.showAlert) {
            Button("OK", role: .cancel) { }
        } message: { Text(exportVM.alertMessage ?? "") }
    }

    private var filteredDesigns: [Design] {
        let all = Array(designVM.designs)
        return all.filter { belongs($0, to: category) }
    }

    private func belongs(_ d: Design, to cat: DesignsCategory) -> Bool {
        let key = d.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch cat {
        case .minimalism: return key.contains("миним") || key.contains("min")
        case .classic:    return key.contains("класс") || key.contains("classic")
        case .brands:     return key.contains("бренд") || key.contains("brand") || key.contains("мировые")
        }
    }
}


