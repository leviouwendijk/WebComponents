WebComponents HTML Gating — Pre-Cutover Snapshot
================================================

Captured during the 2026-08-22 semantic site-construction migration.

Purpose
-------
HTML no longer owns BuildEnvironment-based semantic existence.

Constructors now resolves environment-specific page existence through
SiteProjection and no longer forwards gate semantics into HTML rendering.

This archive preserves the WebComponents source that still knew how to
traverse/reconstruct HTMLGate nodes before that obsolete structural knowledge
was removed.

Old traversal
-------------
HTML semantic/content transformation
    ↓
HTMLElement
    recurse children
    ↓
HTMLInlineGroup
    recurse children
    ↓
HTMLGate
    reconstruct gate
    recurse children

Replacement
-----------
Projected semantic content
    ↓
ordinary HTML structure
    ↓
WebComponents-local transformations
    ↓
HTML serialization

WebComponents does not acquire a replacement environment gate.

This archive exists specifically so later `webs*` migration can inspect the
old assumptions without recovering them from git history.
