# Atomic Dev

**A skill-based agentic framework for the software development lifecycle.**

Atomic Dev enriches your development workflow with session-aware AI-generated documentation, versioned as first-class artifacts and integrated into git. Five composable baseline skills form a lightweight agent team that grows with your repository. Code and documentation commit together, automatically.

---

## Install

```bash
curl -sSL https://raw.githubusercontent.com/guilleastr/atomicdev/master/install.sh | sh
```

The installer auto-detects which IDE conventions exist in your repo and pre-selects them as install targets — detected directories are highlighted in green:

```
Detecting IDE conventions
  ● .agents/skills/   detected  (standard — Copilot, OpenCode, Codex)
  ● .claude/skills/   detected  (Claude Code)
  ○ .github/agents/   not found

Select install targets [1 2]:
```

Confirm or adjust, and the installer handles the rest.

### Options

```bash
# update framework skills to latest (never touches repo skills)
curl -sSL .../install.sh | sh -s -- --update

# preview what would be installed without making changes
curl -sSL .../install.sh | sh -s -- --dry-run

# remove IDE-specific symlinks once no longer needed
curl -sSL .../install.sh | sh -s -- --cleanup
```

---

## How It Works

### The Five Baseline Skills

Framework skills are prefixed with `atomicdev-`. Repo-specific skills carry no prefix — ownership is always clear at a glance.

| Skill | Directory | Responsibility |
|---|---|---|
| **AtomicDev Core** | `atomicdev-core/` | Workflow definition and skill ownership. Read first. |
| **Code Explorer** | `atomicdev-code-explorer/` | Spatial navigation — where things are and how they connect. |
| **Planner** | `atomicdev-planner/` | Orchestrates the session, assesses plan confidence, runs deliberation. |
| **Code Implementation** | `atomicdev-code-implementation/` | Executes, verifies, and explains what it did and why. |
| **Docs Creator** | `atomicdev-docs-creator/` | Triggered by pre-commit hook. Updates skill timelines, writes commit messages. |

### The Session Model

A session is one unit of developer intent — it starts when you give the agent a task and ends when you commit or abandon the work.

- **Branch-scoped** — switching branches does not carry session state across.
- **Resumable** — closing your IDE mid-session suspends it. Reopening resumes it.
- **Ephemeral** — session context lives in `.agents/session.json` (gitignored) and is discarded after a successful commit.
- **Preserved in skills** — the knowledge captured during a session is baked into the skill artifacts committed alongside your code.

### The Workflow

```
you give the agent an intent
        ↓
Planner gathers context via Code Explorer
        ↓
Planner compiles a draft plan
        ↓
three judges assess confidence
  → high confidence: proceed
  → low confidence or disagreement: deliberate
        ↓
Code Implementation executes, verifies, explains
        ↓
you accept or reject
        ↓
pre-commit hook → Docs Creator updates skills and writes commit message
        ↓
atomic commit: code + docs + commit message, together
```

### Confidence Threshold and Deliberation

The Planner uses three agent judges to assess plan readiness before implementation. Deliberation fires only when needed — when judges disagree or confidence is low:

- **The Pragmatist** — is this the simplest solution?
- **The Architect** — does this fit the system design?
- **The Skeptic** — what can go wrong?

Minority concerns are preserved in the skill timeline, not discarded.

### Skills Grow With Your Repo

The five baseline skills are a starting point. As your repository matures, new repo-specific skills are generated — either on your request or when the Planner detects a capability gap. The skill library becomes a versioned, evolvable cognitive map of your codebase.

---

## Directory Structure

After installation:

```
your-repo/
  .agents/
    skills/
      atomicdev-core/         ← base meta-skill, read first
        SKILL.md
      atomicdev-code-explorer/
        SKILL.md
      atomicdev-planner/
        SKILL.md
      atomicdev-code-implementation/
        SKILL.md
      atomicdev-docs-creator/
        SKILL.md
      [your-repo-skills/]     ← generated as your repo matures, no prefix
        SKILL.md
    config.json               ← your installation config
    session.json              ← gitignored, ephemeral, discarded after commit
  AGENTS.md                   ← system-wide instructions for all agents
  .git/hooks/pre-commit       ← Docs Creator trigger
```

---

## IDE Support

Atomic Dev is built on `.agents/skills/` as its canonical location — the emerging cross-IDE standard.

| IDE | Support |
|---|---|
| GitHub Copilot (agent mode) | Native — reads `.agents/skills/` directly |
| Claude Code | Via symlinks from `.claude/skills/` → `.agents/skills/` |
| OpenCode, Codex CLI | Native — reads `.agents/skills/` directly |
| GitHub Copilot (`.github/agents/`) | Via symlinks if selected at install |

Run `--cleanup` to remove symlinks once your IDE supports `.agents/` natively.

---

## Philosophy

> **The conversation is the scaffold. The skill is the residue.**

Documentation is not a byproduct of development — it is institutional knowledge. Atomic Dev makes that knowledge versioned, evolvable, and automatic.

---

## License

MIT
