#!/usr/bin/env bash
# 初始化用户画像
# 用法: memory-init.sh <user_id>

set -euo pipefail

USER_ID="${1:?用法: memory-init.sh <user_id>}"
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROFILES_DIR="$SCRIPT_DIR/.claude/memory/profiles"
PROFILE_FILE="$PROFILES_DIR/${USER_ID}.json"

mkdir -p "$PROFILES_DIR"

NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

cat > "${PROFILE_FILE}.tmp" <<EOF
{
  "metadata": {
    "user_id": "${USER_ID}",
    "created_at": "${NOW}",
    "last_updated": "${NOW}",
    "version": "1.0"
  },
  "basics": {
    "name": "",
    "target_track": "both",
    "current_level": "entry"
  },
  "assessment": {
    "programming": 0,
    "ai_ml_theory": 0,
    "llm_practice": 0,
    "agent_experience": 0,
    "overall_score": 0,
    "last_assessed": ""
  },
  "learning_plan": {
    "recommended_weeks": 0,
    "start_week": 0,
    "current_week": 0,
    "completed_topics": []
  },
  "history": {
    "sessions": []
  },
  "preferences": {
    "teaching_pace": "normal",
    "learning_style": "mixed",
    "language": "zh"
  }
}
EOF

mv "${PROFILE_FILE}.tmp" "$PROFILE_FILE"
echo "已初始化用户画像: $PROFILE_FILE"
