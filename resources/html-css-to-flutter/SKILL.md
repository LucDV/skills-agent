---
name: html-css-to-flutter
description: >
  Convert a single web screen (HTML/CSS) into native Flutter widgets with
  pixel-faithful layout. Use when the user provides HTML/CSS source plus
  screenshot(s) as ground truth, or asks to port a web page/section to Flutter.
  Enforces token-first, component-by-component workflow; screenshot overrides CSS guesses.
metadata:
  triggers:
    - html to flutter
    - css to flutter
    - convert html css flutter
    - port web to flutter
    - pixel perfect flutter
    - html/css screenshot flutter
    - chuyen html sang flutter
    - html css flutter
    - /html-css-to-flutter
---

# HTML/CSS → Flutter (Native Port)

Port **one screen or one section** from web to **native Flutter widgets** (no WebView unless the user explicitly opts out).

**Ground truth order:** screenshot > computed tokens > HTML structure > raw CSS file text.

---

## 🛑 HARD GATE — Required inputs (before any Dart)

Do **not** write Flutter code until **all** of the following are present or explicitly waived by the user.

| Input | Required | Purpose |
|-------|----------|---------|
| **Screenshot(s)** | YES | Visual ground truth (full screen + crops for complex sections) |
| **HTML** | YES | DOM structure, semantics, element hierarchy |
| **CSS** | YES (or inline in HTML) | Class names, rules — used with structure, not as sole sizing source |
| **Target breakpoint** | YES if responsive web | Width×height (e.g. 390×844). If unknown, ask once. |
| **Flutter project context** | Preferred | `pubspec.yaml` path, feature folder name, Material vs Cupertino |

If screenshot is missing: **STOP** and ask the user to attach it. Do not proceed on HTML/CSS alone.

If numeric spacing/colors are disputed: **screenshot wins**; mark unresolved items in `## Open Visual Gaps`.

Optional but valuable: token JSON per `references/input-contract.md`, font files (`.woff2`/`.ttf`), asset list.

---

## Operating rules (non-negotiable)

1. **No whole-screen one-shot** — decompose into a widget tree first; implement **one component per iteration** unless the screen has ≤3 trivial widgets.
2. **No guessed metrics** — if `fontSize`, `padding`, `gap`, `borderRadius`, or colors are not in provided tokens and not clearly readable from screenshot + DevTools guidance, **STOP and ask**; do not invent values.
3. **Do not trust raw CSS alone** — cascade, `%`, `rem`, `em`, `calc()`, `@media`, and browser defaults change computed layout. Prefer user-supplied **computed tokens** or instruct user to extract via DevTools (see Phase 1).
4. **Screenshot comparison mandatory** — after each component and after full screen assembly, list visual diffs vs screenshot.
5. **Native widgets only** — `Row`, `Column`, `Stack`, `Container`, `DecoratedBox`, `Text`, etc. No `flutter_html` / WebView unless user requests hybrid.
6. **Preserve feature naming** — use user-provided screen name (e.g. `login_screen.dart`), snake_case files, PascalCase widgets.
7. **Minimize scope** — do not add navigation, state management, or API unless asked.

---

## Phase 0: Intake & screen classification

Classify the screen (adjust checklist):

| Type | Code | Focus |
|------|------|--------|
| Form-heavy | `form` | `TextField`, keyboard inset, button heights, validation UI |
| Marketing / landing | `landing` | hero, gradients, multi-section scroll |
| Dashboard / list | `dashboard` | scroll nesting, cards, grids, sidebars |

Ask **one** question only if unclear: screen type `form` | `landing` | `dashboard`.

Deliver: `## Widget Tree` (ASCII or bullet tree, max depth 4) for user confirmation before Phase 2.

**🛑 FULL STOP:** Ask user: "Confirm widget tree before implementation? (yes/no)"

---

## Phase 1: Extract design contract

Produce `reference/tokens.json` (or embed in session artifact) using this priority:

1. User-provided token JSON (best)
2. Instruct user to copy **Computed** styles from DevTools for key nodes (see `references/input-contract.md`)
3. Infer **only** colors/sizes clearly visible and consistent in screenshot — label as `[VISUAL-ESTIMATE]` (max 5 per screen; prefer asking)

Also document:

