import Constructors
import HTML

extension RecommendedProductCatalog {
    func interactionScriptNode()
        -> any HTMLNode
    {
        HTML.scriptInline(
            """
            (() => {
                const root = document.getElementById('\(id)');

                if (
                    !root
                    || root.dataset.productInteractionReady === 'true'
                ) {
                    return;
                }

                root.dataset.productInteractionReady = 'true';

                const parameter =
                    root.dataset.productParameter
                    || 'product';

                const dialog = root.querySelector(
                    '[data-product-dialog]'
                );

                const status = root.querySelector(
                    '[data-product-share-status]'
                );

                let openedThroughPush = false;

                function productURL(productID) {
                    const url = new URL(
                        window.location.href
                    );

                    url.searchParams.set(
                        parameter,
                        productID
                    );

                    return url;
                }

                function baseURL() {
                    const url = new URL(
                        window.location.href
                    );

                    url.searchParams.delete(
                        parameter
                    );

                    return url;
                }

                function panelFor(productID) {
                    if (!dialog || !productID) {
                        return null;
                    }

                    return Array.from(
                        dialog.querySelectorAll(
                            '[data-product-panel]'
                        )
                    ).find(
                        panel =>
                            panel.dataset.productPanel
                            === productID
                    ) || null;
                }

                function currentProductID() {
                    return new URL(
                        window.location.href
                    ).searchParams.get(
                        parameter
                    );
                }

                function showPanel(productID) {
                    if (!dialog) {
                        return false;
                    }

                    const panel =
                        panelFor(productID);

                    if (!panel) {
                        return false;
                    }

                    dialog
                        .querySelectorAll(
                            '[data-product-panel]'
                        )
                        .forEach(candidate => {
                            candidate.hidden =
                                candidate !== panel;
                        });

                    dialog.dataset.activeProduct =
                        productID;

                    if (!dialog.open) {
                        dialog.showModal();
                    }

                    document.documentElement
                        .classList
                        .add(
                            'wc-product-dialog-open'
                        );

                    return true;
                }

                function hideDialog() {
                    if (!dialog) {
                        return;
                    }

                    if (dialog.open) {
                        dialog.close();
                    }

                    delete dialog.dataset
                        .activeProduct;

                    dialog
                        .querySelectorAll(
                            '[data-product-panel]'
                        )
                        .forEach(panel => {
                            panel.hidden = true;
                        });

                    document.documentElement
                        .classList
                        .remove(
                            'wc-product-dialog-open'
                        );
                }

                function openProduct(
                    productID,
                    updateHistory = true
                ) {
                    if (!showPanel(productID)) {
                        return;
                    }

                    if (updateHistory) {
                        window.history.pushState(
                            {
                                wcProduct:
                                    productID,
                                wcCatalog:
                                    root.id
                            },
                            '',
                            productURL(productID)
                        );

                        openedThroughPush = true;
                    }
                }

                function closeProduct() {
                    if (!dialog?.open) {
                        return;
                    }

                    if (
                        openedThroughPush
                        && currentProductID()
                    ) {
                        openedThroughPush =
                            false;

                        window.history.back();
                        return;
                    }

                    window.history.replaceState(
                        window.history.state,
                        '',
                        baseURL()
                    );

                    hideDialog();
                }

                function syncFromURL() {
                    const productID =
                        currentProductID();

                    if (
                        productID
                        && showPanel(productID)
                    ) {
                        return;
                    }

                    hideDialog();
                }

                function setStatus(message) {
                    if (!status) {
                        return;
                    }

                    status.textContent =
                        message;

                    window.setTimeout(
                        () => {
                            if (
                                status.textContent
                                === message
                            ) {
                                status.textContent =
                                    '';
                            }
                        },
                        4000
                    );
                }

                async function copyURL(url) {
                    if (
                        navigator.clipboard
                        && window.isSecureContext
                    ) {
                        await navigator
                            .clipboard
                            .writeText(
                                url.toString()
                            );

                        return;
                    }

                    const input =
                        document.createElement(
                            'textarea'
                        );

                    input.value =
                        url.toString();

                    input.setAttribute(
                        'readonly',
                        ''
                    );

                    input.style.position =
                        'fixed';

                    input.style.opacity =
                        '0';

                    document.body.appendChild(
                        input
                    );

                    input.select();

                    document.execCommand(
                        'copy'
                    );

                    input.remove();
                }

                async function copyProductURL(
                    productID
                ) {
                    const url =
                        productURL(productID);

                    try {
                        await copyURL(url);

                        setStatus(
                            'Productlink gekopieerd.'
                        );
                    } catch {
                        setStatus(
                            'De productlink kon niet worden gekopieerd.'
                        );
                    }
                }

                async function shareProduct(
                    productID,
                    productTitle
                ) {
                    const url =
                        productURL(productID);

                    const shareData = {
                        title:
                            productTitle,
                        text:
                            productTitle,
                        url:
                            url.toString()
                    };

                    try {
                        if (navigator.share) {
                            await navigator.share(
                                shareData
                            );

                            setStatus(
                                'Product gedeeld.'
                            );

                            return;
                        }

                        await copyProductURL(
                            productID
                        );
                    } catch (error) {
                        if (
                            error?.name
                            === 'AbortError'
                        ) {
                            return;
                        }

                        await copyProductURL(
                            productID
                        );
                    }
                }

                root.addEventListener(
                    'click',
                    event => {
                        const openTrigger =
                            event.target.closest(
                                '[data-product-open]'
                            );

                        if (openTrigger) {
                            event.preventDefault();

                            openProduct(
                                openTrigger
                                    .dataset
                                    .productOpen
                            );

                            return;
                        }

                        const copyTrigger =
                            event.target.closest(
                                '[data-product-copy]'
                            );

                        if (copyTrigger) {
                            event.preventDefault();
                            event.stopPropagation();

                            copyProductURL(
                                copyTrigger
                                    .dataset
                                    .productCopy
                            );

                            return;
                        }

                        const shareTrigger =
                            event.target.closest(
                                '[data-product-share]'
                            );

                        if (shareTrigger) {
                            event.preventDefault();
                            event.stopPropagation();

                            shareProduct(
                                shareTrigger
                                    .dataset
                                    .productShare,
                                shareTrigger
                                    .dataset
                                    .productTitle
                                    || document.title
                            );

                            return;
                        }

                        const closeTrigger =
                            event.target.closest(
                                '[data-product-close]'
                            );

                        if (closeTrigger) {
                            event.preventDefault();
                            closeProduct();
                        }
                    }
                );

                if (dialog) {
                    dialog.addEventListener(
                        'click',
                        event => {
                            if (event.target === dialog) {
                                closeProduct();
                            }
                        }
                    );

                    dialog.addEventListener(
                        'cancel',
                        event => {
                            event.preventDefault();
                            closeProduct();
                        }
                    );
                }

                window.addEventListener(
                    'popstate',
                    () => {
                        openedThroughPush =
                            false;

                        syncFromURL();
                    }
                );

                syncFromURL();
            })();
            """
        )
    }
}
