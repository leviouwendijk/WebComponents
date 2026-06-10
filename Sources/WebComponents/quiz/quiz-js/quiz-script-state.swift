extension QuizScript.Source {
    static let state = #"""
        function blankProgress(setID, timerEnabled) {
            const timestamp = now();

            return {
                version: storageVersion,
                setID,
                createdAt: timestamp,
                updatedAt: timestamp,
                expiresAt: timestamp + storageTTL,
                settings: {
                    timerEnabled
                },
                items: {}
            };
        }

        function storedTimerEnabled(raw, timerDefaultEnabled) {
            if (!timerDefaultEnabled) {
                return false;
            }

            if (typeof raw?.settings?.timerEnabled === 'boolean') {
                return raw.settings.timerEnabled;
            }

            return true;
        }

        function normalizeProgress(raw, setID, timerDefaultEnabled) {
            const defaultTimerEnabled = Boolean(timerDefaultEnabled);

            if (!raw || raw.version !== storageVersion || raw.setID !== setID) {
                return blankProgress(setID, defaultTimerEnabled);
            }

            if (!Number.isFinite(Number(raw.expiresAt)) || Number(raw.expiresAt) <= now()) {
                return blankProgress(setID, defaultTimerEnabled);
            }

            const progress = {
                version: storageVersion,
                setID,
                createdAt: Number(raw.createdAt) || now(),
                updatedAt: Number(raw.updatedAt) || now(),
                expiresAt: now() + storageTTL,
                settings: {
                    timerEnabled: storedTimerEnabled(raw, defaultTimerEnabled)
                },
                items: {}
            };

            if (raw.items && typeof raw.items === 'object') {
                Object.entries(raw.items).forEach(([id, entry]) => {
                    const attempts = Math.max(0, Math.floor(Number(entry?.attempts) || 0));
                    const history = Array.isArray(entry?.history)
                        ? entry.history.filter(isResult).slice(-20)
                        : [];

                    if (attempts <= 0 && history.length === 0) {
                        return;
                    }

                    const lastResult = isResult(entry?.lastResult)
                        ? entry.lastResult
                        : history.at(-1) || 'wrong';

                    progress.items[id] = {
                        attempts: Math.max(attempts, history.length),
                        lastResult,
                        status: lastResult,
                        selected: Array.isArray(entry?.selected)
                            ? entry.selected.map(String)
                            : [],
                        history,
                        hintsUsed: Math.max(0, Math.floor(Number(entry?.hintsUsed) || 0)),
                        totalMs: Math.max(0, Math.floor(Number(entry?.totalMs) || 0)),
                        updatedAt: Number(entry?.updatedAt) || now()
                    };
                });
            }

            return progress;
        }

        function loadProgress(setID, timerEnabled) {
            try {
                const stored = window.localStorage?.getItem(storageKey(setID));
                const raw = stored ? JSON.parse(stored) : null;

                return normalizeProgress(raw, setID, timerEnabled);
            } catch {
                return blankProgress(setID, timerEnabled);
            }
        }

        function saveProgress(data) {
            const timestamp = now();

            data.progress.updatedAt = timestamp;
            data.progress.expiresAt = timestamp + storageTTL;
            data.progress.settings.timerEnabled = data.timerEnabled;

            try {
                window.localStorage?.setItem(
                    storageKey(data.set.id),
                    JSON.stringify(data.progress)
                );
            } catch {}
        }

        function parse(root) {
            const data = root.querySelector('[data-quiz-data]');
            const parsed = JSON.parse(data?.textContent || '{}');
            const items = Array.isArray(parsed.items) ? parsed.items : [];
            const rawSeconds = Number(parsed.timerSeconds);
            const timerSeconds = Number.isFinite(rawSeconds)
                ? Math.max(0, Math.floor(rawSeconds))
                : 0;
            const initialTimerEnabled = timerSeconds > 0;
            const progress = loadProgress(parsed.id || 'quiz', initialTimerEnabled);

            return {
                set: parsed,
                items,
                byID: new Map(items.map((item) => [item.id, item])),
                bySlug: new Map(items.map((item) => [item.slug, item])),
                timerSeconds,
                timerEnabled: timerSeconds > 0 && progress.settings.timerEnabled !== false,
                timerID: null,
                remaining: timerSeconds,
                active: null,
                progress
            };
        }

        function state(root) {
            if (!stateByRoot.has(root)) {
                stateByRoot.set(root, parse(root));
            }

            return stateByRoot.get(root);
        }
    """#
}
