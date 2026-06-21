import Constructors
import JS

public struct PrintableReportScript: ReusableComponent {
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
        if (window.wcPrintableReport?.initialized) return;

        const actionSelector = '[data-print-report-action="print"]';
        const rootSelector = '[data-print-report-root]';
        const registry = new Map();

        function pathGet(object, path) {
            if (!object || !path) return undefined;

            return String(path)
                .split('.')
                .filter(Boolean)
                .reduce((current, part) => {
                    if (current == null) return undefined;
                    return current[part];
                }, object);
        }

        function resolvePath(path) {
            return pathGet(window, path);
        }

        function textValue(value) {
            if (value == null) return '';

            if (Array.isArray(value)) {
                return value
                    .filter((item) => item != null)
                    .map((item) => String(item))
                    .join(', ');
            }

            if (typeof value === 'object') {
                if ('label' in value) return String(value.label);
                if ('value' in value) return String(value.value);

                return JSON.stringify(value);
            }

            return String(value);
        }

        function reportFor(id) {
            if (!id) return null;

            return document.querySelector(
                `${rootSelector}[data-print-report-root="${CSS.escape(id)}"]`
            );
        }

        function sourceFor(report) {
            const selector = report.getAttribute('data-print-report-source') || '';
            if (!selector) return null;

            try {
                return document.querySelector(selector);
            } catch {
                return null;
            }
        }

        function collectorFor(report) {
            const id = report.getAttribute('data-print-report-root') || '';
            const path = report.getAttribute('data-print-report-collector') || '';
            const registered = registry.get(id);

            if (typeof registered === 'function') {
                return registered;
            }

            if (registered && typeof registered.collect === 'function') {
                return registered.collect.bind(registered);
            }

            const resolved = resolvePath(path);
            if (typeof resolved === 'function') {
                return resolved;
            }

            return null;
        }

        function collect(report) {
            const collector = collectorFor(report);
            if (!collector) return {};

            const source = sourceFor(report);

            try {
                return collector(source, report) || {};
            } catch (error) {
                console.error('[wcPrintableReport] collect failed', error);
                return {};
            }
        }

        function valueFor(state, key) {
            if (!state || !key) return undefined;

            if (state.slots && Object.prototype.hasOwnProperty.call(state.slots, key)) {
                return state.slots[key];
            }

            return pathGet(state, key);
        }

        function fill(report, state) {
            const slots = report.querySelectorAll('[data-print-report-slot]');

            slots.forEach((slot) => {
                const key = slot.getAttribute('data-print-report-slot') || '';
                const fallback = slot.getAttribute('data-print-report-fallback') || '';
                const value = valueFor(state, key);

                slot.textContent = textValue(value ?? fallback);
            });
        }

        function begin(report) {
            report.removeAttribute('aria-hidden');
            document.body.classList.add('wc-print-reporting');
        }

        function end(report) {
            document.body.classList.remove('wc-print-reporting');
            report.setAttribute('aria-hidden', 'true');
        }

        function print(id) {
            const report = reportFor(id);
            if (!report) return;

            const state = collect(report);
            fill(report, state);
            begin(report);

            const cleanup = () => {
                window.removeEventListener('afterprint', cleanup);
                end(report);
            };

            window.addEventListener('afterprint', cleanup);
            window.print();

            setTimeout(() => {
                if (document.body.classList.contains('wc-print-reporting')) {
                    cleanup();
                }
            }, 1200);
        }

        function register(id, collector) {
            if (!id || !collector) return;

            registry.set(id, collector);
        }

        document.addEventListener(
            'click',
            (event) => {
                const action = event.target?.closest?.(actionSelector);
                if (!action) return;

                const id = action.getAttribute('data-print-report-id') || '';
                if (!id) return;

                event.preventDefault();
                print(id);
            },
            true
        );

        window.wcPrintableReport = {
            initialized: true,
            register,
            print,
            fill
        };
    })();
    """#
}
