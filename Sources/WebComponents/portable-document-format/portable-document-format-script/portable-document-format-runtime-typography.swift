enum PortableDocumentFormatRuntimeTypography {
    static let source = #"""
        function fontMetrics(size) {
            const resolvedSize = Math.max(Number(size || 0), 1);

            return {
                size: resolvedSize,
                ascent: resolvedSize * 0.78,
                descent: resolvedSize * 0.22,
                naturalLineHeight: resolvedSize * 1.25
            };
        }

        function lineHeightFor(size, preferredLineHeight = null) {
            const metrics = fontMetrics(size);
            const preferred = Number(preferredLineHeight || 0);

            return Math.max(
                metrics.naturalLineHeight,
                preferred
            );
        }

        function lineBox(size, preferredLineHeight = null) {
            const metrics = fontMetrics(size);
            const lineHeight = lineHeightFor(
                size,
                preferredLineHeight
            );

            return {
                ...metrics,
                lineHeight
            };
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

        function measureTextBlock(value, size, width, options = {}) {
            const lines = wrapText(
                value,
                size,
                width
            );

            const box = lineBox(
                size,
                options.lineHeight
            );

            const effectiveLines = Math.max(
                lines.length,
                options.minLines || 0
            );

            return {
                lines,
                size,
                width,
                lineHeight: box.lineHeight,
                ascent: box.ascent,
                descent: box.descent,
                height: effectiveLines * box.lineHeight,
                visualLineCount: effectiveLines
            };
        }

        function drawTextLine(page, x, top, value, options = {}) {
            const size = Number(options.size || 11);
            const box = lineBox(
                size,
                options.lineHeight
            );

            page.text(
                x,
                top + box.ascent,
                value,
                {
                    size,
                    bold: Boolean(options.bold)
                }
            );

            return box.lineHeight;
        }

        function drawTextBlock(page, x, top, measurement, options = {}) {
            let y = top;

            for (const line of measurement.lines) {
                drawTextLine(
                    page,
                    x,
                    y,
                    line,
                    {
                        size: measurement.size,
                        bold: Boolean(options.bold),
                        lineHeight: measurement.lineHeight
                    }
                );

                y += measurement.lineHeight;
            }

            return measurement.height;
        }
    """#
}
