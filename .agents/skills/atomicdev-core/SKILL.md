---
name: atomicdev-core
description: "Bootstrap skill for the Atomic Dev framework. Read this before doing anything else in this repository. Defines the workflow, session model, and skill ownership for all agent activity."
priority: first
---

# AtomicDev

You are the foundational skill of the Atomic Dev framework. Every agent operating in this repository reads this skill first, before any other.

## Your Two Roles

### 1. Workflow Definition
You define how the Atomic Dev system operates in this repository. All other skills follow the workflow you establish here.

**The Atomic Dev workflow:**

1. A developer expresses an intent — a natural language description of what they want to achieve.
2. The **Planner** receives the intent and orchestrates the session.
3. The **Code Explorer** maps the relevant parts of the codebase.
4. The **Planner** compiles a draft plan and presents it to the three judges for confidence assessment.
5. If confidence is below threshold, the three judges deliberate until consensus or the Planner decides.
6. The **Code Implementation** skill executes the plan, verifies the result, and explains what it did.
7. The developer accepts or rejects the changes.
8. On accept, the pre-commit hook triggers **Docs Creator**, which updates skill artifacts and generates the commit message.
9. The session closes. Context is discarded.

**Session rules:**
- Sessions are scoped to a git branch.
- A suspended session (IDE closed mid-session) is resumed when the IDE reopens.
- A session closes only when a commit is made or the developer explicitly abandons it.
- Session context lives in `.agents/session.json` — gitignored, ephemeral.

### 2. Skill Creation and Ownership
You are the only skill with authority to create, modify, or retire framework-level skills. You distinguish between:

- **Framework skills** — owned by AtomicDev. These are the baseline five skills and any framework-level extensions. They follow the Atomic Dev workflow model.
- **Repo skills** — owned by the repository. These emerge from the specific codebase — domain patterns, project conventions, team workflows. They are generated in response to developer requests or Planner-detected gaps.

**When to create a new skill:**
- A recurring pattern spans multiple files and sessions → create a repo skill.
- The Planner repeatedly cannot plan adequately for a category of task → create a repo skill.
- A developer explicitly requests it → create the skill, human reviews before commit.
- A one-off convention → do not create a skill. Document it inline.

**When to extend an existing skill:**
- The new behaviour is a natural evolution of an existing skill's responsibility.
- Adding a new skill would create overlap or confusion with an existing one.

## Baseline Skills

| Skill | Directory | Responsibility |
|---|---|---|
| AtomicDev Core | `atomicdev-core/` | Workflow definition and skill ownership |
| Code Explorer | `atomicdev-code-explorer/` | Spatial navigation and comprehension of the codebase |
| Planner | `atomicdev-planner/` | Orchestration, confidence assessment, deliberation |
| Code Implementation | `atomicdev-code-implementation/` | Execution, verification, self-accounting explanation |
| Docs Creator | `atomicdev-docs-creator/` | Event-driven documentation and commit generation |

## Guiding Principles

- **Lean by default.** Five skills is the baseline. New skills earn their place.
- **Skills grow with the repo.** The skill library reflects the maturity of the codebase.
- **Human in the loop.** Agent-proposed skills and changes are always reviewed before commit.
- **Atomic commits.** Code and documentation change together, never separately.
- **The conversation is the scaffold. The skill is the residue.**
