# Configuration

Atomic Dev configuration files are stored in `.atomicdev/context/`—separate from your codebase to keep things clean.

## What Goes Here

- **`.env.atomicdev`** — Framework runtime configuration (paths, documentation, integrations, behavior)
- **`config.json`** — Installation-time settings (which IDEs)

## Key Files Explained

### `.env.atomicdev`
The central framework configuration file. Committed to git and shared across the team:
```json
{
  "framework": {
    "version": "0.1.0",
    "name": "Atomic Dev"
  },
  "paths": {
    "wiki_path": "./docs/wiki",
    "artifacts_path": "./.agents/artifacts",
    "outputs_path": "./docs/generated"
  },
  "documentation": {
    "commit_message_template": "atomic-dev"
  },
  "integrations": {
    "enabled_services": ["git", "pre-commit"],
    "external_wiki": null
  },
  "behavior": {
    "auto_create_repo_skills": true
  }
}
```

Key settings:
- **`paths.wiki_path`** — Where Docs Creator stores generated documentation
- **`paths.artifacts_path`** — Internal framework artifacts directory
- **`paths.outputs_path`** — Build outputs and generated content
- **`integrations.enabled_services`** — Which services are active
- **`behavior.auto_create_repo_skills`** — Whether Planner auto-creates repo skills on demand

For team-specific or local overrides, create `.atomicdev/context/.env.atomicdev.local` (gitignored).

### `config.json`
Generated once during `install.sh`. Defines which IDE integrations are active:
```json
{
  "version": "0.1.0",
  "targets": {
    "agents": true,       // Install skills to .agents/skills/
    "claude": false,      // Install symlinks to .claude/skills/
    "github": false       // Install symlinks to .github/agents/
  },
  "deliberation": "auto"
}
```

## How to Update Configuration

- **Framework behavior** → Edit `.atomicdev/context/.env.atomicdev` directly (paths, documentation style, integrations)
- **Local overrides** → Create `.atomicdev/context/.env.atomicdev.local` for machine-specific settings (gitignored)
- **IDE changes** → Re-run `install.sh --update` to regenerate `config.json`

All framework settings are documented in `.agents/skills/atomicdev-core/SKILL.md` under "Framework Configuration".

---

Back to [Guides Index](./index.md)
