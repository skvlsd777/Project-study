import SwiftUI

struct AdviceItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
    let iconName: String
}
