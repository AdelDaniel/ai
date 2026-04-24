# .ai

This folder is the shared AI workspace for this repository. It contains model-agnostic instructions, skills, agent definitions, templates, and other AI-related resources that can be reused across tools such as Codex, Claude Code, Gemini CLI, Cursor, or any other LLM workflow.

The goal is to keep reusable AI context in one place instead of duplicating it across tool-specific files.

## Intended Structure

```text
.ai/
  README.md
  skills/
    <skill-name>/
      SKILL.md
      docs/
      examples/
      scripts/
  agents/
    <agent-name>.md
  instructions/
    <instruction-name>.md
  templates/
    <template-name>.md
```

## Directory Roles

- `skills/`: Reusable task-specific workflows. Each skill should live in its own folder and use `SKILL.md` as the entrypoint.
- `agents/`: Optional role definitions for specialized AI agents, such as release managers, reviewers, or documentation maintainers.
- `instructions/`: Shared behavioral or project-level guidance that can be merged into different AI tools.
- `templates/`: Reusable prompts, response formats, checklists, or document templates.

Only create directories when they are needed. The structure above is a convention for future additions, not a requirement that every folder must exist now.

## Current Contents

- [AI behavior guidelines](instructions/ai-behavior.md): Shared behavioral guidelines for how AI coding tools should act in this repository.
- [pub-dev-release](skills/pub-dev-release/SKILL.md): Prepare a Flutter/Dart package release for pub.dev.
- [Add AI resource prompt](templates/add-ai-resource.md): Reusable prompt for asking an AI tool to add future resources to `.ai`.

## Portability

Content in this folder should avoid tool-specific assumptions when possible. If a resource needs a tool-specific format, keep the core instructions generic and place tool-specific adapters in the relevant tool folder.

Examples:

- Generic release workflow: `.ai/skills/pub-dev-release/SKILL.md`
- Codex-specific version of the same skill: `.codex/skills/pub-dev-release/SKILL.md`

## Guidelines

- Keep instructions concise and reusable.
- Prefer clear folder names in lowercase kebab-case.
- Put long supporting material in `docs/`, `examples/`, or `instructions/` instead of making entry files too large.
- Do not duplicate the same workflow in multiple places unless a tool requires a different format.
- Keep release-facing or user-facing generated text free of tool or AI references unless explicitly requested.
