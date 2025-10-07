import SwiftUI

struct WatchPreview: View {
    let model: WatchModel
    let userImage: UIImage?
    let placeholder: Color

    var body: some View {
        GeometryReader { geo in
            let base   = model.screenRect(in: geo.size)
            let screen = base.insetBy(dx: base.width  * model.safetyInsetPercent,
                                      dy: base.height * model.safetyInsetPercent)
            let corner = model.cornerRadius(for: screen)

            ZStack {
                Group {
                    if let img = userImage {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(width: screen.width, height: screen.height)
                            .clipped()
                    } else {
                        placeholder
                            .frame(width: screen.width, height: screen.height)
                    }
                }
                .mask(RoundedRectangle(cornerRadius: corner, style: .continuous))
                .position(x: screen.midX, y: screen.midY)

                Image(model.overlayImageName)
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .aspectRatio(model.overlayAspect, contentMode: .fit)
    }
}


