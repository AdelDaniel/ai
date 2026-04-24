# AI Resource Workspace

This repository stores reusable AI guidance in a real `.ai/` directory so it can be copied into, referenced by, or adapted for other software projects.

## Layout

```text
.
  AGENTS.md
  README.md
  .ai/
    README.md
    instructions/
    skills/
    templates/
```

The repository root contains project-level contributor guidance. Reusable resources live under `.ai/`.

## Start Here

- [Contributor guide](AGENTS.md): Repository conventions for maintainers and coding agents.
- [AI workspace README](.ai/README.md): Structure and rules for adding reusable AI resources.
- [AI behavior guidelines](.ai/instructions/ai-behavior.md): Shared execution rules for AI-assisted work.
- [Add resource template](.ai/templates/add-ai-resource.md): Prompt for adding new reusable resources.

## Working With Resources

Add task workflows to `.ai/skills/<skill-name>/SKILL.md`, shared guidance to `.ai/instructions/`, and reusable prompts or formats to `.ai/templates/`. Create `.ai/agents/` only when adding reusable role definitions.

Keep resources model-agnostic unless a tool-specific adapter is explicitly needed.
