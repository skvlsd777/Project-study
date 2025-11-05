import SwiftUI
import Kingfisher

// MARK: - Модель композиции циферблата
struct Composition: Equatable {
    var background: Background
    var numerals: NumeralsStyle? = nil
    var hands: HandsStyle = .classic
}

enum Background: Equatable {
    case color(Color)
    case asset(String)
    case url(URL)
}

struct NumeralsStyle: Equatable {
    var showMarks: Bool = true
    var color: Color = .white.opacity(0.9)
}

struct HandsStyle: Equatable {
    var hourWidth: CGFloat = 6
    var minuteWidth: CGFloat = 4
    var secondWidth: CGFloat = 2
    var color: Color = .white
    var showSecond: Bool = true

    static let classic = HandsStyle()
}

// MARK: - Универсальный холст
struct WatchCanvasView: View {
    let composition: Composition
    var animated: Bool = false

    var body: some View {
        ZStack {
            BackgroundLayer(composition: composition)
            if let numerals = composition.numerals {
                NumeralsLayer(style: numerals)
            }
            if animated {
                TimelineView(.animation) { ctx in
                    HandsLayer(style: composition.hands, date: ctx.date)
                }
            } else {
                HandsLayer(style: composition.hands, date: Self.displayTime)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .drawingGroup(opaque: true)
    }

    private static let displayTime =
        Calendar.current.date(from: DateComponents(hour: 10, minute: 10))!
}

// MARK: - Слои
private struct BackgroundLayer: View {
    let composition: Composition
    var body: some View {
        switch composition.background {
        case .color(let c):
            c
        case .asset(let name):
            Image(name)
                .resizable()
                .scaledToFill()
        case .url(let url):
            KFImage(url)
                .placeholder { Color.black.opacity(0.1) }
                .resizable()
                .scaledToFill()
        }
    }
}

private struct NumeralsLayer: View {
    let style: NumeralsStyle
    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            ZStack {
                if style.showMarks {
                    ForEach(0..<60, id: \.self) { tick in
                        Rectangle()
                            .fill(style.color.opacity(tick % 5 == 0 ? 1 : 0.5))
                            .frame(width: tick % 5 == 0 ? 3 : 1,
                                   height: tick % 5 == 0 ? size*0.06 : size*0.03)
                            .offset(y: -size*0.45)
                            .rotationEffect(.degrees(Double(tick) * 6))
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

private struct HandsLayer: View {
    let style: HandsStyle
    let date: Date

    var body: some View {
        GeometryReader { geo in
            let s = min(geo.size.width, geo.size.height)
            let cal = Calendar.current
            let sec = Double(cal.component(.second, from: date))
            let min = Double(cal.component(.minute, from: date)) + sec/60
            let hour = Double(cal.component(.hour, from: date) % 12) + min/60

            ZStack {
                Capsule()
                    .fill(style.color)
                    .frame(width: style.hourWidth, height: s*0.28)
                    .offset(y: -s*0.14)
                    .rotationEffect(.degrees(hour * 30))

                Capsule()
                    .fill(style.color)
                    .frame(width: style.minuteWidth, height: s*0.38)
                    .offset(y: -s*0.19)
                    .rotationEffect(.degrees(min * 6))

                if style.showSecond {
                    Capsule()
                        .fill(style.color.opacity(0.9))
                        .frame(width: style.secondWidth, height: s*0.42)
                        .offset(y: -s*0.21)
                        .rotationEffect(.degrees(sec * 6))
                }

                Circle().fill(style.color).frame(width: 8, height: 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

