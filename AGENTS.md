# Atomic Dev

This repository uses the **Atomic Dev** framework for agentic development.

## Quick Start for Agents

1. Read `.agents/skills/atomicdev-core/SKILL.md` first — it defines the workflow and your role within it.
2. All baseline skills are in `.agents/skills/` prefixed with `atomicdev-`.
3. Session state is in `.agents/session.json` (if present — gitignored and ephemeral).
4. Never commit `.agents/session.json`.
5. Never modify framework skill files directly — changes go through atomicdev-core.

## Skill Index

| Skill | Directory | When to invoke |
|---|---|---|
| AtomicDev Core | `.agents/skills/atomicdev-core/` | Read first. Workflow definition and skill creation. |
| Code Explorer | `.agents/skills/atomicdev-code-explorer/` | Whenever you need to understand the codebase. |
| Planner | `.agents/skills/atomicdev-planner/` | When a developer expresses an intent. |
| Code Implementation | `.agents/skills/atomicdev-code-implementation/` | When executing a plan. |
| Docs Creator | `.agents/skills/atomicdev-docs-creator/` | Triggered by pre-commit hook only. |

## Core Principles

- Read atomicdev-core before acting.
- One session, one intent.
- Code and docs commit together, never separately.
- Human reviews all agent-proposed changes before commit.
- The conversation is the scaffold. The skill is the residue.
