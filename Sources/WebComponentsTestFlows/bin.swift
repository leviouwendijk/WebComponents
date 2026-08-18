import Assets
import Foundation
import TestFlows
import WebComponents

@main
enum WebComponentsFlowTestMain {
    static func main() async {
        await TestFlowCLI.run(
            suite: WebComponentsFlowSuite.self
        )
    }
}

enum WebComponentsFlowSuite: TestFlowRegistry {
    static let title = "WebComponents flows"

    static let flows: [TestFlow] =
        WebComponentsPDFImageFlowSuite.flows
        + LegalDocumentFlowSuite.flows
}

enum WebComponentsPDFImageFlowSuite: TestFlowRegistry {
    static let title = "WebComponents PDF image flows"

    static let flows: [TestFlow] = [
        TestFlow(
            "hondenmeesters-logomark-rgb8",
            title: "Hondenmeesters logomark converts to PDF RGB8",
            tags: [
                "pdf",
                "image",
                "rgb8",
                "assets"
            ]
        ) {
            let asset = HondenmeestersAssets.h_logomark

            let image = PortableDocumentFormatImage.rgb8(
                asset,
                // width: 64,
                // height: 64
                width: 192,
                height: 192
            )

            let snapshot = RGB8AssetSnapshot.describe(
                asset: asset,
                image: image
            )

            try Expect.snapshot(
                snapshot,
                named: "hondenmeesters-logomark-rgb8"
            )

            guard let image else {
                throw TestFlowAssertionFailure(
                    label: "rgb8",
                    message: "conversion returned nil",
                    diagnostics: [
                        .field(
                            "snapshot",
                            TestFlowSnapshot.url(
                                named: "hondenmeesters-logomark-rgb8"
                            ).path
                        )
                    ]
                )
            }

            try Expect.equal(
                image.encoding.rawValue,
                "rgb8",
                "encoding"
            )

            try Expect.equal(
                image.width,
                // 64,
                192,
                "width"
            )

            try Expect.equal(
                image.height,
                // 64,
                192,
                "height"
            )

            let decoded = try Expect.notNil(
                Data(
                    base64Encoded: image.base64
                ),
                "base64"
            )

            try Expect.equal(
                decoded.count,
                // 64 * 64 * 3,
                192 * 192 * 3,
                "rgb8 byte count"
            )

            return [
                .field(
                    "encoding",
                    image.encoding.rawValue
                ),
                .field(
                    "size",
                    "\(image.width)x\(image.height)"
                ),
                .field(
                    "bytes",
                    "\(decoded.count)"
                ),
                .field(
                    "base64",
                    "\(image.base64.count)"
                )
            ]
        }
    ]
}

private enum RGB8AssetSnapshot {
    static func describe(
        asset: ImageAsset,
        image: PortableDocumentFormatImage?
    ) -> String {
        let compact = asset.base64.compact
        let data = asset.data
        let bytes = data.map(Array.init) ?? []
        let ihdr = pngIHDR(bytes)
        let chunks = pngChunks(bytes)

        return [
            "asset.identifier: \(asset.identifier.value)",
            "asset.filetype: \(asset.filetype)",
            "asset.base64.compact.count: \(compact.count)",
            "asset.data.count: \(data?.count.description ?? "nil")",
            "png.signature: \(hasPNGSignature(bytes) ? "ok" : "missing")",
            "",
            "png.ihdr.width: \(ihdr?.width.description ?? "nil")",
            "png.ihdr.height: \(ihdr?.height.description ?? "nil")",
            "png.ihdr.bitDepth: \(ihdr?.bitDepth.description ?? "nil")",
            "png.ihdr.colorType: \(ihdr?.colorType.description ?? "nil")",
            "png.ihdr.compression: \(ihdr?.compression.description ?? "nil")",
            "png.ihdr.filter: \(ihdr?.filter.description ?? "nil")",
            "png.ihdr.interlace: \(ihdr?.interlace.description ?? "nil")",
            "",
            "png.chunks:",
            chunks
                .map { "  \($0.type) \($0.length)" }
                .joined(separator: "\n"),
            "",
            "rgb8.result: \(image == nil ? "nil" : "ok")",
            "rgb8.encoding: \(image?.encoding.rawValue ?? "nil")",
            "rgb8.width: \(image?.width.description ?? "nil")",
            "rgb8.height: \(image?.height.description ?? "nil")",
            "rgb8.base64.count: \(image?.base64.count.description ?? "nil")",
            // "rgb8.bytes.expected: \(64 * 64 * 3)",
            "rgb8.bytes.expected: \(192 * 192 * 3)",
            "rgb8.bytes.actual: \(image.flatMap { Data(base64Encoded: $0.base64)?.count }.map(String.init) ?? "nil")"
        ].joined(separator: "\n")
    }

    private static func hasPNGSignature(
        _ bytes: [UInt8]
    ) -> Bool {
        bytes.prefix(8).elementsEqual([
            137,
            80,
            78,
            71,
            13,
            10,
            26,
            10
        ])
    }

    private static func pngIHDR(
        _ bytes: [UInt8]
    ) -> IHDR? {
        guard
            hasPNGSignature(bytes),
            bytes.count >= 33,
            string(
                bytes,
                start: 12,
                count: 4
            ) == "IHDR"
        else {
            return nil
        }

        return IHDR(
            width: Int(readUInt32(bytes, at: 16)),
            height: Int(readUInt32(bytes, at: 20)),
            bitDepth: bytes[24],
            colorType: bytes[25],
            compression: bytes[26],
            filter: bytes[27],
            interlace: bytes[28]
        )
    }

    private static func pngChunks(
        _ bytes: [UInt8]
    ) -> [Chunk] {
        guard hasPNGSignature(bytes) else {
            return []
        }

        var result: [Chunk] = []
        var offset = 8

        while offset + 12 <= bytes.count {
            let length = Int(
                readUInt32(
                    bytes,
                    at: offset
                )
            )

            let type = string(
                bytes,
                start: offset + 4,
                count: 4
            ) ?? "????"

            result.append(
                Chunk(
                    type: type,
                    length: length
                )
            )

            offset += 12 + length

            if type == "IEND" {
                break
            }
        }

        return result
    }

    private static func readUInt32(
        _ bytes: [UInt8],
        at offset: Int
    ) -> UInt32 {
        guard offset + 3 < bytes.count else {
            return 0
        }

        return UInt32(bytes[offset]) << 24
            | UInt32(bytes[offset + 1]) << 16
            | UInt32(bytes[offset + 2]) << 8
            | UInt32(bytes[offset + 3])
    }

    private static func string(
        _ bytes: [UInt8],
        start: Int,
        count: Int
    ) -> String? {
        guard start + count <= bytes.count else {
            return nil
        }

        return String(
            bytes: bytes[start ..< start + count],
            encoding: .ascii
        )
    }

    private struct IHDR {
        let width: Int
        let height: Int
        let bitDepth: UInt8
        let colorType: UInt8
        let compression: UInt8
        let filter: UInt8
        let interlace: UInt8
    }

    private struct Chunk {
        let type: String
        let length: Int
    }
}
