#!/bin/sh
# Atomic Dev installer
# Usage:   curl -sSL https://raw.githubusercontent.com/guilleastr/atomicdev/master/install.sh | sh
# Options: curl -sSL .../install.sh | sh -s -- --update --dry-run --cleanup

set -e

REPO="https://raw.githubusercontent.com/guilleastr/atomicdev/master"
SKILLS="atomicdev-core atomicdev-code-explorer atomicdev-planner atomicdev-code-implementation atomicdev-docs-creator"
VERSION="0.1.0"

# ─── colours ────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

ok()      { printf "${GREEN}✓${RESET} %s\n" "$1"; }
skip()    { printf "${YELLOW}~${RESET} %s\n" "$1"; }
fail()    { printf "${RED}✗ %s${RESET}\n" "$1"; exit 1; }
info()    { printf "  ${DIM}%s${RESET}\n" "$1"; }
section() { printf "\n${BOLD}%s${RESET}\n" "$1"; }

# ─── parse flags ────────────────────────────────────────────────────────────
UPDATE=false
DRY_RUN=false
CLEANUP=false

while [ "$#" -gt 0 ]; do
  case "$1" in
    --update)   UPDATE=true;  shift ;;
    --dry-run)  DRY_RUN=true; shift ;;
    --cleanup)  CLEANUP=true; shift ;;
    *) shift ;;
  esac
done

# ─── banner ─────────────────────────────────────────────────────────────────
printf "\n${BOLD}${CYAN}Atomic Dev${RESET} ${DIM}v${VERSION}${RESET}\n"
printf "${DIM}A skill-based agentic framework for the software development lifecycle.${RESET}\n\n"

[ "$DRY_RUN" = true ] && printf "${YELLOW}Dry run, no changes will be made.${RESET}\n\n"

# ─── check we are inside a git repo ─────────────────────────────────────────
ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || fail "Not a git repository. Run this from inside a project."
cd "$ROOT"
ok "Git repository at $ROOT"

# ─── cleanup and update modes bypass interactive steps ───────────────────────
if [ "$CLEANUP" = true ] || [ "$UPDATE" = true ]; then
  HAS_AGENTS=false
  HAS_CLAUDE=false
  HAS_GITHUB=false
  [ -d ".agents/skills" ] && HAS_AGENTS=true
  [ -d ".claude/skills" ] && HAS_CLAUDE=true
  [ -d ".github/agents" ] && HAS_GITHUB=true
  INSTALL_AGENTS=$HAS_AGENTS
  INSTALL_CLAUDE=$HAS_CLAUDE
  INSTALL_GITHUB=$HAS_GITHUB
fi

if [ "$UPDATE" = false ] && [ "$CLEANUP" = false ]; then

# ─── auto-detect existing IDE conventions (visual hint only) ────────────────
section "Step 1 of 4: Detect"
printf "${DIM}Scanning for existing IDE conventions...${RESET}\n\n"

HAS_AGENTS=false
HAS_CLAUDE=false
HAS_GITHUB=false

[ -d ".agents/skills" ] && HAS_AGENTS=true
[ -d ".claude/skills" ] && HAS_CLAUDE=true
[ -d ".github/agents" ] && HAS_GITHUB=true

if [ "$HAS_AGENTS" = true ]; then
  printf "  ${GREEN}●${RESET} .agents/skills/   ${GREEN}found${RESET}     ${DIM}(standard — Copilot, OpenCode, Codex)${RESET}\n"
else
  printf "  ${DIM}○${RESET} .agents/skills/                ${DIM}(standard — Copilot, OpenCode, Codex)${RESET}\n"
fi

if [ "$HAS_CLAUDE" = true ]; then
  printf "  ${GREEN}●${RESET} .claude/skills/   ${GREEN}found${RESET}     ${DIM}(Claude Code)${RESET}\n"
else
  printf "  ${DIM}○${RESET} .claude/skills/                ${DIM}(Claude Code)${RESET}\n"
fi

if [ "$HAS_GITHUB" = true ]; then
  printf "  ${GREEN}●${RESET} .github/agents/   ${GREEN}found${RESET}     ${DIM}(GitHub Copilot alternative path)${RESET}\n"
else
  printf "  ${DIM}○${RESET} .github/agents/                ${DIM}(GitHub Copilot alternative path)${RESET}\n"
