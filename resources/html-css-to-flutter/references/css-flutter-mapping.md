# CSS → Flutter mapping

## Layout

| CSS | Flutter | Notes |
|-----|---------|-------|
| `display: flex; flex-direction: row` | `Row` | Set `mainAxisAlignment`, `crossAxisAlignment` |
| `flex-direction: column` | `Column` | |
| `gap: Npx` | `Gap(N)` on Row/Column (Flutter 3.16+) or `SizedBox` between children | |
| `justify-content` | `MainAxisAlignment` | `flex-start` → `start`, `center` → `center`, `space-between` → `spaceBetween` |
| `align-items` | `CrossAxisAlignment` | |
| `flex: 1` | `Expanded` | Child of Row/Column |
| `flex-shrink: 0` | Avoid `Expanded`; use fixed size | |
| `align-self` | Per-child `Align` or different `CrossAxisAlignment` via wrapper | |
| `position: absolute` | `Stack` + `Positioned` | |
| `position: fixed` (viewport) | Top-level `Stack` or `Scaffold` body | |
| `overflow: auto/scroll` | `SingleChildScrollView` / `ListView` | Avoid nested scroll |
| `min-height: 100vh` | `SizedBox(height: MediaQuery.sizeOf(context).height)` or `Column` + `Expanded` | |

## Box model

| CSS | Flutter |
|-----|---------|
| `padding` | `Padding` |
| `margin` | `SizedBox` or parent padding |
| `width` / `height` fixed px | `SizedBox(width:, height:)` |
| `max-width` | `ConstrainedBox(constraints: BoxConstraints(maxWidth:))` |
| `min-width` / `min-height` | `ConstrainedBox` with `minWidth` / `minHeight` |
| `border-radius` | `BorderRadius.circular` / `BorderRadius.only` |
| `border` | `BoxDecoration(border: Border.all(...))` |
| `box-shadow` | `BoxDecoration(boxShadow: [BoxShadow(...)])` |
| `background` color | `Container(color:)` or `BoxDecoration(color:)` |
| `background-image` | `DecorationImage` or asset `Image` |
| `opacity` | `Opacity` widget or color alpha |

## Typography

| CSS | Flutter |
|-----|---------|
| `font-size` | `TextStyle.fontSize` |
| `font-weight` | `FontWeight.w400` … `w700` |
| `line-height` | `TextStyle.height` as multiplier (computed line-height ÷ font-size) |
| `letter-spacing` | `TextStyle.letterSpacing` |
| `text-align` | `TextAlign` on `Text` |
| `text-decoration` | `TextStyle.decoration` |
| `text-overflow: ellipsis` | `overflow: TextOverflow.ellipsis`, `maxLines` |
| `white-space: nowrap` | `maxLines: 1` + ellipsis if needed |

## Flexbox alignment cheat sheet

| CSS `justify-content` | `MainAxisAlignment` |
|-----------------------|---------------------|
| `flex-start` | `start` |
| `flex-end` | `end` |
| `center` | `center` |
| `space-between` | `spaceBetween` |
| `space-around` | `spaceAround` |
| `space-evenly` | `spaceEvenly` |

| CSS `align-items` | `CrossAxisAlignment` |
|-------------------|----------------------|
| `flex-start` | `start` |
| `flex-end` | `end` |
| `center` | `center` |
| `stretch` | `stretch` |
| `baseline` | `baseline` (text rows) |

## Common pitfalls

- `%` width → needs parent constraint; use `LayoutBuilder` or `FractionallySizedBox`.
- `line-height: normal` → measure from Computed tab; do not guess.
- Web fonts → copy to `assets/fonts/` + declare in `pubspec.yaml`.
- Native `button` / `input` styles → use tokens, not browser defaults.
- `z-index` → `Stack` child order (later children paint on top).
- `transform: translate` → prefer layout fix; if used, `Transform.translate` with debt note in Port Report.