- Font families → must map to Flutter `fontFamily` + `pubspec` font assets
- Images/icons → paths or ask user for assets
- Breakpoint used for screenshot

Deliver: `## Design Tokens` summary table (colors, type scale, spacing scale, radii, shadows).

---

## Phase 2: Theme foundation (first code)

Create or extend:

- `app_colors.dart` / `app_text_styles.dart` / `app_spacing.dart` (or project convention)

Rules:

- All magic numbers for the screen must come from tokens/theme.
- `ThemeData` only if it reduces duplication; do not fight existing project theme.

**Checkpoint:** Theme matches screenshot background + primary text style on a blank `Scaffold`.

---

## Phase 3: Component implementation (loop)

For each widget in the tree (top → bottom):

1. Read HTML fragment for **that** subtree only.
2. Read relevant CSS selectors (class/id) for that subtree.
3. Use screenshot crop if provided.
4. Implement **one** `StatelessWidget` (or `StatefulWidget` if interaction visible).
5. Map layout using `references/css-flutter-mapping.md`.
6. Output diff notes: `## Component: <Name> — Visual diff`

**Do not** refactor previously approved components in later passes unless fixing a registered gap.

Suggested file layout:

```text
lib/features/<feature>/
  <screen>_screen.dart
  widgets/<component>.dart
test/features/<feature>/
  <screen>_golden_test.dart   # if project uses golden tests
reference/                    # optional, not shipped
  screenshots/
  tokens.json
```

---

## Phase 4: Screen assembly

- Compose children in `*_screen.dart` matching widget tree order.
- `SafeArea`, `Scaffold`, scroll wrapper (`SingleChildScrollView` vs `ListView`) per web behavior.
- Fix constraint errors (unbounded height/width) without changing approved token values.

---

## Phase 5: Verification

Run checklist:

- [ ] Full screenshot side-by-side review (list ≥3 possible deltas)
- [ ] Fonts embedded and applied
- [ ] Safe area / status bar
- [ ] Scroll behavior (single vs nested)
- [ ] Form: keyboard does not obscure inputs (`resizeToAvoidBottomInset`, padding)
- [ ] Tap targets ≥ 48dp where web had buttons
- [ ] No hardcoded colors outside theme (except `[VISUAL-ESTIMATE]` documented)

If project has tests: offer golden file `goldens/<screen>.png` — do not update goldens without user approval.

Deliver final: `## Port Report` with Open Visual Gaps, files created, and follow-up tasks (fonts, assets, second breakpoint).

---

## Reference map

| File | Content |
|------|---------|
| `references/input-contract.md` | Token JSON schema, DevTools extraction steps |
| `references/css-flutter-mapping.md` | CSS property → Flutter widget map |
| `references/prompt-templates.md` | Per-component prompts for sub-agents |

---

## Guardrails

- **Never** implement entire app from multi-page HTML in one task.
- **Never** replace screenshot judgment with CSS file parsing alone.
- **Never** use `Transform` hacks to fake alignment without noting debt in Port Report.
- **Stop** if HTML uses heavy JS for layout — request static HTML snapshot or screenshot-only mode.

---

## Handoff Contract (SOT)

[PRIMARY METHOD]
You MUST follow this skill when the user invokes `/html-css-to-flutter` or attaches HTML/CSS + screenshot for Flutter port.

[FALLBACK METHOD]
If the command route is unavailable, load `html-css-to-flutter` via `get_registry_item({ target_type: "skill", name: "html-css-to-flutter" })`.

[FAILURE BEHAVIOR]
If both fail, FALLBACK to reading `.agent/skills/html-css-to-flutter/SKILL.md`. If missing, STOP and report blocker.

**Sub-agent dispatch (optional):** For parallel components, follow `subagent-orchestration` with one job per component, shared `tokens.json` + screenshot crops in context. Max 10 jobs; each job scoped to a single widget.

Execution contract for `subagent-orchestration`:

- Primary route: load `subagent-orchestration` via `get_registry_item({ target_type: "skill", name: "subagent-orchestration" })`.
- Fallback route: read `.agent/skills/subagent-orchestration/SKILL.md`.
- If both fail: STOP; do not dispatch sub-agents without orchestration rules.

---

## Maintenance

After editing this skill, re-index: `./kit engine-index brain`
