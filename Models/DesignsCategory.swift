import Foundation

enum DesignsCategory: String, CaseIterable, Hashable {
    case minimalism = "Минимализм"
    case classic    = "Классика"
    case brands     = "Мировые бренды"

    var title: String { rawValue }
    var slug: String {
        switch self {
        case .minimalism: return "minimalizm"
        case .classic:    return "classic"
        case .brands:     return "brands"
        }
    }
}
