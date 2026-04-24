# Repository Guidelines

## Project Structure & Module Organization

This repository is an `.ai` resource workspace for reusable AI guidance, not an application package. Keep project-level documentation at the repository root. Put reusable resources under `.ai/`: task workflows in `.ai/skills/<skill-name>/`, shared guidance in `.ai/instructions/`, and reusable prompts in `.ai/templates/`. Create `.ai/agents/` only when adding reusable role definitions. Use lowercase kebab-case for resource folders and Markdown files, except required names like `SKILL.md`.

## Build, Test, and Development Commands

There is no package build step in this repository. Useful validation commands are:

```sh
rg --files --hidden -g '!.git'
```

Lists all tracked-style workspace files for a quick structure check.

```sh
sh -n .ai/skills/pub-dev-release/scripts/release-context.sh
```

Syntax-checks the release helper script without running it.

```sh
sh .ai/skills/pub-dev-release/scripts/release-context.sh
```

Runs the release-context helper when maintaining the `pub-dev-release` skill. Expect it to report missing `pubspec.yaml` in this workspace unless run from a Dart/Flutter package repository.

## Coding Style & Naming Conventions

Use concise, model-agnostic Markdown. Prefer short imperative instructions, concrete examples, and fenced code blocks for commands. Keep entry files readable; move long checklists, examples, or references into supporting folders. Shell scripts should be POSIX-compatible where practical, start with `#!/usr/bin/env sh`, and use `set -eu` for fail-fast behavior.

## Testing Guidelines

No automated test suite is currently configured. For documentation changes, verify headings, links, and examples manually. For script changes, run `sh -n` and then execute the script in a safe repository context. When adding a new executable helper, include a short usage note in the relevant `SKILL.md` or `README.md`.

## Commit & Pull Request Guidelines

This repository currently has no committed Git history, so there is no existing convention to mirror. Use concise imperative commit messages with an optional scope, for example `skills: add pub.dev release checklist` or `templates: clarify resource prompt`. Pull requests should describe the resource added or changed, list affected paths, explain how it was validated, and link related issues when available. Include screenshots only for rendered documentation changes where visual formatting matters.

## Agent-Specific Instructions

Before adding resources, read `README.md`, `.ai/README.md`, and `.ai/instructions/ai-behavior.md`. Keep edits surgical, avoid duplicating existing workflows, and update `.ai/README.md` when adding a new reusable resource.

## AI Behavior Guidelines

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

### 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

### 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

### 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

### 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:

- "Add validation" -> "Write tests for invalid inputs, then make them pass"
- "Fix the bug" -> "Write a test that reproduces it, then make it pass"
- "Refactor X" -> "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:

```text
1. [Step] -> verify: [check]
2. [Step] -> verify: [check]
3. [Step] -> verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.
