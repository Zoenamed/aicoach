#!/usr/bin/env bash
# 集成验证测试：记忆系统 + 评估模板 → Agent/Command 集成
# TDD: 先写测试，再改造实现

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0
FAIL=0

pass() { PASS=$((PASS + 1)); echo "  PASS: $1"; }
fail() { FAIL=$((FAIL + 1)); echo "  FAIL: $1"; }

AGENT_FILE="$PROJECT_DIR/.claude/agents/aicoach.md"
CMD_FILE="$PROJECT_DIR/.claude/commands/aicoach.md"

echo "========================================="
echo "  集成验证测试"
echo "========================================="

# ---- 1. Agent 定义集成验证 ----
echo ""
echo "[1/6] Agent 定义集成验证"

if [ -f "$AGENT_FILE" ]; then
  grep -q "记忆加载\|读取用户画像\|memory-read" "$AGENT_FILE" && pass "Agent 包含: 记忆加载" || fail "Agent 缺失: 记忆加载"
  grep -q "能力标签" "$AGENT_FILE" && pass "Agent 包含: 能力标签" || fail "Agent 缺失: 能力标签"
  grep -q "维度路由\|维度分离" "$AGENT_FILE" && pass "Agent 包含: 维度路由/维度分离" || fail "Agent 缺失: 维度路由/维度分离"
  grep -q "冷启动" "$AGENT_FILE" && pass "Agent 包含: 冷启动" || fail "Agent 缺失: 冷启动"
  grep -q "记忆保存\|memory-write\|更新用户画像" "$AGENT_FILE" && pass "Agent 包含: 记忆保存" || fail "Agent 缺失: 记忆保存"
else
  for i in 1 2 3 4 5; do fail "Agent 文件不存在"; done
fi

# ---- 2. Command 定义集成验证 ----
echo ""
echo "[2/6] Command 定义集成验证"

if [ -f "$CMD_FILE" ]; then
  grep -q "记忆\|画像" "$CMD_FILE" && pass "Command 包含: 记忆相关内容" || fail "Command 缺失: 记忆相关内容"
  grep -q "记忆加载\|用户画像\|画像.*加载\|加载.*画像\|检查.*画像\|画像.*存在" "$CMD_FILE" && pass "Command 包含: 记忆加载逻辑" || fail "Command 缺失: 记忆加载逻辑"
else
  fail "Command 文件不存在"
  fail "Command 文件不存在"
fi

# ---- 3. 模板引用完整性 ----
echo ""
echo "[3/6] 模板引用完整性"

if [ -f "$AGENT_FILE" ]; then
  grep -q "templates/" "$AGENT_FILE" && pass "Agent 引用了 templates/ 下的模板" || fail "Agent 未引用 templates/ 下的模板"

  # 提取所有引用的模板路径，验证文件存在
  TEMPLATE_REFS=$(grep -oE 'prompts/templates/[a-z-]+\.md' "$AGENT_FILE" 2>/dev/null || true)
  if [ -n "$TEMPLATE_REFS" ]; then
    ALL_EXIST=true
    while IFS= read -r ref; do
      if [ ! -f "$PROJECT_DIR/$ref" ]; then
        fail "引用的模板不存在: $ref"
        ALL_EXIST=false
      fi
    done <<< "$TEMPLATE_REFS"
    $ALL_EXIST && pass "所有引用的模板文件均存在"
  else
    fail "未找到模板引用路径"
  fi
else
  fail "Agent 文件不存在，跳过模板引用检查"
  fail "Agent 文件不存在，跳过模板引用检查"
fi

# ---- 4. 功能完整性（不丢失原有功能） ----
echo ""
echo "[4/6] 功能完整性"

if [ -f "$AGENT_FILE" ]; then
  grep -q "水平诊断" "$AGENT_FILE" && pass "保留模块: 水平诊断" || fail "丢失模块: 水平诊断"
  grep -q "学习路径" "$AGENT_FILE" && pass "保留模块: 学习路径" || fail "丢失模块: 学习路径"
  grep -q "技术深潜" "$AGENT_FILE" && pass "保留模块: 技术深潜" || fail "丢失模块: 技术深潜"
  grep -q "项目指导" "$AGENT_FILE" && pass "保留模块: 项目指导" || fail "丢失模块: 项目指导"
  grep -q "面试陪练" "$AGENT_FILE" && pass "保留模块: 面试陪练" || fail "丢失模块: 面试陪练"
  grep -q "求职辅导" "$AGENT_FILE" && pass "保留模块: 求职辅导" || fail "丢失模块: 求职辅导"
else
  for i in 1 2 3 4 5 6; do fail "Agent 文件不存在"; done
fi

# ---- 5. 新功能存在性 ----
echo ""
echo "[5/6] 新功能存在性"

if [ -f "$AGENT_FILE" ]; then
  grep -q "用户数据管理\|数据管理\|我的档案" "$AGENT_FILE" && pass "新功能: 用户数据管理" || fail "缺失新功能: 用户数据管理"
  grep -q "记忆新鲜度\|记忆验证\|新鲜度" "$AGENT_FILE" && pass "新功能: 记忆新鲜度/验证" || fail "缺失新功能: 记忆新鲜度/验证"
  grep -q "教学深度\|教学策略\|深度适配" "$AGENT_FILE" && pass "新功能: 教学深度调整策略" || fail "缺失新功能: 教学深度调整策略"
else
  for i in 1 2 3; do fail "Agent 文件不存在"; done
fi

# ---- 6. 回归验证 ----
echo ""
echo "[6/6] 回归验证"

if [ -x "$PROJECT_DIR/tests/test_project.sh" ]; then
  "$PROJECT_DIR/tests/test_project.sh" >/dev/null 2>&1 && pass "回归: test_project.sh 通过" || fail "回归: test_project.sh 失败"
else
  fail "test_project.sh 不存在或不可执行"
fi

if [ -x "$PROJECT_DIR/tests/test_memory.sh" ]; then
  "$PROJECT_DIR/tests/test_memory.sh" >/dev/null 2>&1 && pass "回归: test_memory.sh 通过" || fail "回归: test_memory.sh 失败"
else
  fail "test_memory.sh 不存在或不可执行"
fi

if [ -x "$PROJECT_DIR/tests/test_prompts.sh" ]; then
  "$PROJECT_DIR/tests/test_prompts.sh" >/dev/null 2>&1 && pass "回归: test_prompts.sh 通过" || fail "回归: test_prompts.sh 失败"
else
  fail "test_prompts.sh 不存在或不可执行"
fi

# ---- 汇总 ----
echo ""
echo "========================================="
echo "  结果: $PASS 通过, $FAIL 失败"
echo "========================================="

[ "$FAIL" -eq 0 ] && exit 0 || exit 1
