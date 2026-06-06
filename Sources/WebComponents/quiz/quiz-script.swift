import Constructors
import JS

public struct QuizScript: ReusableComponent {
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

        function normalizeProgress(raw, setID, timerEnabled) {
            if (!raw || raw.version !== storageVersion || raw.setID !== setID) {
                return blankProgress(setID, timerEnabled);
            }

            if (!Number.isFinite(Number(raw.expiresAt)) || Number(raw.expiresAt) <= now()) {
                return blankProgress(setID, timerEnabled);
            }

            const progress = {
                version: storageVersion,
                setID,
                createdAt: Number(raw.createdAt) || now(),
                updatedAt: Number(raw.updatedAt) || now(),
                expiresAt: now() + storageTTL,
                settings: {
                    timerEnabled: Boolean(raw.settings?.timerEnabled)
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

        function isResult(value) {
            return value === 'right' || value === 'wrong' || value === 'timeout';
        }

        function labelForResult(value) {
            switch (value) {
            case 'right':
                return 'Correct';
            case 'wrong':
                return 'Incorrect';
            case 'timeout':
                return 'Tijd verstreken';
            default:
                return 'Onbeantwoord';
            }
        }

        function attemptLabel(attempts) {
            const count = Math.max(0, Number(attempts) || 0);

            if (count === 1) {
                return '1 poging';
            }

            return `${count} pogingen`;
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

        function itemProgress(data, itemID) {
            return data.progress.items[itemID] || null;
        }

        function selectedForStore(panel, item) {
            if (item.rule.mode === 'text') {
                return [];
            }

            return picked(panel);
        }

        function recordAttempt(root, item, result, selected = []) {
            const data = state(root);
            const previous = itemProgress(data, item.id);
            const history = previous?.history ? [...previous.history] : [];

            history.push(result);

            data.progress.items[item.id] = {
                attempts: (previous?.attempts || 0) + 1,
                lastResult: result,
                status: result,
                selected: item.rule.mode === 'text' ? [] : selected,
                history: history.slice(-20),
                updatedAt: now()
            };

            saveProgress(data);
            renderProgress(root);
        }

        function resetItemProgress(root, itemID) {
            const data = state(root);

            delete data.progress.items[itemID];
            saveProgress(data);
            renderProgress(root);
        }

        function resetAllProgress(root) {
            const data = state(root);

            data.progress.items = {};
            saveProgress(data);
            renderProgress(root);
        }

        function radioInputFromEvent(event) {
            const input = event.target?.closest?.('[data-quiz-option] input[type="radio"]');

            if (input) {
                return input;
            }

            const option = event.target?.closest?.('[data-quiz-option]');

            return option?.querySelector?.('input[type="radio"]') || null;
        }

        function rememberRadioState(event) {
            const input = radioInputFromEvent(event);

            if (!input || input.disabled) {
                return;
            }

            input.setAttribute(
                'data-quiz-was-checked',
                input.checked ? 'true' : 'false'
            );
        }

        function toggleSelectedRadio(event) {
            const input = radioInputFromEvent(event);

            if (!input || input.disabled) {
                return false;
            }

            const wasChecked = input.getAttribute('data-quiz-was-checked') === 'true';
            input.removeAttribute('data-quiz-was-checked');

            if (!wasChecked) {
                return false;
            }

            event.preventDefault();
            event.stopPropagation();

            input.checked = false;
            input.focus();

            input.dispatchEvent(
                new Event(
                    'change',
                    {
                        bubbles: true
                    }
                )
            );

            return true;
        }

        function picked(panel) {
            return Array
                .from(panel.querySelectorAll('input[type="radio"]:checked, input[type="checkbox"]:checked'))
                .map((input) => input.value)
                .sort();
        }

        function textOk(panel, item) {
            const input = panel.querySelector('[data-quiz-input]');
            const answer = norm(input?.value || '');

            return item.rule.accepted
                .map(norm)
                .includes(answer);
        }

        function selectedOk(panel, item) {
            return same(
                picked(panel),
                [...item.rule.ids].sort()
            );
        }

        function formatTime(seconds) {
            const safe = Math.max(0, Number(seconds) || 0);
            const minutes = Math.floor(safe / 60);
            const rest = safe % 60;

            if (minutes <= 0) {
                return `${rest}s`;
            }

            return `${minutes}:${String(rest).padStart(2, '0')}`;
        }

        function hasTimer(data) {
            return Number.isFinite(data.timerSeconds) && data.timerSeconds > 0;
        }

        function timerHTML(data) {
            if (!hasTimer(data)) return '';

            const checked = data.timerEnabled ? 'true' : 'false';
            const state = data.timerEnabled ? 'on' : 'off';

            return `
                <div class="wc-quiz-timer-controls" data-quiz-timer-controls>
                    <div class="wc-quiz-timer" data-quiz-timer data-quiz-timer-state="${data.timerEnabled ? 'active' : 'off'}" aria-live="polite">
                        <span>Tijd</span>
                        <strong data-quiz-timer-value>${data.timerEnabled ? esc(formatTime(data.timerSeconds)) : 'uit'}</strong>
                    </div>

                    <button class="wc-quiz-timer-toggle" type="button" role="switch" aria-label="Timer in- of uitschakelen" aria-checked="${checked}" data-quiz-timer-toggle data-quiz-timer-toggle-state="${state}">
                        <span class="wc-quiz-timer-toggle__label">Timer</span>
                        <span class="wc-quiz-timer-toggle__track" aria-hidden="true">
                            <span class="wc-quiz-timer-toggle__thumb"></span>
                        </span>
                    </button>
                </div>
            `;
        }

        function progressHTML(data, item) {
            const entry = itemProgress(data, item.id);

            if (!entry) {
                return `
                    <div class="wc-quiz-prior" data-quiz-prior hidden>
                        <span data-quiz-prior-text></span>
                    </div>
                `;
            }

            return `
                <div class="wc-quiz-prior" data-quiz-prior data-quiz-prior-state="${esc(entry.lastResult)}">
                    <span data-quiz-prior-text>${priorText(entry)}</span>
                </div>
            `;
        }

        function priorText(entry) {
            const label = labelForResult(entry.lastResult);
            const attempts = attemptLabel(entry.attempts);

            if (entry.lastResult === 'timeout') {
                return `Eerder afgebroken: ${label.toLowerCase()} · ${attempts}`;
            }

            return `Eerder beantwoord: ${label} · ${attempts}`;
        }

        function focusFirstControl(panel) {
            panel.focus(
                {
                    preventScroll: true
                }
            );
        }

        function lock(panel, locked) {
            panel.toggleAttribute('data-quiz-locked', locked);

            panel
                .querySelectorAll('input, button[type="submit"]')
                .forEach((control) => {
                    control.disabled = locked;
                });
        }

        function clear(panel) {
            panel.removeAttribute('data-quiz-state');

            panel
                .querySelectorAll('[data-quiz-option]')
                .forEach((option) => {
                    option.removeAttribute('data-quiz-option-state');
                });

            panel
                .querySelectorAll('[data-quiz-feedback]')
                .forEach((node) => {
                    node.hidden = true;
                });
        }

        function mark(panel, item) {
            const ids = new Set(item.rule.ids);

            panel
                .querySelectorAll('[data-quiz-option]')
                .forEach((option) => {
                    const id = option.getAttribute('data-quiz-option');
                    const input = option.querySelector('input');
                    const selected = Boolean(input?.checked);
                    const correct = ids.has(id);

                    if (correct) {
                        option.setAttribute('data-quiz-option-state', 'right');
                    } else if (selected) {
                        option.setAttribute('data-quiz-option-state', 'wrong');
                    }
                });
        }

        function stopTimer(root) {
            const data = state(root);

            if (data.timerID) {
                window.clearInterval(data.timerID);
                data.timerID = null;
            }
        }

        function updateTimerToggle(panel, data) {
            const toggle = panel.querySelector('[data-quiz-timer-toggle]');

            if (!toggle) {
                return;
            }

            toggle.setAttribute(
                'aria-checked',
                data.timerEnabled ? 'true' : 'false'
            );

            toggle.setAttribute(
                'data-quiz-timer-toggle-state',
                data.timerEnabled ? 'on' : 'off'
            );
        }

        function updateTimer(root, panel, remaining) {
            const data = state(root);
            const value = panel.querySelector('[data-quiz-timer-value]');
            const timer = panel.querySelector('[data-quiz-timer]');

            if (value) {
                value.textContent = data.timerEnabled
                    ? formatTime(remaining)
                    : 'uit';
            }

            if (timer) {
                timer.setAttribute(
                    'data-quiz-timer-state',
                    !data.timerEnabled
                        ? 'off'
                        : remaining <= 5
                            ? 'danger'
                            : 'active'
                );
            }

            updateTimerToggle(panel, data);
        }

        function setTimerEnabled(root, panel, enabled) {
            const data = state(root);

            if (!hasTimer(data)) {
                return;
            }

            data.timerEnabled = Boolean(enabled);
            data.progress.settings.timerEnabled = data.timerEnabled;
            saveProgress(data);
            stopTimer(root);

            if (!data.timerEnabled) {
                updateTimer(root, panel, data.remaining);
                return;
            }

            if (panel.hasAttribute('data-quiz-state')) {
                updateTimer(root, panel, data.timerSeconds);
                return;
            }

            startTimer(root, panel);
        }

        function timeout(root, panel) {
            const data = state(root);
            const item = data.active;

            clear(panel);
            lock(panel, true);
            panel.setAttribute('data-quiz-state', 'timeout');

            if (item) {
                recordAttempt(root, item, 'timeout', []);
                updatePrior(root, panel, item);
            }

            const feedback = panel.querySelector('[data-quiz-feedback="timeout"]');

            if (feedback) {
                feedback.hidden = false;
            }

            panel.querySelector('[data-quiz-reset]')?.focus();
        }

        function startTimer(root, panel) {
            const data = state(root);
            stopTimer(root);

            if (!hasTimer(data) || !data.timerEnabled) {
                updateTimer(root, panel, data.remaining);
                return;
            }

            data.remaining = data.timerSeconds;
            updateTimer(root, panel, data.remaining);

            data.timerID = window.setInterval(() => {
                const current = root.querySelector('[data-quiz-panel]');

                if (!current || current !== panel || !data.active) {
                    stopTimer(root);
                    return;
                }

                if (!data.timerEnabled) {
                    stopTimer(root);
                    updateTimer(root, panel, data.remaining);
                    return;
                }

                if (panel.hasAttribute('data-quiz-state')) {
                    stopTimer(root);
                    return;
                }

                data.remaining -= 1;
                updateTimer(root, panel, data.remaining);

                if (data.remaining <= 0) {
                    stopTimer(root);
                    timeout(root, panel);
                }
            }, 1000);
        }

        function check(root, panel, item) {
            const ok = item.rule.mode === 'text'
                ? textOk(panel, item)
                : selectedOk(panel, item);
            const selected = selectedForStore(panel, item);

            stopTimer(root);
            clear(panel);

            const result = ok ? 'right' : 'wrong';
            panel.setAttribute('data-quiz-state', result);

            if (item.rule.mode !== 'text') {
                mark(panel, item);
            }

            lock(panel, true);
            recordAttempt(root, item, result, selected);
            updatePrior(root, panel, item);

            const feedback = panel.querySelector(`[data-quiz-feedback="${result}"]`);

            if (feedback) {
                feedback.hidden = false;
            }
        }

        function optionHTML(item) {
            if (item.rule.mode === 'text') {
                return `
                    <label class="wc-quiz-text">
                        <span>Jouw antwoord</span>
                        <input type="text" autocomplete="off" data-quiz-input>
                    </label>
                `;
            }

            const type = item.rule.mode === 'many'
                ? 'checkbox'
                : 'radio';

            const choices = item.choices.map((choice) => {
                const input = `${item.id}-${choice.id}`;

                return `
                    <label class="wc-quiz-option" for="${esc(input)}" data-quiz-option="${esc(choice.id)}">
                        <input id="${esc(input)}" type="${type}" name="quiz-${esc(item.id)}" value="${esc(choice.id)}">
                        <span class="wc-quiz-option__text">${esc(choice.text)}</span>
                        ${choice.note ? `<span class="wc-quiz-option__note">${esc(choice.note)}</span>` : ''}
                    </label>
                `;
            }).join('');

            return `
                <fieldset class="wc-quiz-options">
                    <legend class="wc-quiz-options__legend">Kies je antwoord</legend>
                    ${choices}
                </fieldset>
            `;
        }

        function navHTML(data, item) {
            const index = data.items.findIndex((candidate) => candidate.id === item.id);
            const previous = index > 0 ? data.items[index - 1] : null;
            const next = index >= 0 && index + 1 < data.items.length
                ? data.items[index + 1]
                : null;

            const prevHTML = previous
                ? `
                    <button class="wc-quiz-nav__link" type="button" data-quiz-goto="${esc(previous.id)}">
                        <span>Vorige</span>
                        <strong>${esc(previous.title)}</strong>
                    </button>
                `
                : `
                    <span class="wc-quiz-nav__empty">Geen vorige vraag</span>
                `;

            const nextHTML = next
                ? `
                    <button class="wc-quiz-nav__link wc-quiz-nav__link--next" type="button" data-quiz-goto="${esc(next.id)}">
                        <span>Volgende</span>
                        <strong>${esc(next.title)}</strong>
                    </button>
                `
                : `
                    <button class="wc-quiz-nav__link wc-quiz-nav__link--next" type="button" data-quiz-close>
                        <span>Klaar</span>
                        <strong>Alle vragen</strong>
                    </button>
                `;

            return `
                <nav class="wc-quiz-nav" aria-label="Vraag-navigatie">
                    ${prevHTML}
                    ${nextHTML}
                </nav>
            `;
        }

        function render(data, item) {
            const entry = itemProgress(data, item.id);
            const resetDisabled = entry ? '' : 'disabled';

            return `
                <button class="wc-quiz__back" type="button" data-quiz-close>
                    Alle vragen
                </button>

                <article class="wc-quiz-item" data-quiz-item>
                    <header class="wc-quiz-item__head">
                        <div class="wc-quiz-item__kicker">
                            <div class="wc-quiz-item__eyebrow">
                                ${esc(item.group)} · ${esc(item.levelLabel)}
                            </div>
                            ${timerHTML(data)}
                        </div>

                        <p class="wc-quiz-topic">${esc(item.title)}</p>

                        <h1 id="wc-quiz-panel-title">${esc(item.prompt)}</h1>

                        ${progressHTML(data, item)}
                    </header>

                    <form class="wc-quiz-form" data-quiz-form>
                        ${optionHTML(item)}

                        <div class="wc-quiz-form__actions">
                            <button class="wc-quiz-btn wc-quiz-btn--main" type="submit">
                                Controleer
                            </button>

                            <button class="wc-quiz-btn wc-quiz-btn--reset" type="button" data-quiz-reset>
                                Opnieuw
                            </button>

                            <button class="wc-quiz-btn wc-quiz-btn--clear" type="button" data-quiz-reset-item ${resetDisabled}>
                                Reset dit antwoord
                            </button>
                        </div>
                    </form>

                    <div class="wc-quiz-feedback wc-quiz-feedback--right" data-quiz-feedback="right" hidden>
                        <h2>Correct</h2>
                        <p>${esc(item.explanation)}</p>
                    </div>

                    <div class="wc-quiz-feedback wc-quiz-feedback--wrong" data-quiz-feedback="wrong" hidden>
                        <h2>Incorrect</h2>
                        <p>${esc(item.explanation)}</p>
                    </div>

                    <div class="wc-quiz-feedback wc-quiz-feedback--timeout" data-quiz-feedback="timeout" hidden>
                        <h2>Tijd verstreken</h2>
                        <p>Je hebt niet op tijd geantwoord. Probeer opnieuw om dezelfde vraag nog eens te beantwoorden.</p>
                    </div>
                </article>

                ${navHTML(data, item)}
            `;
        }

        function restoreStoredSelection(root, panel, item) {
            const data = state(root);
            const entry = itemProgress(data, item.id);

            if (!entry || item.rule.mode === 'text') {
                return;
            }

            const selected = new Set(entry.selected || []);

            panel
                .querySelectorAll('input[type="radio"], input[type="checkbox"]')
                .forEach((input) => {
                    input.checked = selected.has(input.value);
                });
        }

        function updatePrior(root, panel, item) {
            const data = state(root);
            const entry = itemProgress(data, item.id);
            const prior = panel.querySelector('[data-quiz-prior]');
            const text = panel.querySelector('[data-quiz-prior-text]');
            const reset = panel.querySelector('[data-quiz-reset-item]');

            if (!prior || !text) {
                return;
            }

            if (!entry) {
                prior.hidden = true;
                prior.removeAttribute('data-quiz-prior-state');
                text.textContent = '';

                if (reset) {
                    reset.disabled = true;
                }

                return;
            }

            prior.hidden = false;
            prior.setAttribute('data-quiz-prior-state', entry.lastResult);
            text.textContent = priorText(entry);

            if (reset) {
                reset.disabled = false;
            }
        }

        function resetPanelAttempt(panel) {
            lock(panel, false);

            panel.querySelectorAll('input').forEach((input) => {
                if (input.type === 'radio' || input.type === 'checkbox') {
                    input.checked = false;
                } else {
                    input.value = '';
                }
            });

            clear(panel);
        }

        function setHash(item) {
            const next = `${window.location.pathname}${window.location.search}#${encodeURIComponent(item.slug)}`;
            history.pushState({}, '', next);
        }

        function clearHash() {
            const next = `${window.location.pathname}${window.location.search}`;
            history.pushState({}, '', next);
        }

        function open(root, item, updateHash = true) {
            const data = state(root);
            const shell = root.querySelector('[data-quiz-shell]');
            const panel = root.querySelector('[data-quiz-panel]');

            if (!shell || !panel) return;

            stopTimer(root);
            data.active = item;
            panel.innerHTML = render(data, item);
            shell.hidden = false;
            document.documentElement.classList.add('wc-quiz-is-open');
            restoreStoredSelection(root, panel, item);
            startTimer(root, panel);

            if (updateHash) {
                setHash(item);
            }

            focusFirstControl(panel);
        }

        function close(root, updateHash = true) {
            const shell = root.querySelector('[data-quiz-shell]');
            const panel = root.querySelector('[data-quiz-panel]');

            stopTimer(root);

            if (shell) {
                shell.hidden = true;
            }

            if (panel) {
                panel.innerHTML = '';
            }

            state(root).active = null;
            document.documentElement.classList.remove('wc-quiz-is-open');

            if (updateHash) {
                clearHash();
            }
        }

        function openFromHash(root) {
            const slug = decodeURIComponent(window.location.hash.replace(/^#/, ''));

            if (!slug) {
                close(root, false);
                return;
            }

            const data = state(root);
            const item = data.bySlug.get(slug);

            if (item) {
                open(root, item, false);
            }
        }

        function statusForCard(entry) {
            if (!entry) {
                return 'unanswered';
            }

            return entry.lastResult || 'unanswered';
        }

        function renderHistory(entry) {
            if (!entry?.history?.length) {
                return '';
            }

            return entry.history
                .slice(-5)
                .map((result) => `<span class="wc-quiz-card__history-dot" data-quiz-history-result="${esc(result)}"></span>`)
                .join('');
        }

        function renderProgress(root) {
            const data = state(root);
            let answered = 0;
            let right = 0;
            let wrong = 0;
            let timeoutCount = 0;

            root.querySelectorAll('[data-quiz-card]').forEach((card) => {
                const id = card.getAttribute('data-quiz-open');
                const entry = itemProgress(data, id);
                const status = statusForCard(entry);
                const attempts = entry?.attempts || 0;

                if (entry) {
                    answered += 1;

                    if (entry.lastResult === 'right') {
                        right += 1;
                    } else if (entry.lastResult === 'wrong') {
                        wrong += 1;
                    } else if (entry.lastResult === 'timeout') {
                        timeoutCount += 1;
                    }
                }

                card.setAttribute('data-quiz-card-state', status);
                card.setAttribute('data-quiz-card-attempts', String(attempts));

                const statusNode = card.querySelector('[data-quiz-card-status]');
                const attemptsNode = card.querySelector('[data-quiz-card-attempts-label]');
                const historyNode = card.querySelector('[data-quiz-card-history]');

                if (statusNode) {
                    statusNode.textContent = labelForResult(status);
                }

                if (attemptsNode) {
                    attemptsNode.textContent = attemptLabel(attempts);
                }

                if (historyNode) {
                    historyNode.innerHTML = renderHistory(entry);
                }
            });

            const count = root.querySelector('[data-quiz-progress-count]');
            const detail = root.querySelector('[data-quiz-progress-detail]');
            const reset = root.querySelector('[data-quiz-reset-all]');

            if (count) {
                count.textContent = `${answered} van ${data.items.length} beantwoord`;
            }

            if (detail) {
                detail.textContent = answered > 0
                    ? `${right} correct · ${wrong} incorrect · ${timeoutCount} tijd verstreken`
                    : 'Nog geen antwoorden';
            }

            if (reset) {
                reset.disabled = answered === 0;
            }
        }

        function init(scope = document) {
            const roots = scope.matches?.(rootSelector)
                ? [scope]
                : Array.from(scope.querySelectorAll?.(rootSelector) || []);

            roots.forEach((root) => {
                state(root);
                renderProgress(root);
                openFromHash(root);
            });
        }

        document.addEventListener(
            'pointerdown',
            rememberRadioState,
            true
        );

        document.addEventListener(
            'click',
            (event) => {
                toggleSelectedRadio(event);
            },
            true
        );

        document.addEventListener('click', (event) => {
            const timerToggle = event.target?.closest?.('[data-quiz-timer-toggle]');

            if (timerToggle) {
                const root = timerToggle.closest(rootSelector);
                const panel = timerToggle.closest('[data-quiz-panel]');

                if (!root || !panel) return;

                event.preventDefault();

                setTimerEnabled(
                    root,
                    panel,
                    timerToggle.getAttribute('aria-checked') !== 'true'
                );

                return;
            }

            const resetAll = event.target?.closest?.('[data-quiz-reset-all]');

            if (resetAll) {
                const root = resetAll.closest(rootSelector);
                if (!root) return;

                event.preventDefault();
                resetAllProgress(root);
                return;
            }

            const resetItem = event.target?.closest?.('[data-quiz-reset-item]');

            if (resetItem) {
                const root = resetItem.closest(rootSelector);
                const panel = resetItem.closest('[data-quiz-panel]');

                if (!root || !panel) return;

                const item = state(root).active;
                if (!item) return;

                event.preventDefault();
                stopTimer(root);
                resetItemProgress(root, item.id);
                resetPanelAttempt(panel);
                updatePrior(root, panel, item);
                startTimer(root, panel);
                focusFirstControl(panel);
                return;
            }

            const opener = event.target?.closest?.('[data-quiz-open]');

            if (opener) {
                const root = opener.closest(rootSelector);
                if (!root) return;

                const item = state(root).byID.get(opener.getAttribute('data-quiz-open'));
                if (!item) return;

                event.preventDefault();
                open(root, item);
                return;
            }

            const closeButton = event.target?.closest?.('[data-quiz-close]');

            if (closeButton) {
                const root = closeButton.closest(rootSelector);
                if (!root) return;

                event.preventDefault();
                close(root);
                return;
            }

            const gotoButton = event.target?.closest?.('[data-quiz-goto]');

            if (gotoButton) {
                const root = gotoButton.closest(rootSelector);
                if (!root) return;

                const item = state(root).byID.get(gotoButton.getAttribute('data-quiz-goto'));
                if (!item) return;

                event.preventDefault();
                open(root, item);
            }
        });

        document.addEventListener('submit', (event) => {
            const form = event.target?.closest?.('[data-quiz-form]');
            if (!form) return;

            const root = form.closest(rootSelector);
            const panel = form.closest('[data-quiz-panel]');
            if (!root || !panel) return;

            const item = state(root).active;
            if (!item) return;

            event.preventDefault();
            check(root, panel, item);
        });

        document.addEventListener('click', (event) => {
            const reset = event.target?.closest?.('[data-quiz-reset]');
            if (!reset) return;

            const root = reset.closest(rootSelector);
            const panel = reset.closest('[data-quiz-panel]');
            if (!root || !panel) return;

            stopTimer(root);
            resetPanelAttempt(panel);
            startTimer(root, panel);
            focusFirstControl(panel);
        });

        document.addEventListener('keydown', (event) => {
            if (event.key !== 'Escape') return;

            const shell = document.querySelector('[data-quiz-shell]:not([hidden])');
            if (!shell) return;

            const root = shell.closest(rootSelector);
            if (!root) return;

            close(root);
        });

        window.addEventListener('hashchange', () => {
            document
                .querySelectorAll(rootSelector)
                .forEach(openFromHash);
        });

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
