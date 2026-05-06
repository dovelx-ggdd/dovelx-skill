#!/usr/bin/env bash
# smoke-check-manifests.sh — 校验 Claude/Cursor 插件清单 JSON、路径与版本对齐（供 CI 外本地冒烟）

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

check_agents_in_manifest() {
  local manifest="$1"
  local label="$2"
  echo "检查 ${label} 中的 agents 路径..."
  while IFS= read -r rel; do
    path="$ROOT_DIR/${rel#./}"
    if [[ ! -f "$path" ]]; then
      echo "ERROR: ${label} 引用文件不存在: $rel" >&2
      exit 1
    fi
  done < <(jq -r '.agents[]?' "$manifest")
  echo "  OK: ${label} agents"
}

for f in .claude-plugin/plugin.json .claude-plugin/marketplace.json \
         .cursor-plugin/plugin.json .cursor-plugin/marketplace.json; do
  jq empty "$f" >/dev/null
done

check_agents_in_manifest ".claude-plugin/plugin.json" "Claude plugin.json"
check_agents_in_manifest ".cursor-plugin/plugin.json" "Cursor plugin.json"

CLAUDE_P=$(jq -r '.version' .claude-plugin/plugin.json)
CLAUDE_M=$(jq -r '.metadata.version' .claude-plugin/marketplace.json)
CURSOR_P=$(jq -r '.version' .cursor-plugin/plugin.json)
CURSOR_M=$(jq -r '.metadata.version' .cursor-plugin/marketplace.json)

if [[ "$CLAUDE_P" != "$CLAUDE_M" || "$CURSOR_P" != "$CURSOR_M" || "$CLAUDE_P" != "$CURSOR_P" ]]; then
  echo "ERROR: 版本不一致 — Claude plugin=$CLAUDE_P marketplace=$CLAUDE_M | Cursor plugin=$CURSOR_P marketplace=$CURSOR_M" >&2
  exit 1
fi

if [[ ! -d skills ]]; then
  echo "ERROR: skills/ 目录缺失" >&2
  exit 1
fi

echo "smoke-check-manifests: 全部通过 (release version=$CLAUDE_P)"
