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

            headerRuleY() {
                return this.theme.margin
                    + Number(this.theme.headerHeight || 0)
                    - 11;
            }

            headerGap() {
                return Math.max(
                    14,
                    Number(this.theme.gap || 0) * 2
                );
            }

            contentTop() {
                if (!this.hasHeader()) {
                    return this.theme.margin;
                }

                return this.headerRuleY() + this.headerGap();
            }

            contentBottom() {
                return this.page.height
                    - this.theme.margin
                    - Number(this.theme.footerHeight || 34);
            }

            contentWidth() {
                return this.page.width - this.theme.margin * 2;
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
                }

                this.cursor = this.contentTop();
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

                const ruleY = this.headerRuleY();

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
                if (this.cursor + height > this.contentBottom()) {
                    this.newPage();
                }
            }

            advance(amount) {
                this.cursor += amount;
            }

            textLine(x, top, value, options = {}) {
                return drawTextLine(
                    this.page,
                    x,
                    top,
                    value,
                    options
                );
            }

            textBlock(x, top, measurement, options = {}) {
                return drawTextBlock(
                    this.page,
                    x,
                    top,
                    measurement,
                    options
                );
            }

            measureText(value, size, width, options = {}) {
                return measureTextBlock(
                    value,
                    size,
                    width,
                    {
                        lineHeight: options.lineHeight || this.theme.lineHeight,
                        minLines: options.minLines || 0
                    }
                );
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
                const x = this.theme.margin;
                const width = this.contentWidth();
                const title = this.payload.title || "Document";
                const titleMeasurement = this.measureText(
                    title,
                    this.theme.titleSize,
                    width,
                    {
                        lineHeight: this.theme.titleSize * 1.28
                    }
                );

                const hasSubtitle = Boolean(this.payload.subtitle);
                const subtitleMeasurement = hasSubtitle
                    ? this.measureText(
                        this.payload.subtitle,
                        this.theme.subtitleSize,
                        width,
                        {
                            lineHeight: this.theme.lineHeight
                        }
                    )
                    : null;

                const subtitleGap = hasSubtitle ? 7 : 0;
                const ruleGap = 10;
                const afterGap = 16;
                const totalHeight = titleMeasurement.height
                    + subtitleGap
                    + (subtitleMeasurement ? subtitleMeasurement.height : 0)
                    + ruleGap
                    + afterGap;

                this.ensure(totalHeight);

                let y = this.cursor;

                this.page.gray(this.style.textGray);
                this.textBlock(
                    x,
                    y,
                    titleMeasurement,
                    {
                        bold: true
                    }
                );

                y += titleMeasurement.height;

                if (subtitleMeasurement) {
                    y += subtitleGap;
                    this.page.gray(this.style.mutedGray);
                    this.textBlock(
                        x,
                        y,
                        subtitleMeasurement
                    );
                    this.page.gray(this.style.textGray);
                    y += subtitleMeasurement.height;
                }

                const ruleY = y + ruleGap;

                this.page.gray(this.style.ruleGray);
                this.page.line(
                    x,
                    ruleY,
                    this.page.width - this.theme.margin,
                    ruleY
                );
                this.page.gray(this.style.textGray);

                this.cursor = ruleY + afterGap;
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
                const x = this.theme.margin;
                const width = this.contentWidth();
                const kicker = sheet.kicker || "PDF";
                const kickerMeasurement = this.measureText(
                    kicker,
                    this.theme.smallSize,
                    width,
                    {
                        lineHeight: this.theme.smallSize * 1.35
                    }
                );

                const titleMeasurement = this.measureText(
                    this.payload.title || "Document",
                    this.theme.titleSize,
                    width,
                    {
                        lineHeight: this.theme.titleSize * 1.28
                    }
                );

                const lead = this.payload.subtitle
                    ? this.payload.subtitle + ". " + (sheet.lead || "")
                    : sheet.lead || "";

                const hasLead = Boolean(lead);
                const leadMeasurement = hasLead
                    ? this.measureText(
                        lead,
                        this.theme.subtitleSize,
                        width,
                        {
                            lineHeight: this.theme.lineHeight
                        }
                    )
                    : null;

                const kickerGap = 8;
                const leadGap = hasLead ? 7 : 0;
                const ruleGap = 10;
                const afterGap = 16;
                const totalHeight = kickerMeasurement.height
                    + kickerGap
                    + titleMeasurement.height
                    + leadGap
                    + (leadMeasurement ? leadMeasurement.height : 0)
                    + ruleGap
                    + afterGap;

                this.ensure(totalHeight);

                let y = this.cursor;

                this.page.gray(this.style.mutedGray);
                this.textBlock(
                    x,
                    y,
                    kickerMeasurement,
                    {
                        bold: true
                    }
                );

                y += kickerMeasurement.height + kickerGap;

                this.page.gray(this.style.textGray);
                this.textBlock(
                    x,
                    y,
                    titleMeasurement,
                    {
                        bold: true
                    }
                );

                y += titleMeasurement.height;

                if (leadMeasurement) {
                    y += leadGap;
                    this.page.gray(this.style.mutedGray);
                    this.textBlock(
                        x,
                        y,
                        leadMeasurement
                    );
                    this.page.gray(this.style.textGray);
                    y += leadMeasurement.height;
                }

                const ruleY = y + ruleGap;

                this.page.gray(this.style.ruleGray);
                this.page.line(
                    x,
                    ruleY,
                    this.page.width - this.theme.margin,
                    ruleY
                );
                this.page.gray(this.style.textGray);

                this.cursor = ruleY + afterGap;
            }

            fieldList(fields) {
                for (const field of fields) {
                    this.fieldBox(field);
                }
            }

            fieldBox(field) {
                const x = this.theme.margin;
                const width = this.contentWidth();
                const paddingX = 12;
                const paddingTop = 13;
                const paddingBottom = 13;
                const labelGap = 12;
                const afterGap = 10;
                const lines = Math.max(Number(field.lines || 3), 1);
                const lineGap = Number(field.lineGap || 16);
                const radius = Number(this.style.cornerRadius || 0);
                const labelMeasurement = this.measureText(
                    field.title || "",
                    this.theme.bodySize,
                    width - paddingX * 2,
                    {
                        lineHeight: this.theme.lineHeight
                    }
                );

                const writingHeight = lines * lineGap;
                const height = paddingTop
                    + labelMeasurement.height
                    + labelGap
                    + writingHeight
                    + paddingBottom;

                this.ensure(height + afterGap);

                const top = this.cursor;

                this.page.gray(this.style.softGray);
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
                this.textBlock(
                    x + paddingX,
                    top + paddingTop,
                    labelMeasurement,
                    {
                        bold: true
                    }
                );

                this.page.gray(0.72);

                let lineY = top
                    + paddingTop
                    + labelMeasurement.height
                    + labelGap
                    + 5;

                for (let index = 0; index < lines; index += 1) {
                    this.page.line(
                        x + paddingX,
                        lineY,
                        x + width - paddingX,
                        lineY
                    );

                    lineY += lineGap;
                }

                this.page.gray(this.style.textGray);

                this.cursor = top + height + afterGap;
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
                const size = level <= 1
                    ? this.theme.headingSize + 1.5
                    : this.theme.headingSize;
                const beforeGap = this.cursor > this.contentTop() + 2
                    ? 5
                    : 0;
                const afterGap = level <= 1 ? 8 : 6;
                const measurement = this.measureText(
                    block.text || "",
                    size,
                    this.contentWidth(),
                    {
                        lineHeight: size * 1.25
                    }
                );
                const totalHeight = beforeGap
                    + measurement.height
                    + afterGap;

                this.ensure(totalHeight);

                const top = this.cursor + beforeGap;

                this.page.gray(this.style.textGray);
                this.textBlock(
                    this.theme.margin,
                    top,
                    measurement,
                    {
                        bold: true
                    }
                );

                this.cursor += totalHeight;
            }

            paragraph(value) {
                this.page.gray(this.style.textGray);
                this.wrapped(
                    value,
                    this.theme.bodySize,
                    false,
                    this.theme.margin,
                    null,
                    2
                );
            }

            wrapped(
                value,
                size,
                bold,
                x = this.theme.margin,
                width = null,
                afterGap = 0
            ) {
                const maxWidth = width || this.contentWidth();
                const measurement = this.measureText(
                    value,
                    size,
                    maxWidth,
                    {
                        lineHeight: this.theme.lineHeight
                    }
                );
                const totalHeight = measurement.height + afterGap;

                this.ensure(totalHeight);

                const top = this.cursor;

                this.textBlock(
                    x,
                    top,
                    measurement,
                    {
                        bold
                    }
                );

                this.cursor = top + totalHeight;

                return measurement.height;
            }

            checklist(items) {
                const x = this.theme.margin;
                const box = 7;
                const textX = x + 15;
                const maxWidth = this.page.width - this.theme.margin - textX;
                const itemGap = 3;
                const listAfterGap = 3;

                for (const item of items) {
                    const measurement = this.measureText(
                        item,
                        this.theme.bodySize,
                        maxWidth,
                        {
                            lineHeight: this.theme.lineHeight
                        }
                    );
                    const height = Math.max(
                        measurement.height,
                        box + 2
                    );

                    this.ensure(height + itemGap);

                    const top = this.cursor;

                    this.page.gray(this.style.borderGray);
                    this.page.roundRect(
                        x,
                        top + 3,
                        box,
                        box,
                        2,
                        "S"
                    );

                    this.page.gray(this.style.textGray);
                    this.textBlock(
                        textX,
                        top,
                        measurement
                    );

                    this.cursor = top + height + itemGap;
                }

                this.advance(listAfterGap);
            }

            callout(block) {
                const x = this.theme.margin;
                const width = this.contentWidth();
                const paddingX = 14;
                const paddingTop = 14;
                const paddingBottom = 14;
                const titleGap = 5;
                const afterGap = 10;
                const title = block.title || "";
                const text = block.text || "";
                const bodyWidth = width - paddingX * 2;
                const radius = Number(this.style.cornerRadius || 0);
                const hasTitle = Boolean(title);
                const hasBody = Boolean(text);

                const titleMeasurement = hasTitle
                    ? this.measureText(
                        title,
                        this.theme.bodySize,
                        bodyWidth,
                        {
                            lineHeight: this.theme.lineHeight
                        }
                    )
                    : null;

                const bodyMeasurement = hasBody
                    ? this.measureText(
                        text,
                        this.theme.bodySize,
                        bodyWidth,
                        {
                            lineHeight: this.theme.lineHeight
                        }
                    )
                    : null;

                const contentGap = titleMeasurement && bodyMeasurement
                    ? titleGap
                    : 0;

                const height = paddingTop
                    + (titleMeasurement ? titleMeasurement.height : 0)
                    + contentGap
                    + (bodyMeasurement ? bodyMeasurement.height : 0)
                    + paddingBottom;

                this.ensure(height + afterGap);

                const top = this.cursor;
                const textX = x + paddingX;

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

                let y = top + paddingTop;

                this.page.gray(this.style.textGray);

                if (titleMeasurement) {
                    this.textBlock(
                        textX,
                        y,
                        titleMeasurement,
                        {
                            bold: true
                        }
                    );

                    y += titleMeasurement.height + contentGap;
                }

                if (bodyMeasurement) {
                    this.textBlock(
                        textX,
                        y,
                        bodyMeasurement
                    );
                }

                this.cursor = top + height + afterGap;
            }

            rule() {
                const beforeGap = 3;
                const afterGap = 14;
                const totalHeight = beforeGap + afterGap;

                this.ensure(totalHeight);

                const y = this.cursor + beforeGap;

                this.page.gray(this.style.ruleGray);
                this.page.line(
                    this.theme.margin,
                    y,
                    this.page.width - this.theme.margin,
                    y
                );
                this.page.gray(this.style.textGray);

                this.cursor += totalHeight;
            }
        }
    """#
}
