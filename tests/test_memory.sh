#!/usr/bin/env bash
# 记忆系统基础设施验证测试
# TDD: 先写测试，再创建文件

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0
FAIL=0
TEST_USER_ID="test-user-$(date +%s)"

pass() { PASS=$((PASS + 1)); echo "  PASS: $1"; }
fail() { FAIL=$((FAIL + 1)); echo "  FAIL: $1"; }

cleanup() {
  rm -f "$PROJECT_DIR/.claude/memory/profiles/${TEST_USER_ID}.json"
  rm -f "$PROJECT_DIR/.claude/memory/profiles/${TEST_USER_ID}.json.tmp"
}
trap cleanup EXIT

echo "========================================="
echo "  记忆系统基础设施验证测试"
echo "========================================="

# ---- 1. 目录结构验证 ----
echo ""
echo "[1/5] 目录结构验证"

for dir in ".claude/memory" ".claude/memory/profiles" ".claude/skills/aicoach-memory"; do
  [ -d "$PROJECT_DIR/$dir" ] && pass "目录存在: $dir" || fail "目录缺失: $dir"
done

[ -f "$PROJECT_DIR/.claude/skills/aicoach-memory/SKILL.md" ] && pass "文件存在: SKILL.md" || fail "文件缺失: SKILL.md"

# ---- 2. JSON Schema 验证 ----
echo ""
echo "[2/5] JSON Schema 验证"

SCHEMA_FILE="$PROJECT_DIR/.claude/memory/SCHEMA.md"
[ -f "$SCHEMA_FILE" ] && pass "文件存在: SCHEMA.md" || fail "文件缺失: SCHEMA.md"
[ -s "$SCHEMA_FILE" ] && pass "文件非空: SCHEMA.md" || fail "文件为空: SCHEMA.md"

if [ -f "$SCHEMA_FILE" ]; then
  for kw in "metadata" "basics" "assessment" "learning_plan" "history" "preferences"; do
    grep -q "$kw" "$SCHEMA_FILE" && pass "SCHEMA.md 包含字段: $kw" || fail "SCHEMA.md 缺失字段: $kw"
  done
fi

# ---- 3. 用户画像 CRUD 脚本验证 ----
echo ""
echo "[3/5] 用户画像 CRUD 脚本验证"

for script in "scripts/memory-init.sh" "scripts/memory-read.sh" "scripts/memory-write.sh"; do
  [ -f "$PROJECT_DIR/$script" ] && pass "脚本存在: $script" || fail "脚本缺失: $script"
  [ -x "$PROJECT_DIR/$script" ] && pass "脚本可执行: $script" || fail "脚本不可执行: $script"
done

# 初始化脚本测试
if [ -x "$PROJECT_DIR/scripts/memory-init.sh" ]; then
  INIT_OUTPUT=$("$PROJECT_DIR/scripts/memory-init.sh" "$TEST_USER_ID" 2>&1) && \
    pass "初始化脚本执行成功" || fail "初始化脚本执行失败: $INIT_OUTPUT"

  [ -f "$PROJECT_DIR/.claude/memory/profiles/${TEST_USER_ID}.json" ] && \
    pass "初始化创建了 profile 文件" || fail "初始化未创建 profile 文件"
fi

# 读取脚本测试
if [ -x "$PROJECT_DIR/scripts/memory-read.sh" ] && [ -f "$PROJECT_DIR/.claude/memory/profiles/${TEST_USER_ID}.json" ]; then
  READ_OUTPUT=$("$PROJECT_DIR/scripts/memory-read.sh" "$TEST_USER_ID" 2>&1)
  echo "$READ_OUTPUT" | python3 -c "import sys,json; json.load(sys.stdin)" 2>/dev/null && \
    pass "读取脚本输出有效 JSON" || fail "读取脚本输出无效 JSON"
fi

