import Foundation

final class DesignsRepo {
    private let session: URLSession
    init(session: URLSession = .shared) { self.session = session }

    func load(slug: String) async throws -> [RemoteDesignItem] {
        let url = CDN.url(for: "\(slug)/index.json")
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(DesignManifest.self, from: data).items
    }
}

