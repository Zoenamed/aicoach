#!/usr/bin/env bash
# 读取用户画像
# 用法: memory-read.sh <user_id>

set -euo pipefail

USER_ID="${1:?用法: memory-read.sh <user_id>}"
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROFILE_FILE="$SCRIPT_DIR/.claude/memory/profiles/${USER_ID}.json"

if [ ! -f "$PROFILE_FILE" ]; then
  echo "错误: 用户画像不存在: $USER_ID" >&2
  exit 1
fi

cat "$PROFILE_FILE"
