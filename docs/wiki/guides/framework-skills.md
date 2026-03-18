# Framework Skills

The Atomic Dev framework consists of five baseline skills that orchestrate your entire development lifecycle. Think of them as an agent team, each with a specific responsibility.

## The Five Skills

| Skill | Responsibility | When Active |
|-------|---|---|
| **Core** | Framework governance and workflow definition | Read first |
| **Code Explorer** | Maps your codebase, finds dependencies, identifies patterns | When planning and documenting |
| **Planner** | Plans the work, assesses confidence, runs deliberation | After you describe what you want |
| **Code Implementation** | Writes code, verifies it works, explains what it did | When executing the plan |
| **Docs Creator** | Generates documentation, writes commits | On `git commit` or "update docs" |

## How They Work Together

```
You: "I want to add user authentication"
  ↓
Planner
  • Asks Code Explorer to map the auth-related code
  • Gathers your intent and project context
  • Compiles a plan
  • Three judges assess confidence
  ↓
Code Implementation
  • Writes the code
  • Verifies it works
  • Explains what it did
  ↓
You accept or reject
  ↓
Git commit
  ↓
Docs Creator
  • Reads what changed
  • Updates documentation
  • Writes the commit message
```

## Skill Documentation

Each skill is documented in its SKILL.md file with clear descriptions of:
- What the skill does and when it's active
- How it works with other skills
- Key conventions and patterns

Read skill documentation to understand how the system works.

## Creating New Skills

As your repository matures, you can create **repo-specific skills** for domain patterns. The framework determines when a new skill earns its place:
- A recurring pattern that spans multiple files and contexts
- Agents can't plan adequately for it without help
- You explicitly request it

New skills are reviewed before commit—agents don't create them silently.

See `atomicdev-core` skill for full governance rules.

## Key Directories

- **`.agents/skills/`** — Where all skill files live (read these for full details)
- **`.atomicdev/context/config.json`** — Installation configuration (which IDE gets installed where)

## Where to Go Next

- **Read the full skill definitions:** `.agents/skills/*/SKILL.md`
- **Understand the workflow:** See [Getting Started](../getting-started.md)
- **Understand the workflow:** See each skill's documented workflow
- **Reference section:** [See here](../reference/index.md)

---

Back to [Guides Index](./index.md)
