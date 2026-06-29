enum PortableDocumentFormatRuntimePage {
    static let source = #"""
        class PDFPage {
            constructor(width, height) {
                this.width = width;
                this.height = height;
                this.content = [];
            }

            y(value) {
                return this.height - value;
            }

            text(x, y, value, options = {}) {
                const size = options.size || 11;
                const font = options.bold ? "F2" : "F1";
                const baseline = this.y(y);

                this.content.push(
                    "BT /" + font + " " + pdfNum(size) + " Tf 1 0 0 1 " +
                    pdfNum(x) + " " + pdfNum(baseline) + " Tm " +
                    pdfString(value) + " Tj ET"
                );
            }

            image(name, x, y, width, height) {
                if (!name) return;

                this.content.push(
                    "q " +
                    pdfNum(width) + " 0 0 " + pdfNum(height) + " " +
                    pdfNum(x) + " " + pdfNum(this.y(y + height)) + " cm " +
                    "/" + name + " Do Q"
                );
            }

            line(x1, y1, x2, y2) {
                this.content.push(
                    pdfNum(x1) + " " + pdfNum(this.y(y1)) + " m " +
                    pdfNum(x2) + " " + pdfNum(this.y(y2)) + " l S"
                );
            }

            rect(x, y, width, height, mode = "S") {
                this.content.push(
                    pdfNum(x) + " " + pdfNum(this.y(y + height)) + " " +
                    pdfNum(width) + " " + pdfNum(height) + " re " + mode
                );
            }

            roundRect(x, y, width, height, radius, mode = "S") {
                const r = Math.max(0, Math.min(radius, width / 2, height / 2));

                if (r <= 0) {
                    this.rect(x, y, width, height, mode);
                    return;
                }

                const k = 0.5522847498;
                const left = x;
                const right = x + width;
                const bottom = this.y(y + height);
                const top = this.y(y);

                this.content.push(
                    [
                        pdfNum(left + r), pdfNum(bottom), "m",
                        pdfNum(right - r), pdfNum(bottom), "l",
                        pdfNum(right - r + k * r), pdfNum(bottom),
                        pdfNum(right), pdfNum(bottom + r - k * r),
                        pdfNum(right), pdfNum(bottom + r), "c",
                        pdfNum(right), pdfNum(top - r), "l",
                        pdfNum(right), pdfNum(top - r + k * r),
                        pdfNum(right - r + k * r), pdfNum(top),
                        pdfNum(right - r), pdfNum(top), "c",
                        pdfNum(left + r), pdfNum(top), "l",
                        pdfNum(left + r - k * r), pdfNum(top),
                        pdfNum(left), pdfNum(top - r + k * r),
                        pdfNum(left), pdfNum(top - r), "c",
                        pdfNum(left), pdfNum(bottom + r), "l",
                        pdfNum(left), pdfNum(bottom + r - k * r),
                        pdfNum(left + r - k * r), pdfNum(bottom),
                        pdfNum(left + r), pdfNum(bottom), "c",
                        "h",
                        mode
                    ].join(" ")
                );
            }

            gray(value) {
                this.content.push(
                    pdfNum(value) + " g " + pdfNum(value) + " G"
                );
            }
        }
    """#
}
