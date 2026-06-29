enum PortableDocumentFormatRuntimeTypography {
    static let source = #"""
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
    """#
}
