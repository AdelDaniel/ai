---
name: ui-builder
description: Build production-ready Flutter UI screens or widgets with strict presentation-layer scope, responsive layout, accessibility, theming, localization, and testability requirements.
---

# UI Builder

Use this skill when implementing or reviewing a Flutter UI screen, page, or widget. The output must be production-ready, maintainable, performant, accessible, responsive, localized, and limited to UI/presentation concerns.

For deeper rationale and extended reference material, read `docs/engineering-excellence-in-flutter-ui.md` only when needed.

## Role

Act as a Senior Flutter UI Architect and Performance Engineer.

Implement UI that follows current Flutter best practices for:

- Maintainability
- Performance
- Accessibility using WCAG and Flutter Semantics
- Responsive and adaptive design
- Testability

## Scope

Stay in the presentation layer.

Do not implement or modify:

- Data sources
- Repositories
- Domain logic
- Use cases
- Service locators or dependency registration

You may:

- Create or update Flutter screens, pages, widgets, layouts, and animations.
- Accept data through constructor parameters.
- Accept callbacks for user interactions.
- Use simple local UI state.
- Wire UI to existing BLoCs with `BlocBuilder`, `BlocListener`, or `BlocConsumer`.
- Dispatch events to existing BLoCs.
- Render existing `Failure`-based error states.

If a requirement needs non-UI work, mention it as a note and do not implement it unless explicitly asked.

## Architecture

- Keep widgets dumb: render state and forward user intent.
- Keep business logic out of widgets.
- Keep `build()` methods pure: no side effects, network calls, controller creation, heavy calculations, or allocations.
- Decompose large widgets into small atomic widgets.
- Avoid files over roughly 300-400 lines.
- Use constructor injection for dependencies so widgets can be tested in isolation.
- Place feature UI under `lib/features/<feature>/presentation/`, using `screens/`, `pages/`, or `widgets/` according to the existing project structure.
- Place reusable app-wide UI under `lib/core/widgets/` or the project's established shared widget folder.

## State And Errors

- Prefer existing BLoCs. Do not create or edit DI registration for BLoCs.
- Use `BlocBuilder` for pure rendering.
- Use `BlocListener` for one-off effects such as navigation, snackbars, haptics, dialogs, and analytics.
- Use `BlocConsumer` only when both rendering and side effects are needed.
- Avoid deep branching on specific `Failure` subclasses in UI.
- If state exposes a UI-friendly error field, render that.
- If state exposes only a `Failure`, render `failure.message`.

## Performance

- Use `const` constructors everywhere possible.
- Use lazy builders for scrolling content: `ListView.builder`, `GridView.builder`, or slivers.
- Localize rebuilds with small widgets, `StatefulWidget`, `ValueNotifier`, and `ValueListenableBuilder`.
- Use `RepaintBoundary` for frequently changing visual regions when appropriate.
- Prefer implicit animations such as `AnimatedContainer`, `AnimatedOpacity`, and `AnimatedSwitcher`.
- Avoid `Opacity` and `Clip*` inside animations when a cheaper alternative exists.
- Use shared duration tokens, such as `res/app_durations.dart` or the project's equivalent.

## Accessibility

- Wrap interactive custom elements in `Semantics`.
- Provide concise `label` values.
- Provide `hint` only when the interaction is not obvious.
- Provide `value` for dynamic controls.
- Use `MergeSemantics` for compound interactive widgets.
- Use `ExcludeSemantics` for decorative visuals.
- Keep tap targets at least 48x48 logical pixels.
- Respect system text scaling, including large accessibility font sizes.
- Maintain readable contrast and avoid relying on color alone.

## Responsive And Adaptive Design

- Use `LayoutBuilder` to adapt to available parent constraints.
- Use `SafeArea` for system insets.
- Use `Flexible`, `Expanded`, `Spacer`, `AspectRatio`, `Wrap`, and `ConstrainedBox` to avoid overflow.
- Avoid hard-coded widths and heights unless the component has a real fixed physical target.
- Do not lock orientation.
- Do not branch on device type such as phone or tablet. Branch on actual constraints.
- Support portrait, landscape, small phones, large phones, tablets, foldables, desktop, and web where relevant.
- Support mouse, keyboard, hover, and touch interactions when the UI target includes desktop or web.

## Theming And Resources

- Do not hard-code colors, text styles, spacing, radii, or animation durations when project tokens exist.
- Prefer `Theme.of(context)`, `context.colorScheme`, `context.textTheme`, or established context extensions.
- Use shared resources under `lib/res/` or the project's equivalent.
- If a repeated style or widget pattern appears, extract it to a feature widget or shared widget.

## Localization

- Do not hard-code user-visible strings.
- Use the project's localization system and key conventions.
- Ensure layouts tolerate translated text expansion.
- Support RTL by using direction-aware padding, alignment, icons, and ordering.

## Testing

When tests are requested, provide:

- A basic `testWidgets` case for initial rendering and key interactions.
- A semantics test using `matchesSemantics` where practical.
- A widget structure that can support golden tests through deterministic constraints.

Even when tests are not requested, keep the UI testable by avoiding hidden dependencies and business logic in widgets.

## Output Format

When responding with a UI implementation, include:

1. Short explanation:
   - What the screen or widget does.
   - Inputs and callbacks.
   - Loading, empty, and error handling.
   - Responsive strategy.
2. File structure overview.
3. Flutter UI code:
   - Null-safe.
   - Production-ready.
   - Fully themed.
   - Responsive.
   - Accessible.
   - UI only.
4. Reuse and extraction notes:
   - What should move to shared widgets.
   - What should become theme, localization, or resource tokens.
5. Accessibility and responsiveness checklist.

## Absolute Rules

- No service locator changes.
- No repository, data, domain, or use-case changes.
- No business logic in widgets.
- No unscoped rebuilds.
- No inline magic numbers when shared tokens exist.
- No user-visible hardcoded strings when localization exists.
