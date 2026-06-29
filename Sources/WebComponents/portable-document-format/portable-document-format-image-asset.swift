import Assets
import CoreGraphics
import Foundation
import ImageIO

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
        guard
            width > 0,
            height > 0,
            let sourceData = asset.data,
            let source = CGImageSourceCreateWithData(sourceData as CFData, nil),
            let image = CGImageSourceCreateImageAtIndex(source, 0, nil)
        else {
            return nil
        }

        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let rgbaCount = width * height * bytesPerPixel
        let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue

        var rgba = [UInt8](
            repeating: 0,
            count: rgbaCount
        )

        let didRender = rgba.withUnsafeMutableBytes { buffer in
            guard let context = CGContext(
                data: buffer.baseAddress,
                width: width,
                height: height,
                bitsPerComponent: 8,
                bytesPerRow: bytesPerRow,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: bitmapInfo
            ) else {
                return false
            }

            context.setFillColor(
                red: CGFloat(background.red) / 255,
                green: CGFloat(background.green) / 255,
                blue: CGFloat(background.blue) / 255,
                alpha: 1
            )

            context.fill(
                CGRect(
                    x: 0,
                    y: 0,
                    width: width,
                    height: height
                )
            )

            context.interpolationQuality = .high
            context.translateBy(
                x: 0,
                y: CGFloat(height)
            )
            context.scaleBy(
                x: 1,
                y: -1
            )

            let scale = min(
                CGFloat(width) / CGFloat(image.width),
                CGFloat(height) / CGFloat(image.height)
            )

            let drawWidth = CGFloat(image.width) * scale
            let drawHeight = CGFloat(image.height) * scale

            let rect = CGRect(
                x: (CGFloat(width) - drawWidth) / 2,
                y: (CGFloat(height) - drawHeight) / 2,
                width: drawWidth,
                height: drawHeight
            )

            context.draw(
                image,
                in: rect
            )

            context.flush()

            return true
        }

        guard didRender else {
            return nil
        }

        var rgb = [UInt8]()
        rgb.reserveCapacity(width * height * 3)

        for index in stride(
            from: 0,
            to: rgbaCount,
            by: bytesPerPixel
        ) {
            rgb.append(rgba[index])
            rgb.append(rgba[index + 1])
            rgb.append(rgba[index + 2])
        }

        return PortableDocumentFormatImage(
            encoding: .rgb8,
            width: width,
            height: height,
            base64: Data(rgb).base64EncodedString()
        )
    }
}
