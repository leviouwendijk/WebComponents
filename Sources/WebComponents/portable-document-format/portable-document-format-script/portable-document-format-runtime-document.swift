enum PortableDocumentFormatRuntimeDocument {
    static let source = #"""
        class PDFDocument {
            constructor() {
                this.pages = [];
                this.images = [];
            }

            addPage(page) {
                this.pages.push(page);
            }

            addImage(image) {
                if (!image || image.encoding !== "rgb8") {
                    return null;
                }

                const width = Math.max(Math.floor(Number(image.width || 0)), 1);
                const height = Math.max(Math.floor(Number(image.height || 0)), 1);
                const expectedLength = width * height * 3;
                const data = base64ToBinaryString(image.base64).slice(0, expectedLength);

                if (data.length !== expectedLength) {
                    return null;
                }

                const name = "Im" + String(this.images.length + 1);

                this.images.push({
                    name,
                    width,
                    height,
                    data
                });

                return name;
            }

            imageObject(image) {
                return [
                    "<<",
                    "/Type /XObject",
                    "/Subtype /Image",
                    "/Width " + image.width,
                    "/Height " + image.height,
                    "/ColorSpace /DeviceRGB",
                    "/BitsPerComponent 8",
                    "/Length " + image.data.length,
                    ">>",
                    "stream",
                    image.data,
                    "endstream"
                ].join("\n");
            }

            build() {
                const objects = {};
                let nextIdentifier = 1;

                function take(body) {
                    const identifier = nextIdentifier;
                    objects[identifier] = body;
                    nextIdentifier += 1;
                    return identifier;
                }

                const fontRegular = take("<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>");
                const fontBold = take("<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>");
                const pagesIdentifier = take("");

                const imageIdentifiers = new Map();

                for (const image of this.images) {
                    imageIdentifiers.set(
                        image.name,
                        take(this.imageObject(image))
                    );
                }

                const xobjectEntries = Array
                    .from(imageIdentifiers.entries())
                    .map(([name, identifier]) => "/" + name + " " + identifier + " 0 R")
                    .join(" ");

                const resources = [
                    "<<",
                    "/Font << /F1 " + fontRegular + " 0 R /F2 " + fontBold + " 0 R >>"
                ];

                if (xobjectEntries) {
                    resources.push("/XObject << " + xobjectEntries + " >>");
                }

                resources.push(">>");

                const pageIdentifiers = [];

                for (const page of this.pages) {
                    const content = page.content.join("\n");
                    const contentIdentifier = take(
                        [
                            "<< /Length " + content.length + " >>",
                            "stream",
                            content,
                            "endstream"
                        ].join("\n")
                    );

                    const pageIdentifier = take(
                        [
                            "<<",
                            "/Type /Page",
                            "/Parent " + pagesIdentifier + " 0 R",
                            "/MediaBox [0 0 " + pdfNum(page.width) + " " + pdfNum(page.height) + "]",
                            "/Resources " + resources.join("\n"),
                            "/Contents " + contentIdentifier + " 0 R",
                            ">>"
                        ].join("\n")
                    );

                    pageIdentifiers.push(pageIdentifier);
                }

                objects[pagesIdentifier] = [
                    "<<",
                    "/Type /Pages",
                    "/Count " + pageIdentifiers.length,
                    "/Kids [" + pageIdentifiers.map(identifier => identifier + " 0 R").join(" ") + "]",
                    ">>"
                ].join("\n");

                const catalogIdentifier = take(
                    "<< /Type /Catalog /Pages " + pagesIdentifier + " 0 R >>"
                );

                let output = "%PDF-1.4\n";
                const offsets = [0];

                for (let identifier = 1; identifier < nextIdentifier; identifier += 1) {
                    offsets[identifier] = output.length;
                    output += identifier + " 0 obj\n" + objects[identifier] + "\nendobj\n";
                }

                const xrefOffset = output.length;

                output += "xref\n";
                output += "0 " + nextIdentifier + "\n";
                output += "0000000000 65535 f \n";

                for (let identifier = 1; identifier < nextIdentifier; identifier += 1) {
                    output += String(offsets[identifier]).padStart(10, "0") + " 00000 n \n";
                }

                output += [
                    "trailer",
                    "<< /Size " + nextIdentifier + " /Root " + catalogIdentifier + " 0 R >>",
                    "startxref",
                    String(xrefOffset),
                    "%%EOF"
                ].join("\n");

                return bytesFromBinaryString(output);
            }
        }
    """#
}
