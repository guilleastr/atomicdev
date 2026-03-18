# Atomic Dev Overview

This is the Atomic Dev framework repository. For documentation specific to YOUR project (the repo this skill is running in), see the directory-specific READMEs below that mirror your actual codebase structure.

> **How this wiki is organized:** The directory structure in `docs/wiki/` mirrors your repository structure. Each top-level directory in your project has a corresponding wiki directory with a README explaining its contents, conventions, and entry points.

## Quick Navigation

- **[DOCUMENTATION.md](./DOCUMENTATION.md)** — Index of all docs, organized by purpose
- **[.atomicdev/](../.atomicdev/)** ← Learn about Atomic Dev state and configuration
- **[.agents/](../.agents/)** ← Learn about the framework skills
- **[Root directory docs]** ← See below for repo-specific guides

## Project: Atomic Dev Framework

The Atomic Dev framework is a skill-based agentic system for AI-assisted software development. It provides:
- **Five baseline skills** that orchestrate planning, implementation, and documentation
- **Workflow** — from intent through deliberation to implementation
- **Automatic documentation** versioned alongside code
- **Skill growth** as your repository matures

### Key Directories

This repository is organized for skill development and framework maintenance:

- **`.atomicdev/context/`** — Atomic Dev configuration (all in one place)
- **`.agents/skills/`** — The five baseline skills and framework governance
- **`docs/wiki/`** — Documentation hub (where you are now)
- **`docs/wiki/configuration/`** — Guide to .atomicdev configuration
- **`docs/wiki/framework/`** — Guide to .agents skills and framework
- **`hooks/`** — Git integration (pre-commit hook)
- **Root files** — Installation script, README

## Directory-by-Directory Guide

When Atomic Dev runs in your repository, corresponding documentation appears here. Each directory README explains:
- Purpose and responsibility of that directory
- Key conventions and patterns used within it
- Entry points and navigation
- Dependencies and related directories

For example:
- `wiki/src/README.md` — Documents your `src/` directory
- `wiki/api/README.md` — Documents your `api/` directory  
- `wiki/.agents/README.md` — Documents the `.agents/` framework directory
- etc.

**The wiki mirrors your actual repository structure.** As your repo evolves, so does the wikis.
