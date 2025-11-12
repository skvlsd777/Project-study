import Foundation

@MainActor
final class CategoryFeedViewModel: ObservableObject {
    @Published var items: [RemoteDesignItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repo = DesignsRepo()

    func load(for category: DesignsCategoryView.Category) async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            items = try await repo.load(slug: category.slug)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

