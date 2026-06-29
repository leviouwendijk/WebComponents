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
        autoreleasepool {
            let targetWidth = max(width, 1)
            let targetHeight = max(height, 1)

            guard let sourceData = asset.data else {
                return nil
            }

            let sourceOptions = [
                kCGImageSourceShouldCache: false
            ] as CFDictionary

            guard let source = CGImageSourceCreateWithData(
                sourceData as CFData,
                sourceOptions
            ) else {
                return nil
            }

            let thumbnailOptions = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceShouldCacheImmediately: true,
                kCGImageSourceThumbnailMaxPixelSize: max(targetWidth, targetHeight)
            ] as CFDictionary

            let thumbnail = CGImageSourceCreateThumbnailAtIndex(
                source,
                0,
                thumbnailOptions
            )

            let fallback = CGImageSourceCreateImageAtIndex(
                source,
                0,
                sourceOptions
            )

            guard let image = thumbnail ?? fallback else {
                return nil
            }

            let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)
                ?? CGColorSpaceCreateDeviceRGB()

            let bytesPerPixel = 4
            let bytesPerRow = targetWidth * bytesPerPixel
            let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue
                | CGImageAlphaInfo.premultipliedLast.rawValue

            guard let context = CGContext(
                data: nil,
                width: targetWidth,
                height: targetHeight,
                bitsPerComponent: 8,
                bytesPerRow: bytesPerRow,
                space: colorSpace,
                bitmapInfo: bitmapInfo
            ) else {
                return nil
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
                    width: targetWidth,
                    height: targetHeight
                )
            )

            context.interpolationQuality = .high

            context.translateBy(
                x: 0,
                y: CGFloat(targetHeight)
            )

            context.scaleBy(
                x: 1,
                y: -1
            )

            let scale = min(
                CGFloat(targetWidth) / CGFloat(image.width),
                CGFloat(targetHeight) / CGFloat(image.height)
            )

            let drawWidth = CGFloat(image.width) * scale
            let drawHeight = CGFloat(image.height) * scale

            let drawRect = CGRect(
                x: (CGFloat(targetWidth) - drawWidth) / 2,
                y: (CGFloat(targetHeight) - drawHeight) / 2,
                width: drawWidth,
                height: drawHeight
            )

            context.draw(
                image,
                in: drawRect
            )

            context.flush()

            guard let data = context.data else {
                return nil
            }

            let sourceBytes = data.assumingMemoryBound(to: UInt8.self)
            let sourceBytesPerRow = context.bytesPerRow

            var rgb = [UInt8](
                repeating: 0,
                count: targetWidth * targetHeight * 3
            )

            var destinationIndex = 0

            for row in 0 ..< targetHeight {
                let rowStart = row * sourceBytesPerRow

                for column in 0 ..< targetWidth {
                    let sourceIndex = rowStart + column * bytesPerPixel

                    rgb[destinationIndex] = sourceBytes[sourceIndex]
                    rgb[destinationIndex + 1] = sourceBytes[sourceIndex + 1]
                    rgb[destinationIndex + 2] = sourceBytes[sourceIndex + 2]

                    destinationIndex += 3
                }
            }

            return PortableDocumentFormatImage(
                encoding: .rgb8,
                width: targetWidth,
                height: targetHeight,
                base64: Data(rgb).base64EncodedString()
            )
        }
    }
}