fi

# ─── select targets (developer decides, no pre-selection) ────────────────────
section "Step 2 of 4: Select targets"
printf "${DIM}Which locations should Atomic Dev install skills to?${RESET}\n"
printf "${DIM}Enter one or more numbers separated by spaces.${RESET}\n\n"
printf "  1) .agents/skills/   ${DIM}(recommended — cross-IDE standard)${RESET}\n"
printf "  2) .claude/skills/   ${DIM}(Claude Code)${RESET}\n"
printf "  3) .github/agents/   ${DIM}(GitHub Copilot alternative path)${RESET}\n"
printf "\nSelection: "
read -r SELECTION

[ -z "$SELECTION" ] && fail "No targets selected. Run the installer again and choose at least one."

# Parse selection into flags
INSTALL_AGENTS=false
INSTALL_CLAUDE=false
INSTALL_GITHUB=false

for N in $SELECTION; do
  case "$N" in
    1) INSTALL_AGENTS=true ;;
    2) INSTALL_CLAUDE=true ;;
    3) INSTALL_GITHUB=true ;;
    *) fail "Invalid selection: $N. Choose from 1, 2, 3." ;;
  esac
done

# ─── confirm ─────────────────────────────────────────────────────────────────
section "Step 3 of 4: Confirm"
printf "${DIM}The following will be installed:${RESET}\n\n"

[ "$INSTALL_AGENTS" = true ] && printf "  ${GREEN}✓${RESET} Skills    → .agents/skills/\n"
[ "$INSTALL_CLAUDE" = true ] && {
  if [ "$INSTALL_AGENTS" = true ]; then
    printf "  ${GREEN}✓${RESET} Symlinks  → .claude/skills/ (pointing to .agents/skills/)\n"
  else
    printf "  ${GREEN}✓${RESET} Skills    → .claude/skills/\n"
  fi
}
[ "$INSTALL_GITHUB" = true ] && {
  if [ "$INSTALL_AGENTS" = true ]; then
    printf "  ${GREEN}✓${RESET} Symlinks  → .github/agents/ (pointing to .agents/skills/)\n"
  else
    printf "  ${GREEN}✓${RESET} Skills    → .github/agents/\n"
  fi
}
printf "  ${GREEN}✓${RESET} Hook      → .git/hooks/pre-commit\n"
printf "  ${GREEN}✓${RESET} Config    → .atomicdev/context/config.json\n"

printf "\nProceed? [y/N]: "
read -r CONFIRM
case "$CONFIRM" in
  y|Y|yes|YES) ;;
  *) printf "\nAborted.\n\n"; exit 0 ;;
esac

# ─── cleanup mode ────────────────────────────────────────────────────────────
if [ "$CLEANUP" = true ]; then
  section "Cleanup"
  for TARGET in ".claude/skills" ".github/agents"; do
    if [ -d "$TARGET" ]; then
      for SKILL in $SKILLS; do
        LINK="${TARGET}/${SKILL}"
        if [ -L "$LINK" ]; then
          [ "$DRY_RUN" = false ] && rm "$LINK"
          ok "Removed symlink: ${LINK}"
        fi
      done
    fi
  done
  printf "\nSymlinks removed. Skills remain in .agents/skills/\n\n"
  exit 0
fi

# ─── install skill function ──────────────────────────────────────────────────
install_skills_to() {
  TARGET_DIR="$1"
  LABEL="$2"

  section "Installing to ${LABEL}"
  [ "$DRY_RUN" = false ] && mkdir -p "$TARGET_DIR"
  ok "Created ${TARGET_DIR}"

  for SKILL in $SKILLS; do
    DEST="${TARGET_DIR}/${SKILL}/SKILL.md"
    if [ -f "$DEST" ] && [ "$UPDATE" = false ]; then
      skip "${SKILL}/ already exists (--update to refresh)"
    else
      if [ "$DRY_RUN" = false ]; then
        mkdir -p "${TARGET_DIR}/${SKILL}"
        curl -sSL "${REPO}/.agents/skills/${SKILL}/SKILL.md" -o "$DEST" \
          || fail "Failed to download ${SKILL}/SKILL.md"
      fi
      [ "$UPDATE" = true ] && ok "Updated: ${SKILL}/" || ok "Installed: ${SKILL}/"
    fi
  done
}

