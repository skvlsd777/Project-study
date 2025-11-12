import Foundation

struct DesignManifest: Decodable {
    let items: [RemoteDesignItem]
}

struct RemoteDesignItem: Identifiable, Decodable, Hashable {
    let id: String
    let title: String
    let thumb: String   // "minimalizm/thumbs/m1.jpg"
    let full:  String   // "minimalizm/full/m1.png"
    let tags: [String]?
}
