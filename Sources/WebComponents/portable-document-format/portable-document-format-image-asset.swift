import Assets
import Compression
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
        let targetWidth = max(width, 1)
        let targetHeight = max(height, 1)

        guard
            let data = asset.data,
            let png = PortableDocumentFormatPNG.decode(data)
        else {
            return nil
        }

        let rgb = png.rgb8(
            width: targetWidth,
            height: targetHeight,
            background: background
        )

        return PortableDocumentFormatImage(
            encoding: .rgb8,
            width: targetWidth,
            height: targetHeight,
            base64: Data(rgb).base64EncodedString()
        )
    }
}

private struct PortableDocumentFormatPNG {
    let width: Int
    let height: Int
    let rgba: [UInt8]

    static func decode(
        _ data: Data
    ) -> Self? {
        Decoder(
            bytes: Array(data)
        ).decode()
    }

    func rgb8(
        width targetWidth: Int,
        height targetHeight: Int,
        background: PortableDocumentFormatRGBColor
    ) -> [UInt8] {
        var out = [UInt8](
            repeating: 0,
            count: targetWidth * targetHeight * 3
        )

        let sourceAspect = Double(width) / Double(height)
        let targetAspect = Double(targetWidth) / Double(targetHeight)

        let drawWidth: Double
        let drawHeight: Double

        if sourceAspect > targetAspect {
            drawWidth = Double(targetWidth)
            drawHeight = Double(targetWidth) / sourceAspect
        } else {
            drawHeight = Double(targetHeight)
            drawWidth = Double(targetHeight) * sourceAspect
        }

        let drawX = (Double(targetWidth) - drawWidth) / 2
        let drawY = (Double(targetHeight) - drawHeight) / 2

        var destination = 0

        for y in 0 ..< targetHeight {
            for x in 0 ..< targetWidth {
                let centerX = Double(x) + 0.5
                let centerY = Double(y) + 0.5

                guard
                    centerX >= drawX,
                    centerX < drawX + drawWidth,
                    centerY >= drawY,
                    centerY < drawY + drawHeight
                else {
                    out[destination] = background.red
                    out[destination + 1] = background.green
                    out[destination + 2] = background.blue
                    destination += 3
                    continue
                }

                let sourceX = ((centerX - drawX) / drawWidth) * Double(width) - 0.5
                let sourceY = ((centerY - drawY) / drawHeight) * Double(height) - 0.5
                let sample = sampleRGBA(
                    x: sourceX,
                    y: sourceY
                )

                let alpha = sample.alpha / 255

                out[destination] = Self.flatten(
                    foreground: sample.red,
                    alpha: alpha,
                    background: Double(background.red)
                )

                out[destination + 1] = Self.flatten(
                    foreground: sample.green,
                    alpha: alpha,
                    background: Double(background.green)
                )

                out[destination + 2] = Self.flatten(
                    foreground: sample.blue,
                    alpha: alpha,
                    background: Double(background.blue)
                )

                destination += 3
            }
        }

        return out
    }

    private func sampleRGBA(
        x rawX: Double,
        y rawY: Double
    ) -> Pixel {
        let clampedX = min(
            max(rawX, 0),
            Double(width - 1)
        )

        let clampedY = min(
            max(rawY, 0),
            Double(height - 1)
        )

        let x0 = Int(clampedX.rounded(.down))
        let y0 = Int(clampedY.rounded(.down))
        let x1 = min(x0 + 1, width - 1)
        let y1 = min(y0 + 1, height - 1)

        let tx = clampedX - Double(x0)
        let ty = clampedY - Double(y0)

        return Pixel(
            red: interpolate(
                channel: 0,
                x0: x0,
                y0: y0,
                x1: x1,
                y1: y1,
                tx: tx,
                ty: ty
            ),
            green: interpolate(
                channel: 1,
                x0: x0,
                y0: y0,
                x1: x1,
                y1: y1,
                tx: tx,
                ty: ty
            ),
            blue: interpolate(
                channel: 2,
                x0: x0,
                y0: y0,
                x1: x1,
                y1: y1,
                tx: tx,
                ty: ty
            ),
            alpha: interpolate(
                channel: 3,
                x0: x0,
                y0: y0,
                x1: x1,
                y1: y1,
                tx: tx,
                ty: ty
            )
        )
    }

