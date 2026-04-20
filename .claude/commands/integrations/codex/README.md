# Codex Integration

AICoach packaged as an [OpenAI Codex](https://developers.openai.com/codex) skill,
authored to the [obra/superpowers](https://github.com/obra/superpowers) `SKILL.md`
convention. Codex loads any `SKILL.md` found under `.agents/skills/` (repo) or
`~/.agents/skills/` (user), so the superpowers format drops in without conversion.

## Layout

```
codex/
└── aicoach/
    └── SKILL.md     # YAML frontmatter + superpowers-style body
```

Per the superpowers spec, the frontmatter is:

```yaml
---
name: aicoach
description: Use when ...   # third-person, ≤500 chars, starts with "Use when"
---
```

Body sections: Overview → When to Use → Core Principle → Quick Reference →
Implementation → Common Mistakes → Real-World Impact.

## Install

### Project-scoped (recommended)

From the project you want AICoach available in:

```bash
mkdir -p .agents/skills
cp -r /path/to/aicoach/.claude/commands/integrations/codex/aicoach .agents/skills/
```

Codex scans `.agents/skills/` from CWD up to the repo root.

### User-scoped (available in every project)

```bash
mkdir -p ~/.agents/skills
cp -r /path/to/aicoach/.claude/commands/integrations/codex/aicoach ~/.agents/skills/
```

## Invoke

- **Explicit**: type `$aicoach` in the Codex prompt, or run `/skills` and pick it
- **Implicit**: Codex matches the `description` against the user's request and
  activates the skill automatically (disable per-skill by adding
  `agents/openai.yaml` with `allow_implicit_invocation: false`)

## Knowledge Base

The skill references files under `AgentGuide/` (the symlink at the project
root → `/Users/zoen/Documents/run/AgentGuide`) and the memory scripts in
`scripts/`. For the skill to load those files, run Codex from a directory
where either the `AgentGuide` symlink and `scripts/` are reachable, or the
skill is installed at user scope and Codex's working directory is the aicoach
repo.

## Regenerate

The `SKILL.md` is hand-authored against the superpowers spec. If you edit
`prompts/system-prompt.md` or `.claude/agents/aicoach.md`, update this skill
by hand — there is no converter script.
