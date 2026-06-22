import Foundation
import Constructors
import HTML
import JS

public struct CaptchaRuntime: ReusableComponent, Sendable {
    public struct Model: Sendable {
        public let tokenEndpoint: String
        public let globalName: String
        public let compatibilityAliases: [String]
        public let notifierGlobalName: String?
        public let debugGlobalName: String
        public let debugQueryFlag: String
        public let maxRetries: Int
        public let retryDelayBaseMS: Int
        public let refreshMarginSeconds: Int
        public let prefetchOnBoot: Bool
        public let credentials: String

        public init(
            tokenEndpoint: String,
            globalName: String = "captcha",
            compatibilityAliases: [String] = [
                "captcher",
            ],
            notifierGlobalName: String? = nil,
            debugGlobalName: String = "CAPTCHA_DEBUG",
            debugQueryFlag: String = "captcha_debug",
            maxRetries: Int = 3,
            retryDelayBaseMS: Int = 300,
            refreshMarginSeconds: Int = 20,
            prefetchOnBoot: Bool = true,
            credentials: String = "omit"
        ) {
            self.tokenEndpoint = tokenEndpoint
            self.globalName = globalName
            self.compatibilityAliases = compatibilityAliases
            self.notifierGlobalName = notifierGlobalName
            self.debugGlobalName = debugGlobalName
            self.debugQueryFlag = debugQueryFlag
            self.maxRetries = maxRetries
            self.retryDelayBaseMS = retryDelayBaseMS
            self.refreshMarginSeconds = refreshMarginSeconds
            self.prefetchOnBoot = prefetchOnBoot
            self.credentials = credentials
        }
    }

    public let model: Model

    public init(
        _ model: Model
    ) {
        self.model = model
    }

    public var nodes: ReusableComponentNodes {
        CaptchaRuntimeScript(model).nodes
    }
}

public struct CaptchaRuntimeScript: ReusableComponent, Sendable {
    public let model: CaptchaRuntime.Model

    public init(
        _ model: CaptchaRuntime.Model
    ) {
        self.model = model
    }

    public var nodes: ReusableComponentNodes {
        .init(
            scripts: [
                JSSource(Self.source(for: model)).as_inline_script()
            ]
        )
    }

