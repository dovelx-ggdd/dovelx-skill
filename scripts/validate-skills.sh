#!/usr/bin/env bash
# validate-skills.sh — 验证所有 skill 的 SKILL.md 和 agent 配置文件格式是否符合规范

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_DIR="$ROOT_DIR/skills"
AGENTS_DIR="$ROOT_DIR/agents"
ERRORS=0
WARNINGS=0
SKILL_CHECKED=0
AGENT_CHECKED=0

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RESET='\033[0m'

# ─── 验证 Skills ──────────────────────────────────────────────────────────────

echo -e "${CYAN}=== [1/2] 验证 Skills ===${RESET}"
echo ""

for skill_dir in "$SKILLS_DIR"/*/; do
  skill_name=$(basename "$skill_dir")
  skill_file="$skill_dir/SKILL.md"

  echo -e "检查 skill: ${CYAN}${skill_name}${RESET}"

  if [[ ! -f "$skill_file" ]]; then
    echo -e "  ${RED}[ERROR]${RESET} 缺少 SKILL.md"
    ERRORS=$((ERRORS + 1))
    continue
  fi

  if ! head -1 "$skill_file" | grep -q "^---$"; then
    echo -e "  ${RED}[ERROR]${RESET} 缺少 frontmatter（首行应为 ---）"
    ERRORS=$((ERRORS + 1))
  fi

  if ! grep -q "^name:" "$skill_file"; then
    echo -e "  ${RED}[ERROR]${RESET} 缺少必填字段: name"
    ERRORS=$((ERRORS + 1))
  else
    name_val=$(grep "^name:" "$skill_file" | head -1 | sed 's/name: *//')
    if [[ "$name_val" != dovelx-* ]]; then
      echo -e "  ${RED}[ERROR]${RESET} name 必须以 'dovelx-' 开头，当前值: ${name_val}"
      ERRORS=$((ERRORS + 1))
    fi
  fi

  if ! grep -q "^description:" "$skill_file"; then
    echo -e "  ${RED}[ERROR]${RESET} 缺少必填字段: description"
    ERRORS=$((ERRORS + 1))
  else
    desc_val=$(grep "^description:" "$skill_file" | head -1 | sed 's/description: *//')
    if [[ -z "$desc_val" ]]; then
      echo -e "  ${RED}[ERROR]${RESET} description 字段不能为空"
      ERRORS=$((ERRORS + 1))
    fi
  fi

  if ! grep -q "^origin:" "$skill_file"; then
    echo -e "  ${YELLOW}[WARN]${RESET}  缺少推荐字段: origin"
    WARNINGS=$((WARNINGS + 1))
  fi

  if [[ ! -d "$skill_dir/examples" ]]; then
    echo -e "  ${YELLOW}[WARN]${RESET}  缺少 examples/ 目录"
    WARNINGS=$((WARNINGS + 1))
  else
    [[ ! -f "$skill_dir/examples/input.md" ]] && {
      echo -e "  ${YELLOW}[WARN]${RESET}  缺少 examples/input.md"
      WARNINGS=$((WARNINGS + 1))
    }
    [[ ! -f "$skill_dir/examples/output.md" ]] && {
      echo -e "  ${YELLOW}[WARN]${RESET}  缺少 examples/output.md"
      WARNINGS=$((WARNINGS + 1))
    }
  fi

  file_lines=$(wc -l < "$skill_file")
  if [[ "$file_lines" -lt 10 ]]; then
    echo -e "  ${YELLOW}[WARN]${RESET}  内容过少（${file_lines} 行）"
    WARNINGS=$((WARNINGS + 1))
  fi

  echo -e "  ${GREEN}[OK]${RESET}"
  SKILL_CHECKED=$((SKILL_CHECKED + 1))
done

# ─── 验证 Agents ──────────────────────────────────────────────────────────────

echo ""
echo -e "${CYAN}=== [2/2] 验证 Agents ===${RESET}"
echo ""

if [[ ! -d "$AGENTS_DIR" ]]; then
  echo -e "${YELLOW}[WARN]${RESET} agents/ 目录不存在，跳过 Agent 验证"
  WARNINGS=$((WARNINGS + 1))
else
  for agent_file in "$AGENTS_DIR"/*.md; do
    [[ -f "$agent_file" ]] || continue
    agent_name=$(basename "$agent_file" .md)

    echo -e "检查 agent: ${CYAN}${agent_name}${RESET}"

    if ! head -1 "$agent_file" | grep -q "^---$"; then
      echo -e "  ${RED}[ERROR]${RESET} 缺少 frontmatter（首行应为 ---）"
      ERRORS=$((ERRORS + 1))
      continue
    fi

    if ! grep -q "^name:" "$agent_file"; then
      echo -e "  ${RED}[ERROR]${RESET} 缺少必填字段: name"
      ERRORS=$((ERRORS + 1))
    fi

    if ! grep -q "^description:" "$agent_file"; then
      echo -e "  ${RED}[ERROR]${RESET} 缺少必填字段: description"
      ERRORS=$((ERRORS + 1))
    else
      desc_val=$(grep "^description:" "$agent_file" | head -1 | sed 's/description: *//')
      if [[ -z "$desc_val" ]]; then
        echo -e "  ${RED}[ERROR]${RESET} description 字段不能为空"
        ERRORS=$((ERRORS + 1))
      fi
    fi

    if ! grep -q "^origin:" "$agent_file"; then
      echo -e "  ${YELLOW}[WARN]${RESET}  缺少推荐字段: origin"
      WARNINGS=$((WARNINGS + 1))
    fi

    file_lines=$(wc -l < "$agent_file")
    if [[ "$file_lines" -lt 10 ]]; then
      echo -e "  ${YELLOW}[WARN]${RESET}  内容过少（${file_lines} 行），请确认是否完整"
      WARNINGS=$((WARNINGS + 1))
    fi

    echo -e "  ${GREEN}[OK]${RESET}"
    AGENT_CHECKED=$((AGENT_CHECKED + 1))
  done
fi

# ─── 汇总 ─────────────────────────────────────────────────────────────────────

echo ""
echo -e "${CYAN}=== 验证结果 ===${RESET}"
echo -e "已检查 Skills: ${SKILL_CHECKED}"
echo -e "已检查 Agents: ${AGENT_CHECKED}"
echo -e "错误数量:       ${ERRORS}"
echo -e "警告数量:       ${WARNINGS}"
echo ""

if [[ "$ERRORS" -gt 0 ]]; then
  echo -e "${RED}验证失败：发现 ${ERRORS} 个错误，请修复后重试。${RESET}"
  exit 1
elif [[ "$WARNINGS" -gt 0 ]]; then
  echo -e "${YELLOW}验证通过（含警告）：${WARNINGS} 个警告，建议修复。${RESET}"
  exit 0
else
  echo -e "${GREEN}验证通过：所有 Skills 和 Agents 格式正确。${RESET}"
  exit 0
fi
