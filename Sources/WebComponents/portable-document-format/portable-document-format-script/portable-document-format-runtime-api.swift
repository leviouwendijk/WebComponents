enum PortableDocumentFormatRuntimeAPI {
    static let source = #"""
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
    """#
}
