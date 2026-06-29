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
                headerHeight: 0,
                footerHeight: 34,
                logoSize: 24,
                titleSize: 21,
                subtitleSize: 11,
                headingSize: 13.5,
                bodySize: 10.5,
                smallSize: 8.5,
                lineHeight: 13.5,
                gap: 6
            },
            hondenmeesters: {
                page: A4,
                margin: 52,
                headerHeight: 46,
                footerHeight: 34,
                logoSize: 24,
                titleSize: 20,
                subtitleSize: 11,
                headingSize: 13,
                bodySize: 10.5,
                smallSize: 8.5,
                lineHeight: 13.5,
                gap: 6
            }
        };

        const styles = {
            standard: {
                cornerRadius: 8,
                borderGray: 0.82,
                ruleGray: 0.84,
                softGray: 0.975,
                calloutGray: 0.955,
                textGray: 0,
                mutedGray: 0.42,
                footerGray: 0.55
            },
            hondenmeesters: {
                cornerRadius: 8,
                borderGray: 0.82,
                ruleGray: 0.84,
                softGray: 0.975,
                calloutGray: 0.955,
                textGray: 0,
                mutedGray: 0.42,
                footerGray: 0.55
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

        function base64ToBinaryString(value) {
            try {
                return atob(
                    String(value || "")
                        .replace(/\s+/g, "")
                );
            } catch {
                return "";
            }
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

        function compactObject(value) {
            if (!value || typeof value !== "object") {
                return {};
            }

            return Object.fromEntries(
                Object.entries(value).filter(([, entry]) => entry !== null && entry !== undefined)
            );
        }

        function mergeTheme(base, override) {
            const clean = compactObject(override);

            return {
                ...base,
                ...clean,
                page: {
                    ...base.page,
                    ...compactObject(clean.page)
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

        function resolvedStyle(payload) {
            return {
                ...(styles[payload.theme] || styles.standard),
                ...compactObject(payload.style)
            };
        }

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
                this.style = resolvedStyle(this.payload);
                this.document = new PDFDocument();
                this.logoName = this.document.addImage(this.payload.chrome?.logo);
                this.page = null;
                this.pageNumber = 0;
                this.cursor = this.theme.margin;
                this.newPage();
            }

            hasHeader() {
                const chrome = this.payload.chrome || {};
                return Boolean(this.logoName || chrome.headerText);
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

                if (this.hasHeader()) {
                    this.header();
                    this.cursor = this.theme.margin + Number(this.theme.headerHeight || 0);
                } else {
                    this.cursor = this.theme.margin;
                }
            }

            header() {
                const chrome = this.payload.chrome || {};
                const logoSize = Number(this.theme.logoSize || 24);
                const x = this.theme.margin;
                const y = Math.max(18, this.theme.margin - 7);

                if (this.logoName) {
                    this.page.image(
                        this.logoName,
                        x,
                        y,
                        logoSize,
                        logoSize
                    );
                }

                if (chrome.headerText) {
                    this.page.gray(this.style.mutedGray);
                    this.page.text(
                        this.logoName ? x + logoSize + 10 : x,
                        this.theme.margin + 9,
                        chrome.headerText,
                        {
                            size: this.theme.smallSize,
                            bold: true
                        }
                    );
                    this.page.gray(this.style.textGray);
                }

                const ruleY = this.theme.margin + Number(this.theme.headerHeight || 0) - 11;

                this.page.gray(this.style.ruleGray);
                this.page.line(
                    this.theme.margin,
                    ruleY,
                    this.page.width - this.theme.margin,
                    ruleY
                );
                this.page.gray(this.style.textGray);
            }

            footer() {
                const chrome = this.payload.chrome || {};
                const y = this.page.height - this.theme.margin + 18;
                const footer = (chrome.footerItems || [])
                    .filter(Boolean)
                    .join(" · ");

                this.page.gray(this.style.ruleGray);
                this.page.line(
                    this.theme.margin,
                    y - 16,
                    this.page.width - this.theme.margin,
                    y - 16
                );

                this.page.gray(this.style.footerGray);

                if (footer) {
                    this.page.text(
                        this.theme.margin,
                        y,
                        footer,
                        {
                            size: this.theme.smallSize
                        }
                    );
                }

                const number = String(this.pageNumber);
                const numberWidth = textWidth(number, this.theme.smallSize);

                this.page.text(
                    this.page.width - this.theme.margin - numberWidth,
                    y,
                    number,
                    {
                        size: this.theme.smallSize
                    }
                );

                this.page.gray(this.style.textGray);
            }

            ensure(height) {
                const bottom = this.page.height
                    - this.theme.margin
                    - Number(this.theme.footerHeight || 34);

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
                this.ensure(58);

                this.page.gray(this.style.textGray);
                this.page.text(
                    this.theme.margin,
                    this.cursor,
                    this.payload.title || "Document",
                    {
                        size: this.theme.titleSize,
                        bold: true
                    }
                );

                this.advance(this.theme.titleSize + 10);

                if (this.payload.subtitle) {
                    this.page.gray(this.style.mutedGray);
                    this.wrapped(
                        this.payload.subtitle,
                        this.theme.subtitleSize,
                        false
                    );
                    this.page.gray(this.style.textGray);
                    this.advance(3);
                }

                this.page.gray(this.style.ruleGray);
                this.page.line(
                    this.theme.margin,
                    this.cursor,
                    this.page.width - this.theme.margin,
                    this.cursor
                );
                this.page.gray(this.style.textGray);

                this.advance(16);
            }

            sheetTemplate(sheet) {
                this.sheetHeader(sheet);
                this.fieldList(sheet.fields || []);

                if (this.payload.blocks?.length) {
                    this.rule();

                    for (const block of this.payload.blocks) {
                        this.block(block);
                    }
                }
            }

            sheetHeader(sheet) {
                this.ensure(80);

                this.page.gray(this.style.mutedGray);
                this.page.text(
                    this.theme.margin,
                    this.cursor,
                    sheet.kicker || "PDF",
                    {
                        size: this.theme.smallSize,
                        bold: true
                    }
                );

                this.advance(14);

                this.page.gray(this.style.textGray);
                this.page.text(
                    this.theme.margin,
                    this.cursor,
                    this.payload.title || "Document",
                    {
                        size: this.theme.titleSize,
                        bold: true
                    }
                );

                this.advance(this.theme.titleSize + 10);

                const lead = this.payload.subtitle
                    ? this.payload.subtitle + ". " + (sheet.lead || "")
                    : sheet.lead || "";

                if (lead) {
                    this.page.gray(this.style.mutedGray);
                    this.wrapped(
                        lead,
                        this.theme.subtitleSize,
                        false
                    );
                    this.page.gray(this.style.textGray);
                    this.advance(3);
                }

                this.page.gray(this.style.ruleGray);
                this.page.line(
                    this.theme.margin,
                    this.cursor,
                    this.page.width - this.theme.margin,
                    this.cursor
                );
                this.page.gray(this.style.textGray);

                this.advance(16);
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
                const lineGap = Number(field.lineGap || 16);
                const height = 30 + lines * lineGap;
                const radius = Number(this.style.cornerRadius || 0);

                this.ensure(height + 10);

                this.page.gray(this.style.softGray);
                this.page.roundRect(
                    x,
                    this.cursor - 10,
                    width,
                    height,
                    radius,
                    "f"
                );

                this.page.gray(this.style.borderGray);
                this.page.roundRect(
                    x,
                    this.cursor - 10,
                    width,
                    height,
                    radius,
                    "S"
                );

                this.page.gray(this.style.textGray);
                this.page.text(
                    x + 12,
                    this.cursor,
                    field.title || "",
                    {
                        size: this.theme.bodySize,
                        bold: true
                    }
                );

                this.advance(18);
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

                this.page.gray(this.style.textGray);
                this.advance(7);
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
                    this.advance(Number(block.amount || 10));
                    break;

                default:
                    break;
                }
            }

            heading(block) {
                const level = Number(block.level || 2);
                const size = level <= 1 ? this.theme.headingSize + 1.5 : this.theme.headingSize;

                this.ensure(size + 14);

                if (this.cursor > this.theme.margin + Number(this.theme.headerHeight || 0) + 18) {
                    this.advance(3);
                }

                this.page.gray(this.style.textGray);
                this.page.text(
                    this.theme.margin,
                    this.cursor,
                    block.text || "",
                    {
                        size: size,
                        bold: true
                    }
                );

                this.advance(size + 6);
            }

            paragraph(value) {
                this.page.gray(this.style.textGray);
                this.wrapped(value, this.theme.bodySize, false);
                this.advance(2);
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
                    const box = 7;
                    const textX = x + 15;
                    const maxWidth = this.page.width - this.theme.margin - textX;
                    const lines = wrapText(item, this.theme.bodySize, maxWidth);
                    const height = Math.max(lines.length, 1) * this.theme.lineHeight;

                    this.ensure(height + 5);

                    this.page.gray(this.style.borderGray);
                    this.page.roundRect(
                        x,
                        this.cursor - 8,
                        box,
                        box,
                        2,
                        "S"
                    );

                    this.page.gray(this.style.textGray);

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

                    this.advance(2);
                }

                this.advance(3);
            }

            callout(block) {
                const x = this.theme.margin;
                const width = this.page.width - this.theme.margin * 2;
                const paddingX = 14;
                const paddingTop = 16;
                const paddingBottom = 14;
                const titleGap = 5;
                const afterGap = 10;
                const title = block.title || "";
                const text = block.text || "";
                const bodyWidth = width - paddingX * 2;
                const lines = wrapText(
                    text,
                    this.theme.bodySize,
                    bodyWidth
                );

                const hasTitle = Boolean(title);
                const hasBody = lines.length > 0;
                const titleHeight = hasTitle ? this.theme.lineHeight : 0;
                const bodyHeight = hasBody
                    ? lines.length * this.theme.lineHeight
                    : 0;

                const height = paddingTop
                    + titleHeight
                    + (hasTitle && hasBody ? titleGap : 0)
                    + bodyHeight
                    + paddingBottom;

                const radius = Number(this.style.cornerRadius || 0);
                const top = this.cursor - paddingTop;
                const textX = x + paddingX;

                this.ensure(height + afterGap);

                this.page.gray(this.style.calloutGray);
                this.page.roundRect(
                    x,
                    top,
                    width,
                    height,
                    radius,
                    "f"
                );

                this.page.gray(this.style.borderGray);
                this.page.roundRect(
                    x,
                    top,
                    width,
                    height,
                    radius,
                    "S"
                );

                this.page.gray(this.style.textGray);

                let textY = this.cursor;

                if (hasTitle) {
                    this.page.text(
                        textX,
                        textY,
                        title,
                        {
                            size: this.theme.bodySize,
                            bold: true
                        }
                    );

                    textY += this.theme.lineHeight;

                    if (hasBody) {
                        textY += titleGap;
                    }
                }

                for (const line of lines) {
                    this.page.text(
                        textX,
                        textY,
                        line,
                        {
                            size: this.theme.bodySize
                        }
                    );

                    textY += this.theme.lineHeight;
                }

                this.cursor = top + height + afterGap;
            }

            rule() {
                this.ensure(14);

                this.page.gray(this.style.ruleGray);
                this.page.line(
                    this.theme.margin,
                    this.cursor,
                    this.page.width - this.theme.margin,
                    this.cursor
                );
                this.page.gray(this.style.textGray);

                this.advance(14);
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
