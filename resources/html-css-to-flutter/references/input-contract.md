# Input contract — HTML/CSS + Screenshot → Flutter

## Required user package

Attach or path-reference:

1. `screenshot-full.png` — full screen at target breakpoint
2. `screenshot-*.png` — optional crops per component
3. `index.html` (or fragment) + `*.css` (all linked stylesheets)
4. `breakpoint`: `{ "width": 390, "height": 844 }`
5. `screen_name`: e.g. `login` → files `login_screen.dart`

## Token JSON schema (v1)

```json
{
  "breakpoint": { "width": 390, "height": 844 },
  "screenName": "login",
  "colors": {
    "background": "#F5F5F5",
    "primary": "#2563EB",
    "textPrimary": "#111827",
    "textSecondary": "#6B7280"
  },
  "typography": {
    "h1": {
      "fontSize": 24,
      "fontWeight": 600,
      "lineHeight": 32,
      "letterSpacing": 0,
      "fontFamily": "Inter"
    },
    "body": {
      "fontSize": 14,
      "fontWeight": 400,
      "lineHeight": 20,
      "fontFamily": "Inter"
    }
  },
  "spacing": { "xs": 4, "sm": 8, "md": 16, "lg": 24, "xl": 32 },
  "radii": { "sm": 4, "md": 8, "lg": 12 },
  "shadows": {
    "card": {
      "color": "#0000001A",
      "offsetX": 0,
      "offsetY": 2,
      "blurRadius": 8,
      "spreadRadius": 0
    }
  },
  "components": {}
}
```

`components` holds per-widget overrides, e.g. `primaryButton.height`.

## DevTools extraction (when user has no JSON)

1. Open page in Chrome at target breakpoint (device toolbar).
2. Inspect node → **Computed** tab.
3. Record: `width`, `height`, `padding-*`, `margin-*`, `gap`, `font-size`, `font-weight`, `line-height`, `color`, `background-color`, `border-radius`, `box-shadow`.
4. Repeat for each component root in the widget tree.
5. Save as `tokens.json` next to screenshots.

## Evidence labels in reports

| Label | Meaning |
|-------|---------|
| `[TOKEN]` | From tokens.json / DevTools |
| `[SCREENSHOT]` | Matched visually |
| `[VISUAL-ESTIMATE]` | Approximate — needs user confirm |
| `[GAP]` | Could not match — listed in Open Visual Gaps |
