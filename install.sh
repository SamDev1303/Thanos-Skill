#!/usr/bin/env bash
# =============================================================================
# THANOS GLOBAL INSTALL
# Run from anywhere: curl -fsSL https://raw.githubusercontent.com/SamDev1303/Thanos-Skill/main/install.sh | bash
# =============================================================================
set -euo pipefail

PURPLE='\033[0;35m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${PURPLE}"
cat << 'EOF'
 _____ _   _    _    _   _  ___  ____
|_   _| | | |  / \  | \ | |/ _ \/ ___|
  | | | |_| | / _ \ |  \| | | | \___ \
  | | |  _  |/ ___ \| |\  | |_| |___) |
  |_| |_| |_/_/   \_\_| \_|\___/|____/

EOF
echo -e "${CYAN}Installing Thanos Skill...${NC}\n"

INSTALL_DIR="$HOME/.thanos-skill"

# Clone or update
if [ -d "$INSTALL_DIR/.git" ]; then
  echo -e "${CYAN}Updating existing install...${NC}"
  git -C "$INSTALL_DIR" pull --ff-only
else
  echo -e "${CYAN}Cloning to $INSTALL_DIR...${NC}"
  git clone https://github.com/SamDev1303/Thanos-Skill "$INSTALL_DIR"
fi

chmod +x "$INSTALL_DIR/thanos.sh"

# Create symlink
SYMLINK_DIR="$HOME/.local/bin"
mkdir -p "$SYMLINK_DIR"
ln -sf "$INSTALL_DIR/thanos.sh" "$SYMLINK_DIR/thanos"

# Install Claude skill globally
CLAUDE_SKILL_DIR="$HOME/.claude/skills/thanos"
mkdir -p "$CLAUDE_SKILL_DIR"
cp "$INSTALL_DIR/THANOS.md" "$CLAUDE_SKILL_DIR/SKILL.md"

# Install Codex skill globally  
CODEX_SKILL_DIR="$HOME/.codex/skills/thanos"
mkdir -p "$CODEX_SKILL_DIR"
cp "$INSTALL_DIR/THANOS.md" "$CODEX_SKILL_DIR/SKILL.md"

# Install to agents dir (Codex native path from loader.rs)
AGENTS_SKILL_DIR="$HOME/.agents/skills/thanos"
mkdir -p "$AGENTS_SKILL_DIR"
cp "$INSTALL_DIR/SKILL.md" "$AGENTS_SKILL_DIR/SKILL.md"
cp "$INSTALL_DIR/THANOS.md" "$AGENTS_SKILL_DIR/THANOS.md"

echo ""
echo -e "${GREEN}✓ Thanos installed globally${NC}"
echo -e "${GREEN}✓ Claude skill: $CLAUDE_SKILL_DIR${NC}"
echo -e "${GREEN}✓ Codex skill: $CODEX_SKILL_DIR${NC}"
echo -e "${GREEN}✓ Agents skill: $AGENTS_SKILL_DIR${NC}"
echo ""
echo -e "${CYAN}Add to PATH if needed:${NC}"
echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
echo ""
echo -e "${PURPLE}Usage:${NC}"
echo "  thanos                    # auto-detect CLI, start interactive"
echo "  thanos claude             # use Claude Code"
echo "  thanos codex \"fix auth\"  # Codex with inline goal"
echo "  thanos gemini             # use Gemini CLI"
echo "  thanos --test             # run test suite"
echo "  thanos --status           # show stone states"
echo ""
echo -e "${PURPLE}💥 Snap. It is done.${NC}"
