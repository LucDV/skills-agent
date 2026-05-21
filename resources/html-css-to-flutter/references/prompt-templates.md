# Prompt templates (host → implementer agent)

Use with skill `html-css-to-flutter`. Always attach screenshot + tokens when available.

## Template: Theme only (Phase 2)

```text
Skill: html-css-to-flutter — Phase 2 only.
Inputs: tokens.json attached, screenshot attached.
Task: Create app_colors, app_text_styles, app_spacing (or match project convention). No screen widgets.
Rules: All values from tokens; no guesses. Label any gap [GAP].
Output: File paths + mapping table token → Dart constant.
```

## Template: Single component (Phase 3)

```text
Skill: html-css-to-flutter — Phase 3.
Component: <PrimaryButton>
Inputs:
- HTML fragment: <paste>
- CSS selectors: .btn-primary
- tokens.components.primaryButton (if present)
- screenshot crop: button.png
Task: Implement <PrimaryButton> as StatelessWidget only.
Rules: Do not edit other files. STOP if a required number is missing.
Output: widget Dart file + ## Visual diff (max 5 bullets).
```

## Template: Full screen assembly (Phase 4)

```text
Skill: html-css-to-flutter — Phase 4.
Inputs: Approved widgets: [Header, LoginForm, Footer]
Task: Compose <LoginScreen> in login_screen.dart.
Rules: Do not change child widget internals. Match screenshot-full.png.
Output: screen file + ## Port Report.
```

## Template: User invocation (minimal)

```text
/html-css-to-flutter

screen_name: login
breakpoint: 390 x 844
type: form
flutter_path: lib/features/auth/
files:
- login.html
- login.css
- screenshots/login-full.png
```
