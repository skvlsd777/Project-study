import SwiftUI

struct DesignsCategoryView: View {
    let category: DesignsCategory

    @StateObject private var feedVM  = CategoryFeedViewModel()  // 🔹 удалённые элементы
    @StateObject private var exportVM = ExportViewModel()
    @AppStorage("selectedDevice") private var selectedDeviceName = "Apple Watch Series 8"

    private var currentModel: WatchModel { WatchModel.model(for: selectedDeviceName) }

    var body: some View {
        ScrollView {
            if let err = feedVM.errorMessage {
                Text(err).foregroundColor(.red).padding(.horizontal)
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(feedVM.items) { item in
                    VStack(spacing: 8) {
                        // Превью циферблата по миниатюре (thumb)
                        WatchPreview(model: currentModel) {
                            WatchCanvasView(
                                composition: Composition(
                                    background: .url(CDN.url(for: item.thumb)),
                                    numerals: nil,
                                    hands: .classic
                                ),
                                animated: false
                            )
                        }
                        .frame(height: 200)

                        HStack {
                            Text(item.title).font(.subheadline).lineLimit(1)
                            Spacer()
                            Button {
                                Task { await exportVM.save(remote: item, for: currentModel) }
                            } label: {
                                Image(systemName: "square.and.arrow.down")
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(category.title)
        .task { await feedVM.load(for: category) } // 🔹 тянем index.json по slug
        .alert(exportVM.alertTitle, isPresented: $exportVM.showAlert) {
            Button("OK", role: .cancel) { }
        } message: { Text(exportVM.alertMessage ?? "") }
    }
}



