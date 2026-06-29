enum PortableDocumentFormatRuntimeLayout {
    static let source = #"""
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
    """#
}
