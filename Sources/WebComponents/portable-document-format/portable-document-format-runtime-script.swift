import Constructors
import JS

public struct PortableDocumentFormatRuntimeScript: ReusableComponent {
    public init() {}

    public var nodes: ReusableComponentNodes {
        .init(
            scripts: [
                JSSource(Self.source).as_inline_script()
            ]
        )
    }

    private static let source = #"""
    (() => {
        if (window.PortableDocumentFormatRuntime?.initialized) return;

        const A4 = {
            width: 595.28,
            height: 841.89
        };

        const themes = {
            standard: {
                page: A4,
                margin: 54,
                titleSize: 22,
                subtitleSize: 12,
                headingSize: 15,
                bodySize: 11,
                smallSize: 9,
                lineHeight: 15,
                gap: 10
            },
            hondenmeesters: {
                page: A4,
                margin: 54,
                titleSize: 22,
                subtitleSize: 12,
                headingSize: 15,
                bodySize: 11,
                smallSize: 9,
                lineHeight: 15,
                gap: 10
            }
        };

        function cleanText(value) {
            return String(value ?? "")
                .replace(/[\u2018\u2019]/g, "'")
                .replace(/[\u201C\u201D]/g, '"')
                .replace(/[\u2013\u2014\u2212]/g, "-")
                .replace(/\u2192/g, "->")
                .replace(/\u2026/g, "...");
        }

        function winAnsi(value) {
            return Array
                .from(cleanText(value))
                .map(ch => ch.charCodeAt(0) <= 255 ? ch : "?")
                .join("");
        }

        function pdfNum(value) {
            return Number(value).toFixed(2).replace(/\.00$/, "");
        }

        function pdfString(value) {
            return "(" + winAnsi(value)
                .replace(/\\/g, "\\\\")
                .replace(/\(/g, "\\(")
                .replace(/\)/g, "\\)")
                .replace(/\r/g, "\\r")
                .replace(/\n/g, "\\n") + ")";
        }

        function bytesFromBinaryString(value) {
            const bytes = new Uint8Array(value.length);

            for (let index = 0; index < value.length; index += 1) {
                bytes[index] = value.charCodeAt(index) & 255;
            }

            return bytes;
        }

        function download(bytes, filename) {
            const blob = new Blob(
                [bytes],
                {
                    type: "application/pdf"
                }
            );

            const url = URL.createObjectURL(blob);
            const anchor = document.createElement("a");

            anchor.href = url;
            anchor.download = filename || "document.pdf";
            document.body.appendChild(anchor);
            anchor.click();
            anchor.remove();

            setTimeout(() => {
                URL.revokeObjectURL(url);
            }, 1000);
        }

        function mergeTheme(base, override) {
            if (!override || typeof override !== "object") {
                return base;
            }

            return {
                ...base,
                ...override,
                page: {
                    ...base.page,
                    ...(override.page || {})
                }
            };
        }

        function resolvedTheme(payload) {
            const base = themes[payload.theme] || themes.standard;

            return mergeTheme(
                base,
                payload.layout || payload.theme_settings || null
            );
        }

        class PDFDocument {
            constructor() {
                this.pages = [];
            }

            addPage(page) {
                this.pages.push(page);
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
                            "/Resources <<",
                            "    /Font << /F1 " + fontRegular + " 0 R /F2 " + fontBold + " 0 R >>",
                            ">>",
                            "/Contents " + contentIdentifier + " 0 R",
                            ">>"
                        ].join("\n")
                    );

                    pageIdentifiers.push(pageIdentifier);
                }

                objects[pagesIdentifier] = [
                    "<<",
                    "/Type /Pages",
                    "/Kids [" + pageIdentifiers.map(id => id + " 0 R").join(" ") + "]",
                    "/Count " + pageIdentifiers.length,
                    ">>"
                ].join("\n");

                const catalogIdentifier = take(
                    [
                        "<<",
                        "/Type /Catalog",
                        "/Pages " + pagesIdentifier + " 0 R",
                        ">>"
                    ].join("\n")
                );

                let output = "%PDF-1.4\n";
                const offsets = [0];

                for (let identifier = 1; identifier < nextIdentifier; identifier += 1) {
                    offsets[identifier] = output.length;
                    output += identifier + " 0 obj\n";
                    output += objects[identifier] + "\n";
                    output += "endobj\n";
                }

                const xrefOffset = output.length;

                output += "xref\n";
                output += "0 " + nextIdentifier + "\n";
                output += "0000000000 65535 f \n";

                for (let identifier = 1; identifier < nextIdentifier; identifier += 1) {
                    output += String(offsets[identifier]).padStart(10, "0") + " 00000 n \n";
                }

                output += "trailer\n";
                output += "<< /Size " + nextIdentifier + " /Root " + catalogIdentifier + " 0 R >>\n";
                output += "startxref\n";
                output += xrefOffset + "\n";
                output += "%%EOF\n";

                return bytesFromBinaryString(output);
            }
        }

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

            gray(value) {
                this.content.push(
                    pdfNum(value) + " g " + pdfNum(value) + " G"
                );
            }
        }

        function textWidth(value, size) {
            return winAnsi(value).length * size * 0.52;
        }

        function wrapText(value, size, width) {
            const words = cleanText(value).split(/\s+/).filter(Boolean);
            const lines = [];
            let line = "";

            for (const word of words) {
                const next = line ? line + " " + word : word;

                if (textWidth(next, size) <= width || !line) {
                    line = next;
                } else {
                    lines.push(line);
                    line = word;
                }
            }

            if (line) {
                lines.push(line);
            }

            return lines;
        }

        class Layout {
            constructor(payload) {
                this.payload = payload || {};
                this.theme = resolvedTheme(this.payload);
                this.document = new PDFDocument();
                this.page = null;
                this.pageNumber = 0;
                this.cursor = this.theme.margin;
                this.newPage();
            }

            newPage() {
                if (this.page) {
                    this.footer();
                    this.document.addPage(this.page);
                }

                this.pageNumber += 1;
                this.page = new PDFPage(
                    this.theme.page.width,
                    this.theme.page.height
                );
                this.cursor = this.theme.margin;
            }

            footer() {
                const y = this.page.height - this.theme.margin + 18;

                this.page.gray(0.75);
                this.page.line(
                    this.theme.margin,
                    y - 16,
                    this.page.width - this.theme.margin,
                    y - 16
                );
                this.page.text(
                    this.theme.margin,
                    y,
                    "Page " + this.pageNumber,
                    {
                        size: this.theme.smallSize
                    }
                );
                this.page.gray(0);
            }

            ensure(height) {
                const bottom = this.page.height - this.theme.margin - 34;

                if (this.cursor + height > bottom) {
                    this.newPage();
                }
            }

            advance(amount) {
                this.cursor += amount;
            }

            render() {
                if (this.payload.sheet) {
                    this.sheetTemplate(this.payload.sheet);
                } else {
                    this.title();

                    for (const block of this.payload.blocks || []) {
                        this.block(block);
                    }
                }

                this.footer();
                this.document.addPage(this.page);

                return this.document.build();
            }

            title() {
                this.ensure(70);

                this.page.text(
                    this.theme.margin,
                    this.cursor,
                    this.payload.title || "Document",
                    {
                        size: this.theme.titleSize,
                        bold: true
                    }
                );

                this.advance(this.theme.titleSize + 14);

                if (this.payload.subtitle) {
                    this.wrapped(
                        this.payload.subtitle,
                        this.theme.subtitleSize,
                        false
                    );
                    this.advance(6);
                }

                this.page.gray(0.82);
                this.page.line(
                    this.theme.margin,
                    this.cursor,
                    this.page.width - this.theme.margin,
                    this.cursor
                );
                this.page.gray(0);

                this.advance(22);
            }

            sheetTemplate(sheet) {
                this.sheetHeader(sheet);

                if (this.payload.blocks?.length) {
                    this.advance(4);

                    for (const block of this.payload.blocks) {
                        this.block(block);
                    }

                    this.rule();
                }

                this.fieldList(sheet.fields || []);
            }

            sheetHeader(sheet) {
                this.ensure(92);

                this.page.text(
                    this.theme.margin,
                    this.cursor,
                    sheet.kicker || "PDF",
                    {
                        size: this.theme.smallSize,
                        bold: true
                    }
                );

                this.advance(16);

                this.page.text(
                    this.theme.margin,
                    this.cursor,
                    this.payload.title || "Document",
                    {
                        size: this.theme.titleSize,
                        bold: true
                    }
                );

                this.advance(this.theme.titleSize + 12);

                const lead = this.payload.subtitle
                    ? this.payload.subtitle + ". " + (sheet.lead || "")
                    : sheet.lead || "";

                if (lead) {
                    this.wrapped(
                        lead,
                        this.theme.subtitleSize,
                        false
                    );
                    this.advance(4);
                }

                this.page.gray(0.82);
                this.page.line(
                    this.theme.margin,
                    this.cursor,
                    this.page.width - this.theme.margin,
                    this.cursor
                );
                this.page.gray(0);

                this.advance(20);
            }

            fieldList(fields) {
                for (const field of fields) {
                    this.fieldBox(field);
                }
            }

            fieldBox(field) {
                const x = this.theme.margin;
                const width = this.page.width - this.theme.margin * 2;
                const lines = Math.max(Number(field.lines || 3), 1);
                const lineGap = Number(field.lineGap || 18);
                const height = 34 + lines * lineGap;

                this.ensure(height + 12);

                this.page.gray(0.97);
                this.page.rect(x, this.cursor - 12, width, height, "f");
                this.page.gray(0.78);
                this.page.rect(x, this.cursor - 12, width, height, "S");
                this.page.gray(0);

                this.page.text(
                    x + 12,
                    this.cursor,
                    field.title || "",
                    {
                        size: this.theme.bodySize,
                        bold: true
                    }
                );

                this.advance(20);

                this.page.gray(0.72);

                for (let index = 0; index < lines; index += 1) {
                    this.page.line(
                        x + 12,
                        this.cursor + 5,
                        x + width - 12,
                        this.cursor + 5
                    );

                    this.advance(lineGap);
                }

                this.page.gray(0);
                this.advance(8);
            }

            block(block) {
                switch (block.kind) {
                case "heading":
                    this.heading(block);
                    break;

                case "paragraph":
                    this.paragraph(block.text || "");
                    break;

                case "checklist":
                    this.checklist(block.items || []);
                    break;

                case "callout":
                    this.callout(block);
                    break;

                case "rule":
                    this.rule();
                    break;

                case "spacer":
                    this.advance(Number(block.amount || 12));
                    break;

                default:
                    break;
                }
            }

            heading(block) {
                const level = Number(block.level || 2);
                const size = level <= 1 ? this.theme.headingSize + 2 : this.theme.headingSize;

                this.ensure(size + 18);

                this.page.text(
                    this.theme.margin,
                    this.cursor,
                    block.text || "",
                    {
                        size: size,
                        bold: true
                    }
                );

                this.advance(size + 10);
            }

            paragraph(value) {
                this.wrapped(value, this.theme.bodySize, false);
                this.advance(4);
            }

            wrapped(value, size, bold, x = this.theme.margin, width = null) {
                const maxWidth = width || (this.page.width - this.theme.margin * 2);
                const lines = wrapText(value, size, maxWidth);
                const height = Math.max(lines.length, 1) * this.theme.lineHeight;

                this.ensure(height + this.theme.gap);

                for (const line of lines) {
                    this.page.text(
                        x,
                        this.cursor,
                        line,
                        {
                            size: size,
                            bold: bold
                        }
                    );
                    this.advance(this.theme.lineHeight);
                }
            }

            checklist(items) {
                for (const item of items) {
                    const x = this.theme.margin;
                    const box = 8;
                    const textX = x + 16;
                    const maxWidth = this.page.width - this.theme.margin - textX;
                    const lines = wrapText(item, this.theme.bodySize, maxWidth);
                    const height = Math.max(lines.length, 1) * this.theme.lineHeight;

                    this.ensure(height + 6);

                    this.page.rect(x, this.cursor - 8, box, box, "S");

                    for (const line of lines) {
                        this.page.text(
                            textX,
                            this.cursor,
                            line,
                            {
                                size: this.theme.bodySize
                            }
                        );
                        this.advance(this.theme.lineHeight);
                    }

                    this.advance(3);
                }

                this.advance(4);
            }

            callout(block) {
                const x = this.theme.margin;
                const width = this.page.width - this.theme.margin * 2;
                const title = block.title || "";
                const lines = wrapText(block.text || "", this.theme.bodySize, width - 24);
                const titleHeight = title ? 18 : 0;
                const height = titleHeight + lines.length * this.theme.lineHeight + 22;

                this.ensure(height + 10);

                this.page.gray(0.96);
                this.page.rect(x, this.cursor - 12, width, height, "f");
                this.page.gray(0.76);
                this.page.rect(x, this.cursor - 12, width, height, "S");
                this.page.gray(0);

                if (title) {
                    this.page.text(
                        x + 12,
                        this.cursor,
                        title,
                        {
                            size: this.theme.bodySize,
                            bold: true
                        }
                    );
                    this.advance(18);
                }

                for (const line of lines) {
                    this.page.text(
                        x + 12,
                        this.cursor,
                        line,
                        {
                            size: this.theme.bodySize
                        }
                    );
                    this.advance(this.theme.lineHeight);
                }

                this.cursor += 18;
            }

            rule() {
                this.ensure(18);

                this.page.gray(0.82);
                this.page.line(
                    this.theme.margin,
                    this.cursor,
                    this.page.width - this.theme.margin,
                    this.cursor
                );
                this.page.gray(0);

                this.advance(18);
            }
        }

        function selectorValue(value) {
            return String(value)
                .replace(/\\/g, "\\\\")
                .replace(/"/g, '\\"');
        }

        function payloadFor(identifier) {
            const script = document.querySelector(
                'script[data-portable-document-format-payload="' + selectorValue(identifier) + '"]'
            );

            if (!script) {
                throw new Error("Missing PortableDocumentFormat payload: " + identifier);
            }

            return JSON.parse(script.textContent || "{}");
        }

        function generate(payload) {
            return new Layout(payload).render();
        }

        function save(payload, filename) {
            download(
                generate(payload),
                filename
            );
        }

        function bind() {
            document.addEventListener("click", event => {
                const button = event.target.closest("[data-portable-document-format-export]");

                if (!button) return;

                const identifier = button.getAttribute("data-portable-document-format-export");
                const filename = button.getAttribute("data-portable-document-format-filename") || "document.pdf";

                button.disabled = true;

                try {
                    const payload = payloadFor(identifier);

                    save(
                        payload,
                        filename
                    );
                } catch (error) {
                    console.error("[PortableDocumentFormatRuntime]", error);
                } finally {
                    button.disabled = false;
                }
            });
        }

        window.PortableDocumentFormatRuntime = {
            initialized: true,
            generate: generate,
            download: save
        };

        bind();
    })();
    """#
}
