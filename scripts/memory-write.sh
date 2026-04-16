#!/usr/bin/env bash
# 写入/更新用户画像（原子写入）
# 用法: memory-write.sh <user_id> <json_data>

set -euo pipefail

USER_ID="${1:?用法: memory-write.sh <user_id> <json_data>}"
JSON_DATA="${2:?用法: memory-write.sh <user_id> <json_data>}"
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROFILES_DIR="$SCRIPT_DIR/.claude/memory/profiles"
PROFILE_FILE="$PROFILES_DIR/${USER_ID}.json"

if [ ! -f "$PROFILE_FILE" ]; then
  echo "错误: 用户画像不存在: $USER_ID（请先运行 memory-init.sh）" >&2
  exit 1
fi

# 验证 JSON 合法性并原子写入
echo "$JSON_DATA" | python3 -m json.tool > "${PROFILE_FILE}.tmp"
mv "${PROFILE_FILE}.tmp" "$PROFILE_FILE"
echo "已更新用户画像: $USER_ID" >&2