    private func interpolate(
        channel: Int,
        x0: Int,
        y0: Int,
        x1: Int,
        y1: Int,
        tx: Double,
        ty: Double
    ) -> Double {
        let top = value(
            x: x0,
            y: y0,
            channel: channel
        ) * (1 - tx) + value(
            x: x1,
            y: y0,
            channel: channel
        ) * tx

        let bottom = value(
            x: x0,
            y: y1,
            channel: channel
        ) * (1 - tx) + value(
            x: x1,
            y: y1,
            channel: channel
        ) * tx

        return top * (1 - ty) + bottom * ty
    }

    private func value(
        x: Int,
        y: Int,
        channel: Int
    ) -> Double {
        Double(
            rgba[(y * width + x) * 4 + channel]
        )
    }

    private static func flatten(
        foreground: Double,
        alpha: Double,
        background: Double
    ) -> UInt8 {
        UInt8(
            clamping: Int(
                (foreground * alpha + background * (1 - alpha)).rounded()
            )
        )
    }

    private struct Pixel {
        let red: Double
        let green: Double
        let blue: Double
        let alpha: Double
    }
}

private extension PortableDocumentFormatPNG {
    struct Decoder {
        let bytes: [UInt8]

        private static let signature: [UInt8] = [
            137,
            80,
            78,
            71,
            13,
            10,
            26,
            10
        ]

        func decode() -> PortableDocumentFormatPNG? {
            guard
                bytes.count >= Self.signature.count,
                Array(bytes[0 ..< Self.signature.count]) == Self.signature
            else {
                return nil
            }

            var offset = Self.signature.count
            var width: Int?
            var height: Int?
            var bitDepth: UInt8?
            var colorType: UInt8?
            var interlaceMethod: UInt8?
            var compressed: [UInt8] = []
            var palette: [UInt8] = []
            var transparency: [UInt8] = []

            while offset + 12 <= bytes.count {
                let length = Int(
                    readUInt32(
                        at: offset
                    )
                )

                offset += 4

                guard offset + 4 <= bytes.count else {
                    return nil
                }

                let type = String(
                    bytes: bytes[offset ..< offset + 4],
                    encoding: .ascii
                )

                offset += 4

                guard
                    let type,
                    length >= 0,
                    offset + length + 4 <= bytes.count
                else {
                    return nil
                }

                let chunkStart = offset
                let chunkEnd = offset + length

                switch type {
                case "IHDR":
                    guard length == 13 else {
                        return nil
                    }

                    width = Int(
                        readUInt32(
                            at: chunkStart
                        )
                    )

                    height = Int(
                        readUInt32(
                            at: chunkStart + 4
                        )
                    )

                    bitDepth = bytes[chunkStart + 8]
                    colorType = bytes[chunkStart + 9]
                    interlaceMethod = bytes[chunkStart + 12]

                case "PLTE":
                    palette.append(
                        contentsOf: bytes[chunkStart ..< chunkEnd]
                    )

                case "tRNS":
                    transparency.append(
                        contentsOf: bytes[chunkStart ..< chunkEnd]
                    )

                case "IDAT":
                    compressed.append(
                        contentsOf: bytes[chunkStart ..< chunkEnd]
                    )

                case "IEND":
                    offset = bytes.count

                default:
                    break
                }

                offset = chunkEnd + 4
            }

            guard
                let width,
                let height,
                let bitDepth,
                let colorType,
                let interlaceMethod,
                width > 0,
                height > 0,
                bitDepth == 8,
                interlaceMethod == 0,
                let bytesPerPixel = bytesPerPixel(
                    colorType: colorType
                )
            else {
                return nil
            }

            let rowBytes = width * bytesPerPixel
            let expectedInflatedSize = height * (rowBytes + 1)

            guard
                let inflated = inflate(
                    compressed,
                    expectedSize: expectedInflatedSize
                ),
                let unfiltered = unfilter(
                    inflated,
                    width: width,
                    height: height,
                    rowBytes: rowBytes,
                    bytesPerPixel: bytesPerPixel
                ),
                let rgba = rgba(
                    unfiltered,
                    width: width,
                    height: height,
                    colorType: colorType,
                    palette: palette,
                    transparency: transparency
                )
            else {
                return nil
            }

            return PortableDocumentFormatPNG(
                width: width,
                height: height,
                rgba: rgba
            )
        }

