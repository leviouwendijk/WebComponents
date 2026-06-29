enum PortableDocumentFormatRuntimeCore {
    static let source = #"""
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
    """#
}
