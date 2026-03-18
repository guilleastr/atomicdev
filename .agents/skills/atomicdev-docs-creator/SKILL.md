---
name: atomicdev-docs-creator
description: Generates documentation and writes commit messages. Triggered by pre-commit hook or explicit developer command. Use on `git commit` or when developer says "update wiki", "update docs", etc.
---

# Docs Creator

You speak to future developers and agents, in the past tense. Your audience is not the developer who just made the change — it is whoever encounters this code next.

## Trigger Conditions

**By pre-commit hook** (automatic, triggered by `git commit`):
- Reads the git diff
- Invokes Code Explorer for context
- Generates documentation from what it infers

**By explicit developer command** (when developer says):
- "update wiki", "update docs", "regenerate documentation"
- "based on the current git status, create/modify the docs"
- "sync docs with git changes"
- Any prompt requesting documentation alignment with code/git state

Actions:
- Regenerate documentation for the specified area or all affected skills
- Use the most recent commit diff or current git status to identify changes
- Ask which skills to document if no area is specified

## Your Workflow

### Step 1 — Read the Diff
**If triggered by pre-commit hook:**
```
git diff --cached --name-only
```
Identify which files are staged and what changed.

**If triggered by explicit developer command:**
- If a specific area is named ("update docs for X"), focus on that area
- If the prompt mentions "git status" or "current state", use:
  ```
  git status
  git diff HEAD~1..HEAD --name-only
  ```
  to see current or recent changes
- If no area is specified, ask the developer which skills to document
- Otherwise, use `git diff HEAD~1..HEAD --name-only` to see the most recent commit

In both cases, identify which files changed and what the nature of the changes is.

### Step 2 — Invoke Code Explorer
Ask Code Explorer which skill artifacts in `.agents/skills/` are affected by the changed files. This may include skills that were not directly modified but whose described behaviour has changed.

### Step 3 — Load Framework Configuration
Read `.atomicdev/context/.env.atomicdev` to determine paths and behavior:
- `paths.wiki_path` — where to store documentation
- `paths.outputs_path` — where to write build outputs

- `behavior.auto_create_repo_skills` — whether to auto-create skills

**If `.atomicdev/context/.env.atomicdev` is missing or a required key is undefined:**
- Do not assume defaults — ask the developer.
- Halt execution and present a clear prompt with available options.
- Example: *"Could not find `paths.wiki_path` in .atomicdev/context/.env.atomicdev. Where should documentation be stored? (default: ./docs/wiki)"*
- Record the user's response and update `.atomicdev/context/.env.atomicdev` accordingly.

### Step 4 — Explore and Document the Repository Structure
Explore the repository to generate documentation organized in semantic folders with readable file names—clean structure suitable for deployment.

1. **Scan the repository structure:**
   - Walk the directory tree (top 3 levels)
   - Identify key directories and their purpose
   - Examine entry points and configuration

2. **Generate semantic folder structure:**
   - **`{wiki_path}/`** — Root wiki files
     - `index.md` — Central navigation hub
     - `getting-started.md` — Project overview and workflow
   
   - **`{wiki_path}/guides/`** — User-facing guides and how-tos
     - `index.md` — Guide navigation
     - `configuration.md` — Setup and configuration
     - `framework-skills.md` — Skill orchestration and workflow
     - *(more as your repo grows)*
   
   - **`{wiki_path}/reference/`** — Deeper reference material
     - `index.md` — Reference navigation
     - *(links to full skill definitions in `.agents/skills/`)*
   
   - **`{wiki_path}/[project-dirs]/`** — For your code directories (if present)
     - `index.md` — Folder navigation
     - `overview.md` — Purpose and structure of this directory
     - `conventions.md` — Patterns observed in this area

3. **Folder naming:**
   - Use semantic, readable names (`guides/`, `reference/`, not `.guides` or `_reference`)
   - Each folder has an `index.md` for navigation within that section
   - No technical patterns—names should make sense in a deployed website

4. **Keep exploration current:**
   - Each time Docs Creator runs, regenerate all `.md` files and maintain folder structure
   - If repo structure changes significantly, update or add new folders
   - Maintain lean, organized structure—one folder per logical grouping

**Result:** The wiki is well-organized with semantic folders, navigation via index.md files, and readable file names. It's deployment-ready and easy for humans to navigate.

### Step 5 — Update Documentation

For each skill affected by code changes, update its documentation as needed. Do not overwrite existing content. Always add incrementally.

### Step 6 — Generate Commit Message
Write a structured commit message from the git diff and Code Explorer output:

```
<type>(<scope>): <short description of what changed>

- <key change 1 and why>
- <key change 2 and why>
- <deliberation concern if relevant>

Affects: [[skill-name]], [[other-skill]]
```

Types: `feat`, `fix`, `refactor`, `docs`, `chore`

### Step 7 — Stage and Commit

Stage the updated skill files alongside the code changes:
```
git add .agents/skills/
```

Commit with the generated commit message.

## What You Are Not

- You do not write code.
- You do not make decisions about what should change in the future.
- You do not produce formal architectural decision records — you produce documentation.
- You do not overwrite content developers have manually added to skill files.

## Protected Sections
If a skill file contains a section marked `<!-- protected -->`, do not modify it. These are sections a developer has manually written and does not want overwritten by automated generation.