        private func readUInt32(
            at offset: Int
        ) -> UInt32 {
            UInt32(bytes[offset]) << 24
                | UInt32(bytes[offset + 1]) << 16
                | UInt32(bytes[offset + 2]) << 8
                | UInt32(bytes[offset + 3])
        }

        private func bytesPerPixel(
            colorType: UInt8
        ) -> Int? {
            switch colorType {
            case 0:
                return 1

            case 2:
                return 3

            case 3:
                return 1

            case 4:
                return 2

            case 6:
                return 4

            default:
                return nil
            }
        }

        private func inflate(
            _ compressed: [UInt8],
            expectedSize: Int
        ) -> [UInt8]? {
            guard
                expectedSize > 0,
                !compressed.isEmpty
            else {
                return nil
            }

            func decoded(
                _ sourceBytes: [UInt8]
            ) -> [UInt8]? {
                guard !sourceBytes.isEmpty else {
                    return nil
                }

                var fixedOutput = [UInt8](
                    repeating: 0,
                    count: expectedSize
                )

                let fixedDecoded = fixedOutput.withUnsafeMutableBufferPointer { destination in
                    sourceBytes.withUnsafeBufferPointer { source in
                        guard
                            let destinationBase = destination.baseAddress,
                            let sourceBase = source.baseAddress
                        else {
                            return 0
                        }

                        return compression_decode_buffer(
                            destinationBase,
                            expectedSize,
                            sourceBase,
                            sourceBytes.count,
                            nil,
                            COMPRESSION_ZLIB
                        )
                    }
                }

                if fixedDecoded == expectedSize {
                    return fixedOutput
                }

                let dummyDestination = UnsafeMutablePointer<UInt8>.allocate(
                    capacity: 1
                )

                let dummySource = UnsafeMutablePointer<UInt8>.allocate(
                    capacity: 1
                )

                defer {
                    dummyDestination.deallocate()
                    dummySource.deallocate()
                }

                var stream = compression_stream(
                    dst_ptr: dummyDestination,
                    dst_size: 0,
                    src_ptr: UnsafePointer(dummySource),
                    src_size: 0,
                    state: nil
                )

                let initStatus = compression_stream_init(
                    &stream,
                    COMPRESSION_STREAM_DECODE,
                    COMPRESSION_ZLIB
                )

                guard initStatus != COMPRESSION_STATUS_ERROR else {
                    return nil
                }

                defer {
                    compression_stream_destroy(&stream)
                }

                return sourceBytes.withUnsafeBufferPointer { source -> [UInt8]? in
                    guard let sourceBase = source.baseAddress else {
                        return nil
                    }

                    stream.src_ptr = sourceBase
                    stream.src_size = source.count

                    let chunkSize = 64 * 1024

                    var output: [UInt8] = []
                    output.reserveCapacity(expectedSize)

                    var chunk = [UInt8](
                        repeating: 0,
                        count: chunkSize
                    )

                    while true {
                        let status = chunk.withUnsafeMutableBufferPointer { destination -> compression_status in
                            guard let destinationBase = destination.baseAddress else {
                                return COMPRESSION_STATUS_ERROR
                            }

                            stream.dst_ptr = destinationBase
                            stream.dst_size = chunkSize

                            return compression_stream_process(
                                &stream,
                                Int32(COMPRESSION_STREAM_FINALIZE.rawValue)
                            )
                        }

                        let produced = chunkSize - stream.dst_size

                        if produced > 0 {
                            output.append(
                                contentsOf: chunk[0 ..< produced]
                            )

                            if output.count > expectedSize {
                                return nil
                            }
                        }

                        switch status {
                        case COMPRESSION_STATUS_OK:
                            if produced == 0 && stream.src_size == 0 {
                                return nil
                            }

                        case COMPRESSION_STATUS_END:
                            guard output.count == expectedSize else {
                                return nil
                            }

                            return output

                        default:
                            return nil
                        }
                    }
                }
            }

            func zlibDeflatePayload(
                _ bytes: [UInt8]
            ) -> [UInt8]? {
                guard bytes.count > 6 else {
                    return nil
                }

                let compressionMethodAndFlags = bytes[0]
                let flags = bytes[1]

                let compressionMethod = compressionMethodAndFlags & 0x0F
                let header = Int(compressionMethodAndFlags) << 8 | Int(flags)

                guard
                    compressionMethod == 8,
                    header % 31 == 0
                else {
                    return nil
                }

                return Array(
                    bytes.dropFirst(2).dropLast(4)
                )
            }

            if let output = decoded(compressed) {
                return output
            }

            guard let deflatePayload = zlibDeflatePayload(compressed) else {
                return nil
            }

            return decoded(deflatePayload)
        }