# ─── symlink function (for non-.agents targets) ──────────────────────────────
symlink_skills_to() {
  TARGET_DIR="$1"
  LABEL="$2"

  section "Linking to ${LABEL}"
  info "Symlinks point into .agents/skills/ (one source of truth)."
  printf "\n"
  [ "$DRY_RUN" = false ] && mkdir -p "$TARGET_DIR"

  for SKILL in $SKILLS; do
    LINK="${TARGET_DIR}/${SKILL}"
    # Relative path from target dir back to .agents/skills/
    DEPTH=$(echo "$TARGET_DIR" | tr -cd '/' | wc -c)
    DOTS=""
    i=0
    while [ "$i" -lt "$DEPTH" ]; do
      DOTS="../$DOTS"
      i=$((i + 1))
    done
    TARGET="${DOTS}.agents/skills/${SKILL}"

    if [ -L "$LINK" ]; then
      skip "Symlink already exists: ${LINK}"
    elif [ -d "$LINK" ]; then
      skip "${LINK} is a real directory — skipping"
    else
      [ "$DRY_RUN" = false ] && ln -s "$TARGET" "$LINK"
      ok "Symlinked: ${LINK} → .agents/skills/${SKILL}"
    fi
  done
}

fi

# ─── execute installs ────────────────────────────────────────────────────────
section "Step 4 of 4: Install"
if [ "$INSTALL_AGENTS" = true ]; then
  install_skills_to ".agents/skills" ".agents/skills/ (primary)"
fi

# .claude/skills/ — symlinks into .agents/
if [ "$INSTALL_CLAUDE" = true ]; then
  if [ "$INSTALL_AGENTS" = true ]; then
    symlink_skills_to ".claude/skills" ".claude/skills/ (Claude Code)"
  else
    # If .agents/ not selected, install real files here
    install_skills_to ".claude/skills" ".claude/skills/ (Claude Code)"
  fi
fi

# .github/agents/ — symlinks into .agents/
if [ "$INSTALL_GITHUB" = true ]; then
  if [ "$INSTALL_AGENTS" = true ]; then
    symlink_skills_to ".github/agents" ".github/agents/ (GitHub Copilot)"
  else
    install_skills_to ".github/agents" ".github/agents/ (GitHub Copilot)"
  fi
fi

# ─── pre-commit hook ─────────────────────────────────────────────────────────
section "Common files"
HOOK=".git/hooks/pre-commit"
if [ -f "$HOOK" ] && [ "$UPDATE" = false ]; then
  skip "pre-commit hook already exists — skipping"
  info "Back up your hook and re-run with --update to install the Atomic Dev hook"
else
  if [ "$DRY_RUN" = false ]; then
    curl -sSL "${REPO}/hooks/pre-commit" -o "$HOOK" || fail "Failed to download pre-commit hook"
    chmod +x "$HOOK"
  fi
  ok "Installed pre-commit hook"
fi

# ─── .atomicdev/context/config.json ─────────────────────────────────────────────────────
CONFIG=".atomicdev/context/config.json"
if [ -f "$CONFIG" ] && [ "$UPDATE" = false ]; then
  skip "Config already exists: .atomicdev/context/config.json"
else
  if [ "$DRY_RUN" = false ]; then
    mkdir -p ".atomicdev/context"
    cat > "$CONFIG" << EOF
{
  "version": "${VERSION}",
  "targets": {
    "agents": ${INSTALL_AGENTS},
    "claude": ${INSTALL_CLAUDE},
    "github": ${INSTALL_GITHUB}
  },
  "deliberation": "auto"
}
EOF
  fi
  ok "Written .atomicdev/context/config.json"
fi

# ─── done ────────────────────────────────────────────────────────────────────
printf "\n${GREEN}${BOLD}Atomic Dev installed.${RESET}\n"
printf "Your next commit will generate documentation.\n\n"
printf "${DIM}Get started:  tell your agent what you want to build.\n"
printf "Update:       curl -sSL .../install.sh | sh -s -- --update\n"
printf "Cleanup:      curl -sSL .../install.sh | sh -s -- --cleanup\n"
printf "Docs:         https://github.com/YOUR_USERNAME/atomicdev${RESET}\n\n"
