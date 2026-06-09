extension QuizScript.Source {
    static let shell = #"""
    (() => {
        if (window.wcQuiz?.ready) return;

        const rootSelector = '[data-quiz-root]';
        const stateByRoot = new WeakMap();
        const storageVersion = 1;
        const storageTTL = 1000 * 60 * 60 * 24 * 30;

        function esc(value) {
            return String(value ?? '')
                .replaceAll('&', '&amp;')
                .replaceAll('<', '&lt;')
                .replaceAll('>', '&gt;')
                .replaceAll('"', '&quot;')
                .replaceAll("'", '&#039;');
        }

        function norm(value) {
            return String(value || '')
                .toLowerCase()
                .normalize('NFD')
                .replace(/[\u0300-\u036f]/g, '')
                .replace(/[^\p{Letter}\p{Number}\s-]/gu, '')
                .replace(/\s+/g, ' ')
                .trim();
        }

        function same(left, right) {
            if (left.length !== right.length) return false;

            return left.every((value, index) => value === right[index]);
        }

        function now() {
            return Date.now();
        }

        function storageKey(setID) {
            return `wcQuiz:${setID}:v${storageVersion}`;
        }
    """#
}
