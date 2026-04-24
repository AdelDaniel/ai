# Add Resource To `.ai`

Use this prompt when you want an AI coding tool to add a new reusable skill, agent, instruction, template, or other AI-related resource to this repository's `.ai/` folder.

```text
You are working in this repository. Add the following reusable AI resource to the `.ai/` folder so it can be used by any AI coding tool in the future.

Resource request:
[Describe the skill, agent, instruction, template, checklist, prompt, or other AI resource to add.]

Before editing:
1. Read `.ai/README.md` to understand the current folder structure and conventions.
2. Read `.ai/instructions/ai-behavior.md` and follow those behavior guidelines while working.
3. Inspect existing `.ai/` resources so the new resource fits the current style.

Placement rules:
- Put reusable task workflows under `.ai/skills/<skill-name>/SKILL.md`.
- Put reusable agent role definitions under `.ai/agents/<agent-name>.md`.
- Put shared behavior or project guidance under `.ai/instructions/<instruction-name>.md`.
- Put reusable prompts, response formats, or checklists under `.ai/templates/<template-name>.md`.
- Create only the directories and supporting files needed for this resource.
- Use lowercase kebab-case for folder and file names, except required entry files like `SKILL.md`.

Quality rules:
- Keep the resource model-agnostic and usable by Codex, Claude Code, Gemini CLI, Cursor, or other LLM tools.
- Avoid tool-specific assumptions unless the resource is explicitly a tool adapter.
- Keep instructions concise and actionable.
- Move long supporting content into `docs/`, `examples/`, `scripts/`, `instructions/`, or `templates/` as appropriate.
- Do not duplicate existing resources; update an existing resource if that is the cleaner fit.
- Update `.ai/README.md` so the new resource appears in the current contents list.

After editing, report:
- The resource type and name.
- The files added or changed.
- How to use the new resource in the future.
```
