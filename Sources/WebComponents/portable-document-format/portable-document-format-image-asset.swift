import Assets
import Foundation

public struct PortableDocumentFormatRGBColor: Sendable, Codable, Hashable {
    public let red: UInt8
    public let green: UInt8
    public let blue: UInt8

    public init(
        red: UInt8,
        green: UInt8,
        blue: UInt8
    ) {
        self.red = red
        self.green = green
        self.blue = blue
    }

    public static let white = Self(
        red: 255,
        green: 255,
        blue: 255
    )
}

public extension PortableDocumentFormatImage {
    static func rgb8(
        _ asset: ImageAsset,
        width: Int,
        height: Int,
        background: PortableDocumentFormatRGBColor = .white
    ) -> Self? {
        nil
    }
}
