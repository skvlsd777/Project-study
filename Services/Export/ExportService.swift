import SwiftUI
import Photos

protocol Exporting {
    @MainActor
    func saveToPhotos<V: View>(view: V, pixelSize: CGSize) async throws
}

enum ExportError: Error { case renderFailed, noPermission }

@MainActor
final class ExportService: Exporting {
    func saveToPhotos<V: View>(view: V, pixelSize: CGSize) async throws {
        let renderer = ImageRenderer(
            content: view
                .frame(width: pixelSize.width, height: pixelSize.height)
                .background(Color.black)
        )
        renderer.scale = 1 // или UIScreen.main.scale — тоже ок на @MainActor

        guard let uiImage = renderer.uiImage else { throw ExportError.renderFailed }

        let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        guard status == .authorized || status == .limited else { throw ExportError.noPermission }

        try await PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: uiImage)
        }
    }
}

extension PHPhotoLibrary {
    static func requestAuthorization(for access: PHAccessLevel) async -> PHAuthorizationStatus {
        await withCheckedContinuation { cont in
            self.requestAuthorization(for: access) { status in
                cont.resume(returning: status)
            }
        }
    }
}

