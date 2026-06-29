enum PortableDocumentFormatRuntimeLayoutGrayscale {
    static let source = #"""
        Object.assign(Layout.prototype, {
            emphasisGray() {
                return Math.max(
                    0.18,
                    Math.min(0.32, Number(this.style.textGray || 0) + 0.18)
                );
            },

            panelBorderGray() {
                return Number(this.style.borderGray ?? 0.74);
            },

            panelFillGray() {
                return Number(this.style.softGray ?? 0.965);
            },

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
                    this.textLine(
                        this.logoName ? x + logoSize + 10 : x,
                        this.theme.margin + 1,
                        chrome.headerText,
                        {
                            size: this.theme.smallSize,
                            bold: true,
                            lineHeight: this.theme.smallSize * 1.2
                        }
                    );
                    this.page.gray(this.style.textGray);
                }

                const ruleY = this.headerRuleY();

                this.page.lineWidth(0.55);
                this.page.gray(this.style.ruleGray);
                this.page.line(
                    this.theme.margin,
                    ruleY,
                    this.page.width - this.theme.margin,
                    ruleY
                );
                this.page.gray(this.style.textGray);
                this.page.lineWidth(1);
            },

            footer() {
                const chrome = this.payload.chrome || {};
                const y = this.page.height - this.theme.margin + 18;
                const footer = (chrome.footerItems || [])
                    .filter(Boolean)
                    .join(" · ");

                this.page.lineWidth(0.55);
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
                this.page.lineWidth(1);
            },

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
                const afterGap = 18;
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

                this.page.lineWidth(0.7);
                this.page.gray(this.style.ruleGray);
                this.page.line(
                    x,
                    ruleY,
                    this.page.width - this.theme.margin,
                    ruleY
                );
                this.page.gray(this.style.textGray);
                this.page.lineWidth(1);

                this.cursor = ruleY + afterGap;
            },

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
                const afterGap = 18;
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

                this.page.lineWidth(0.7);
                this.page.gray(this.style.ruleGray);
                this.page.line(
                    x,
                    ruleY,
                    this.page.width - this.theme.margin,
                    ruleY
                );
                this.page.gray(this.style.textGray);
                this.page.lineWidth(1);

                this.cursor = ruleY + afterGap;
            },

            heading(block) {
                const level = Number(block.level || 2);
                const size = level <= 1
                    ? this.theme.headingSize + 1.5
                    : this.theme.headingSize;
                const beforeGap = this.cursor > this.contentTop() + 2
                    ? 7
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
            },

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

                this.page.gray(this.panelFillGray());
                this.page.roundRect(
                    x,
                    top,
                    width,
                    height,
                    radius,
                    "f"
                );

                this.page.lineWidth(0.75);
                this.page.gray(this.panelBorderGray());
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

                this.page.lineWidth(0.45);
                this.page.gray(0.74);

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
                this.page.lineWidth(1);

                this.cursor = top + height + afterGap;
            },

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

                    this.page.lineWidth(0.65);
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

                this.page.lineWidth(1);
                this.advance(listAfterGap);
            },

            callout(block) {
                const x = this.theme.margin;
                const width = this.contentWidth();
                const paddingX = 18;
                const paddingTop = 14;
                const paddingBottom = 14;
                const titleGap = 5;
                const afterGap = 10;
                const railInsetX = 10;
                const railInsetY = 12;
                const railWidth = 2.4;
                const title = block.title || "";
                const text = block.text || "";
                const bodyWidth = width - paddingX * 2 - 4;
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
                const textX = x + paddingX + 4;

                this.page.gray(this.style.calloutGray);
                this.page.roundRect(
                    x,
                    top,
                    width,
                    height,
                    radius,
                    "f"
                );

                this.page.lineWidth(0.8);
                this.page.gray(this.panelBorderGray());
                this.page.roundRect(
                    x,
                    top,
                    width,
                    height,
                    radius,
                    "S"
                );

                this.page.lineWidth(railWidth);
                this.page.gray(this.emphasisGray());
                this.page.line(
                    x + railInsetX,
                    top + railInsetY,
                    x + railInsetX,
                    top + Math.max(height - railInsetY, railInsetY)
                );

                let y = top + paddingTop;

                this.page.lineWidth(1);
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
            },

            rule() {
                const beforeGap = 5;
                const afterGap = 15;
                const totalHeight = beforeGap + afterGap;

                this.ensure(totalHeight);

                const y = this.cursor + beforeGap;

                this.page.lineWidth(0.55);
                this.page.gray(this.style.ruleGray);
                this.page.line(
                    this.theme.margin,
                    y,
                    this.page.width - this.theme.margin,
                    y
                );
                this.page.gray(this.style.textGray);
                this.page.lineWidth(1);

                this.cursor += totalHeight;
            }
        });
    """#
}