    private static func source(
        for model: CaptchaRuntime.Model
    ) -> String {
        let aliases = model.compatibilityAliases
            .map(js_string)
            .joined(separator: ", ")

        let notifierGlobalName = model.notifierGlobalName.map(js_string) ?? "null"

        return #"""
        (() => {
            const config = {
                tokenEndpoint: \#(js_string(model.tokenEndpoint)),
                globalName: \#(js_string(model.globalName)),
                aliases: [\#(aliases)],
                notifierGlobalName: \#(notifierGlobalName),
                debugGlobalName: \#(js_string(model.debugGlobalName)),
                debugQueryFlag: \#(js_string(model.debugQueryFlag)),
                maxRetries: \#(max(1, model.maxRetries)),
                retryDelayBaseMS: \#(max(0, model.retryDelayBaseMS)),
                refreshMarginMS: \#(max(0, model.refreshMarginSeconds) * 1000),
                prefetchOnBoot: \#(model.prefetchOnBoot ? "true" : "false"),
                credentials: \#(js_string(model.credentials))
            };

            if (window[config.globalName]?.initialized) {
                return;
            }

            const DEBUG = (() => {
                try {
                    if (window[config.debugGlobalName] === true) {
                        return true;
                    }

                    const params = new URLSearchParams(window.location.search);
                    return params.has(config.debugQueryFlag);
                } catch {
                    return window[config.debugGlobalName] === true;
                }
            })();

            function log(...args) {
                if (DEBUG) {
                    console.log('[captcha]', ...args);
                }
            }

            function warn(...args) {
                if (DEBUG) {
                    console.warn('[captcha]', ...args);
                }
            }

            function err(...args) {
                console.error('[captcha]', ...args);
            }

            const start = Date.now();
            const prefersReducedMotion = window.matchMedia?.('(prefers-reduced-motion: reduce)')?.matches === true;

            const metrics = {
                startTime: start,
                userInteracted: false,

                mouseMovements: 0,
                scrollEvents: 0,
                token: null,
                securityToken: null,

                keypresses: 0,
                focusEvents: 0,
                visibilityStayed: true,
                pointerTypes: new Set(),
                maxScrollDepthPct: 0,
                firstInteractionAt: null,
                prefersReducedMotion,

                tokenFetchedAt: null,
                tokenExpiresAt: null,
                tokenTtlSeconds: null
            };

            function markInteraction() {
                if (!metrics.userInteracted) {
                    metrics.userInteracted = true;
                    metrics.firstInteractionAt = Date.now() - start;
                }
            }

            const onPointerMove = (event) => {
                metrics.mouseMovements++;
                markInteraction();

                if (event?.pointerType) {
                    metrics.pointerTypes.add(event.pointerType);
                }

                if (metrics.mouseMovements > 200) {
                    document.removeEventListener('pointermove', onPointerMove);
                }
            };

            document.addEventListener('pointermove', onPointerMove, { passive: true });

            document.addEventListener('touchstart', () => {
                markInteraction();
                metrics.pointerTypes.add('touch');
            }, { passive: true });

            document.addEventListener('keydown', () => {
                metrics.keypresses++;
                markInteraction();
            });

            document.addEventListener('focusin', () => {
                metrics.focusEvents++;
                markInteraction();
            });

            document.addEventListener('scroll', () => {
                metrics.scrollEvents++;
                markInteraction();

                const doc = document.documentElement;
                const scrolled = (doc.scrollTop || document.body.scrollTop) + doc.clientHeight;
                const total = doc.scrollHeight || 1;
                const pct = Math.min(100, Math.max(0, Math.round((scrolled / total) * 100)));

                if (pct > metrics.maxScrollDepthPct) {
                    metrics.maxScrollDepthPct = pct;
                }
            }, { passive: true });

            document.addEventListener('visibilitychange', () => {
                if (document.hidden) {
                    metrics.visibilityStayed = false;
                }
            });

            function notify(record) {
                const names = [
                    config.notifierGlobalName,
                    'HondenmeestersNotify',
                    'Notifier',
                    'hondenmeestersNotifier',
                    'notifier'
                ].filter(Boolean);

                for (const name of names) {
                    const target = window[name];

                    if (typeof target?.record === 'function') {
                        target.record(record);
                        return;
                    }
                }
            }

            function resetToken() {
                metrics.token = null;
                metrics.securityToken = null;
                metrics.tokenFetchedAt = null;
                metrics.tokenExpiresAt = null;
                metrics.tokenTtlSeconds = null;
            }

            function isExpired() {
                if (!metrics.securityToken) {
                    return true;
                }

                if (!metrics.tokenExpiresAt) {
                    return false;
                }

                return Date.now() >= metrics.tokenExpiresAt - config.refreshMarginMS;
            }

            function hasUsableToken() {
                return !!metrics.securityToken && !isExpired();
            }

            async function fetchSecurityToken() {
                try {
                    const response = await fetch(config.tokenEndpoint, {
                        method: 'GET',
                        headers: {
                            'Accept': 'application/json'
                        },
                        cache: 'no-store',
                        credentials: config.credentials
                    });

                    if (!response.ok) {
                        const body = await response.text().catch(() => '');

                        err('Server responded with error:', response.status, response.statusText, body);

                        notify({
                            id: 'captcha-token-fetch-http-error',
                            type: 'warning',
                            title: 'Captcha-token ophalen mislukt',
                            message: 'De captcha-server gaf een foutstatus terug.',
                            source: 'CaptchaRuntime:fetchSecurityToken',
                            details: {
                                status: response.status,
                                statusText: response.statusText,
                                body: body.slice(0, 1000),
                                endpoint: config.tokenEndpoint,
                                page: window.location.href
                            }
                        });

                        return false;
                    }

                    const data = await response.json().catch(() => null);
                    const token = data?.token || data?.securityToken;

                    if (token) {
                        metrics.token = String(token);
                        metrics.securityToken = String(token);
                        metrics.tokenFetchedAt = Date.now();

                        if (typeof data.ttlSeconds === 'number') {
                            metrics.tokenTtlSeconds = data.ttlSeconds;
                            metrics.tokenExpiresAt = metrics.tokenFetchedAt + (data.ttlSeconds * 1000);
                        }

                        log(
                            data?.success ? 'Token success' : 'Token received',
                            data?.spec || null,
                            `yes(${String(token).slice(0, 4)}…)`
                        );

                        return true;
                    }

                    err('Invalid token received:', data);

                    notify({
                        id: 'captcha-token-invalid-response',
                        type: 'warning',
                        title: 'Captcha-token ongeldig',
                        message: 'De captcha-server reageerde, maar zonder bruikbaar token.',
                        source: 'CaptchaRuntime:fetchSecurityToken',
                        details: {
                            response: data,
                            endpoint: config.tokenEndpoint,
                            page: window.location.href
                        }
                    });

                    return false;
                } catch (error) {
                    err('Error fetching security token:', error);

                    notify({
                        id: 'captcha-token-network-error',
                        type: 'warning',
                        title: 'Captcha-token netwerkfout',
                        message: 'Het ophalen van het captcha-token gaf een netwerk- of browserfout.',
                        source: 'CaptchaRuntime:fetchSecurityToken',
                        details: {
                            error: error?.message || String(error),
                            endpoint: config.tokenEndpoint,
                            page: window.location.href
                        }
                    });

                    return false;
                }
            }

            function delay(ms) {
                return new Promise(resolve => setTimeout(resolve, ms));
            }

            async function initCaptcha(forceRefresh = false) {
                if (forceRefresh || isExpired()) {
                    resetToken();
                }

                if (hasUsableToken()) {
                    log('initCaptcha: already have token');
                    return getMetrics();
                }

                let retryCount = 0;

                while (!hasUsableToken() && retryCount < config.maxRetries) {
                    log(`Fetching CAPTCHA token (try: ${retryCount + 1}/${config.maxRetries})`);

                    const ok = await fetchSecurityToken();

                    if (ok && hasUsableToken()) {
                        break;
                    }

                    retryCount++;

                    if (retryCount < config.maxRetries) {
                        await delay(config.retryDelayBaseMS * retryCount);
                    }
                }

                if (!hasUsableToken()) {
                    err('Failed to initialize CAPTCHA after retries.');

                    notify({
                        id: 'captcha-init-failed-after-retries',
                        type: 'warning',
                        title: 'Captcha niet geïnitialiseerd',
                        message: 'Na meerdere pogingen is er geen captcha-token beschikbaar. Formulieren kunnen hierdoor niet verzenden.',
                        source: 'CaptchaRuntime:initCaptcha',
                        details: {
                            maxRetries: config.maxRetries,
                            forceRefresh,
                            endpoint: config.tokenEndpoint,
                            page: window.location.href
                        }
                    });
                } else {
                    log('initCaptcha: token present');
                }

                return getMetrics();
            }

            function bucket(n, edges) {
                for (let i = 0; i < edges.length; i++) {
                    if (n <= edges[i]) {
                        return edges[i];
                    }
                }

                return edges[edges.length - 1];
            }

            function getMetrics() {
                return {
                    timeSpent: Date.now() - metrics.startTime,

                    userInteracted: metrics.userInteracted,
                    mouseMovements: bucket(metrics.mouseMovements, [0, 1, 5, 10, 50, 200]),
                    scrollEvents: bucket(metrics.scrollEvents, [0, 1, 2, 5, 20, 100]),

                    keypresses: bucket(metrics.keypresses, [0, 1, 2, 5, 20, 100]),
                    focusEvents: bucket(metrics.focusEvents, [0, 1, 2, 5, 20, 100]),
                    visibilityStayed: metrics.visibilityStayed,
                    pointerTypes: Array.from(metrics.pointerTypes),

                    maxScrollDepthPct: Math.round(metrics.maxScrollDepthPct / 10) * 10,
                    firstInteractionAt: metrics.firstInteractionAt,

                    prefersReducedMotion: metrics.prefersReducedMotion,

                    token: metrics.token,
                    securityToken: metrics.securityToken,
                    tokenFetchedAt: metrics.tokenFetchedAt ?? null,
                    tokenExpiresAt: metrics.tokenExpiresAt ?? null,
                    tokenTtlSeconds: metrics.tokenTtlSeconds ?? null
                };
            }

            async function getToken() {
                if (!hasUsableToken()) {
                    await initCaptcha();
                }

                return metrics.securityToken || '';
            }

            const api = {
                kind: 'webcomponents-captcha-runtime',
                initialized: true,
                initCaptcha,
                refresh: () => initCaptcha(true),
                getMetrics,
                getToken,
                isExpired,
                config: {
                    tokenEndpoint: config.tokenEndpoint,
                    globalName: config.globalName,
                    aliases: config.aliases
                }
            };

            function assignGlobal(name) {
                if (!name) {
                    return;
                }

                if (window[name] && window[name] !== api) {
                    warn(`Overwriting existing captcha global: ${name}`);
                }

                window[name] = api;
            }

            assignGlobal(config.globalName);
            config.aliases.forEach(assignGlobal);

            if (config.prefetchOnBoot) {
                const prefetch = () => {
                    initCaptcha().catch((error) => {
                        err('Prefetch failed:', error);
                    });
                };

                if (typeof window.requestIdleCallback === 'function') {
                    window.requestIdleCallback(prefetch, { timeout: 1200 });
                } else {
                    window.setTimeout(prefetch, 0);
                }
            }

            log('booted');
        })();
        """#
    }

    private static func js_string(
        _ value: String
    ) -> String {
        guard
            let data = try? JSONEncoder().encode(value),
            let string = String(data: data, encoding: .utf8)
        else {
            return "\"\""
        }

        return string
    }
}