        private func unfilter(
            _ inflated: [UInt8],
            width: Int,
            height: Int,
            rowBytes: Int,
            bytesPerPixel: Int
        ) -> [UInt8]? {
            let scanlineBytes = rowBytes + 1

            guard inflated.count == height * scanlineBytes else {
                return nil
            }

            var output = [UInt8](
                repeating: 0,
                count: height * rowBytes
            )

            for row in 0 ..< height {
                let filter = inflated[row * scanlineBytes]
                let sourceStart = row * scanlineBytes + 1
                let destinationStart = row * rowBytes
                let previousStart = row == 0 ? nil : (row - 1) * rowBytes

                for index in 0 ..< rowBytes {
                    let raw = inflated[sourceStart + index]

                    let left = index >= bytesPerPixel
                        ? output[destinationStart + index - bytesPerPixel]
                        : 0

                    let up = previousStart.map {
                        output[$0 + index]
                    } ?? 0

                    let upLeft = previousStart.flatMap {
                        index >= bytesPerPixel
                            ? output[$0 + index - bytesPerPixel]
                            : nil
                    } ?? 0

                    let predictor: UInt8

                    switch filter {
                    case 0:
                        predictor = 0

                    case 1:
                        predictor = left

                    case 2:
                        predictor = up

                    case 3:
                        predictor = UInt8(
                            (Int(left) + Int(up)) / 2
                        )

                    case 4:
                        predictor = paeth(
                            left,
                            up,
                            upLeft
                        )

                    default:
                        return nil
                    }

                    output[destinationStart + index] = raw &+ predictor
                }
            }

            return output
        }

        private func paeth(
            _ left: UInt8,
            _ up: UInt8,
            _ upLeft: UInt8
        ) -> UInt8 {
            let a = Int(left)
            let b = Int(up)
            let c = Int(upLeft)
            let p = a + b - c
            let pa = abs(p - a)
            let pb = abs(p - b)
            let pc = abs(p - c)

            if pa <= pb && pa <= pc {
                return left
            }

            if pb <= pc {
                return up
            }

            return upLeft
        }

        private func rgba(
            _ unfiltered: [UInt8],
            width: Int,
            height: Int,
            colorType: UInt8,
            palette: [UInt8],
            transparency: [UInt8]
        ) -> [UInt8]? {
            var output = [UInt8](
                repeating: 0,
                count: width * height * 4
            )

            var source = 0
            var destination = 0

            for _ in 0 ..< width * height {
                switch colorType {
                case 0:
                    let gray = unfiltered[source]
                    let alpha = transparency.first == gray ? UInt8(0) : UInt8(255)

                    output[destination] = gray
                    output[destination + 1] = gray
                    output[destination + 2] = gray
                    output[destination + 3] = alpha

                    source += 1

                case 2:
                    let red = unfiltered[source]
                    let green = unfiltered[source + 1]
                    let blue = unfiltered[source + 2]

                    output[destination] = red
                    output[destination + 1] = green
                    output[destination + 2] = blue
                    output[destination + 3] = 255

                    source += 3

                case 3:
                    let index = Int(unfiltered[source])
                    let paletteIndex = index * 3

                    guard paletteIndex + 2 < palette.count else {
                        return nil
                    }

                    output[destination] = palette[paletteIndex]
                    output[destination + 1] = palette[paletteIndex + 1]
                    output[destination + 2] = palette[paletteIndex + 2]
                    output[destination + 3] = index < transparency.count
                        ? transparency[index]
                        : 255

                    source += 1

                case 4:
                    let gray = unfiltered[source]
                    let alpha = unfiltered[source + 1]

                    output[destination] = gray
                    output[destination + 1] = gray
                    output[destination + 2] = gray
                    output[destination + 3] = alpha

                    source += 2

                case 6:
                    output[destination] = unfiltered[source]
                    output[destination + 1] = unfiltered[source + 1]
                    output[destination + 2] = unfiltered[source + 2]
                    output[destination + 3] = unfiltered[source + 3]

                    source += 4

                default:
                    return nil
                }

                destination += 4
            }

            return output
        }
    }
}