# 写入脚本测试
if [ -x "$PROJECT_DIR/scripts/memory-write.sh" ] && [ -f "$PROJECT_DIR/.claude/memory/profiles/${TEST_USER_ID}.json" ]; then
  # 读取当前内容，修改 name，写回
  CURRENT=$("$PROJECT_DIR/scripts/memory-read.sh" "$TEST_USER_ID")
  UPDATED=$(echo "$CURRENT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
data['basics']['name'] = 'Test Updated'
json.dump(data, sys.stdout)
")
  "$PROJECT_DIR/scripts/memory-write.sh" "$TEST_USER_ID" "$UPDATED" 2>&1 && \
    pass "写入脚本执行成功" || fail "写入脚本执行失败"

  # 验证写入结果
  VERIFY=$("$PROJECT_DIR/scripts/memory-read.sh" "$TEST_USER_ID")
  echo "$VERIFY" | python3 -c "
import sys, json
data = json.load(sys.stdin)
assert data['basics']['name'] == 'Test Updated', 'name not updated'
" 2>/dev/null && pass "写入数据验证成功" || fail "写入数据验证失败"
fi

# ---- 4. SKILL.md 内容验证 ----
echo ""
echo "[4/5] SKILL.md 内容验证"

SKILL_FILE="$PROJECT_DIR/.claude/skills/aicoach-memory/SKILL.md"
if [ -f "$SKILL_FILE" ]; then
  grep -q "^name:" "$SKILL_FILE" && pass "SKILL.md 包含 name 字段" || fail "SKILL.md 缺失 name 字段"
  grep -q "^description:" "$SKILL_FILE" && pass "SKILL.md 包含 description 字段" || fail "SKILL.md 缺失 description 字段"
  grep -q "加载\|load\|Load" "$SKILL_FILE" && pass "SKILL.md 包含记忆加载说明" || fail "SKILL.md 缺失记忆加载说明"
  grep -q "保存\|save\|Save" "$SKILL_FILE" && pass "SKILL.md 包含记忆保存说明" || fail "SKILL.md 缺失记忆保存说明"
  grep -q "画像\|profile\|Profile" "$SKILL_FILE" && pass "SKILL.md 包含用户画像模板" || fail "SKILL.md 缺失用户画像模板"
else
  fail "SKILL.md 不存在，跳过内容检查"
fi

# ---- 5. 数据完整性 ----
echo ""
echo "[5/5] 数据完整性"

# 验证 profile.json 包含所有必要字段
if [ -f "$PROJECT_DIR/.claude/memory/profiles/${TEST_USER_ID}.json" ]; then
  python3 -c "
import sys, json

with open('$PROJECT_DIR/.claude/memory/profiles/${TEST_USER_ID}.json') as f:
    data = json.load(f)

required_keys = ['metadata', 'basics', 'assessment', 'learning_plan', 'history', 'preferences']
missing = [k for k in required_keys if k not in data]
if missing:
    print(f'Missing keys: {missing}', file=sys.stderr)
    sys.exit(1)

# 验证 metadata 子字段
for k in ['user_id', 'created_at', 'last_updated', 'version']:
    assert k in data['metadata'], f'metadata missing {k}'

# 验证 basics 子字段
for k in ['name', 'target_track', 'current_level']:
    assert k in data['basics'], f'basics missing {k}'

# 验证 assessment 子字段
for k in ['programming', 'ai_ml_theory', 'llm_practice', 'agent_experience', 'overall_score', 'last_assessed']:
    assert k in data['assessment'], f'assessment missing {k}'

# 验证 learning_plan 子字段
for k in ['recommended_weeks', 'start_week', 'current_week', 'completed_topics']:
    assert k in data['learning_plan'], f'learning_plan missing {k}'

# 验证 history 子字段
assert 'sessions' in data['history'], 'history missing sessions'
assert isinstance(data['history']['sessions'], list), 'sessions not a list'

# 验证 preferences 子字段
for k in ['teaching_pace', 'learning_style', 'language']:
    assert k in data['preferences'], f'preferences missing {k}'

print('All fields valid')
" 2>&1 && pass "profile.json 包含所有必要字段" || fail "profile.json 缺少必要字段"
fi

# 完整流程：重新初始化 → 写入 → 读取
cleanup
if [ -x "$PROJECT_DIR/scripts/memory-init.sh" ] && [ -x "$PROJECT_DIR/scripts/memory-write.sh" ] && [ -x "$PROJECT_DIR/scripts/memory-read.sh" ]; then
  "$PROJECT_DIR/scripts/memory-init.sh" "$TEST_USER_ID" >/dev/null 2>&1
  FLOW_DATA=$("$PROJECT_DIR/scripts/memory-read.sh" "$TEST_USER_ID")
  FLOW_UPDATED=$(echo "$FLOW_DATA" | python3 -c "
import sys, json
data = json.load(sys.stdin)
data['basics']['name'] = 'Flow Test'
data['assessment']['programming'] = 3
json.dump(data, sys.stdout)
")
  "$PROJECT_DIR/scripts/memory-write.sh" "$TEST_USER_ID" "$FLOW_UPDATED" >/dev/null 2>&1
  FLOW_RESULT=$("$PROJECT_DIR/scripts/memory-read.sh" "$TEST_USER_ID")
  echo "$FLOW_RESULT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
assert data['basics']['name'] == 'Flow Test'
assert data['assessment']['programming'] == 3
" 2>/dev/null && pass "完整流程 (init→write→read) 验证通过" || fail "完整流程验证失败"
else
  fail "脚本不可用，跳过完整流程测试"
fi

# ---- 汇总 ----
echo ""
echo "========================================="
echo "  结果: $PASS 通过, $FAIL 失败"
echo "========================================="

[ "$FAIL" -eq 0 ] && exit 0 || exit 1
