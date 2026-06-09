extension QuizScript.Source {
    static let boot = #"""
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => init());
        } else {
            init();
        }

        window.wcQuiz = {
            ready: true,
            init,
            open,
            close
        };
    })();
    """#
}
