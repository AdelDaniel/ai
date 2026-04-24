# .ai

Shared, model-agnostic AI resources for this repository.

The `.ai/` folder keeps reusable instructions, skills, templates, and optional agent definitions in one place so they can be adapted for Codex, Claude Code, Gemini CLI, Cursor, or other LLM workflows without duplicating guidance across tool-specific folders.

## Workspace Map

```text
.ai/
  README.md
  instructions/
    ai-behavior.md
  skills/
    pub-dev-release/
      SKILL.md
      docs/
      examples/
      scripts/
  templates/
    add-ai-resource.md
```

Create new directories only when a resource needs them. For example, add `agents/` only when introducing reusable agent role definitions.

## Resource Types

- `skills/`: Task-specific workflows. Each skill lives in `skills/<skill-name>/` and uses `SKILL.md` as its entrypoint.
- `instructions/`: Shared behavior, project guidance, or policies that can be merged into AI tool prompts.
- `templates/`: Reusable prompts, response formats, checklists, or document skeletons.
- `agents/`: Optional reusable role definitions, such as release manager, reviewer, or documentation maintainer personas.

## Current Resources

- [AI behavior guidelines](instructions/ai-behavior.md): Shared execution rules for cautious, focused AI-assisted work.
- [pub-dev-release](skills/pub-dev-release/SKILL.md): Workflow for preparing Flutter or Dart package releases for pub.dev.
- [Add AI resource prompt](templates/add-ai-resource.md): Prompt template for adding future reusable resources.

## Adding Or Updating Resources

1. Read the root `AGENTS.md`, this `README.md`, and `instructions/ai-behavior.md`.
2. Check existing resources before creating a new one.
3. Put the resource in the narrowest matching folder.
4. Keep the entry file concise and move long supporting material into `docs/`, `examples/`, `scripts/`, `instructions/`, or `templates/`.
5. Update this README when the visible resource list or structure changes.

## Naming And Style

- Use lowercase kebab-case for folders and Markdown filenames: `pub-dev-release`, `add-ai-resource.md`.
- Keep required entrypoint names exact, such as `SKILL.md`.
- Write instructions in short, direct, reusable language.
- Prefer fenced code blocks for commands and file layouts.
- Avoid tool-specific assumptions unless the resource is explicitly a tool adapter.

## Portability

Keep core guidance generic. If a workflow needs a tool-specific version, preserve the generic resource here and place adapters in the target tool folder.

Examples:

- Generic release workflow: `.ai/skills/pub-dev-release/SKILL.md`
- Codex-specific adapter: `.codex/skills/pub-dev-release/SKILL.md`

## Quality Bar

- Do not duplicate an existing workflow when an update would be clearer.
- Do not invent capabilities, commands, or repository structure.
- Keep release-facing or user-facing generated text free of AI references unless explicitly requested.
- Prefer small, reviewable changes with clear validation steps.
