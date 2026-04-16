#!/usr/bin/env bash
# aicoach 项目结构与内容验证测试
# TDD: 先写测试，再创建文件

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0
FAIL=0

pass() { PASS=$((PASS + 1)); echo "  PASS: $1"; }
fail() { FAIL=$((FAIL + 1)); echo "  FAIL: $1"; }

echo "========================================="
echo "  aicoach 项目验证测试"
echo "========================================="

# ---- 1. 目录结构测试 ----
echo ""
echo "[1/5] 目录结构"

for dir in ".claude/agents" ".claude/commands" "prompts" "tests"; do
  [ -d "$PROJECT_DIR/$dir" ] && pass "目录存在: $dir" || fail "目录缺失: $dir"
done

# ---- 2. 核心文件存在性 ----
echo ""
echo "[2/5] 核心文件存在性"

declare -a REQUIRED_FILES=(
  ".claude/agents/aicoach.md"
  ".claude/commands/aicoach.md"
  "prompts/system-prompt.md"
  "README.md"
  "LICENSE"
)

for f in "${REQUIRED_FILES[@]}"; do
  [ -f "$PROJECT_DIR/$f" ] && pass "文件存在: $f" || fail "文件缺失: $f"
done

# ---- 3. 文件内容关键词检查 ----
echo ""
echo "[3/5] 文件内容关键词"

# Agent 定义文件
if [ -f "$PROJECT_DIR/.claude/agents/aicoach.md" ]; then
  for kw in "水平诊断" "学习路径" "技术深潜" "项目指导" "面试陪练" "求职辅导"; do
    grep -q "$kw" "$PROJECT_DIR/.claude/agents/aicoach.md" && pass "agents/aicoach.md 包含: $kw" || fail "agents/aicoach.md 缺失关键词: $kw"
  done
else
  fail "agents/aicoach.md 不存在，跳过内容检查"
fi

# 命令文件
if [ -f "$PROJECT_DIR/.claude/commands/aicoach.md" ]; then
  grep -q "自动功能匹配\|自动判断" "$PROJECT_DIR/.claude/commands/aicoach.md" && pass "commands/aicoach.md 包含自动匹配逻辑" || fail "commands/aicoach.md 缺失自动匹配逻辑"
  grep -q "description:" "$PROJECT_DIR/.claude/commands/aicoach.md" && pass "commands/aicoach.md 包含 frontmatter description" || fail "commands/aicoach.md 缺失 frontmatter"
else
  fail "commands/aicoach.md 不存在，跳过内容检查"
fi

# System Prompt
if [ -f "$PROJECT_DIR/prompts/system-prompt.md" ]; then
  grep -q "Context Engineering" "$PROJECT_DIR/prompts/system-prompt.md" && pass "system-prompt.md 包含核心知识" || fail "system-prompt.md 缺失 Context Engineering"
  grep -q "12-Factor" "$PROJECT_DIR/prompts/system-prompt.md" && pass "system-prompt.md 包含 12-Factor" || fail "system-prompt.md 缺失 12-Factor"
else
  fail "system-prompt.md 不存在，跳过内容检查"
fi

# README
if [ -f "$PROJECT_DIR/README.md" ]; then
  grep -q "aicoach\|AICoach\|AI Coach" "$PROJECT_DIR/README.md" && pass "README.md 包含项目名" || fail "README.md 缺失项目名 aicoach"
  grep -q "快速开始\|Quick Start\|使用方式\|使用方法" "$PROJECT_DIR/README.md" && pass "README.md 包含使用说明" || fail "README.md 缺失使用说明"
  grep -q "AgentGuide" "$PROJECT_DIR/README.md" && pass "README.md 引用 AgentGuide" || fail "README.md 未引用 AgentGuide"
else
  fail "README.md 不存在，跳过内容检查"
fi

# LICENSE
if [ -f "$PROJECT_DIR/LICENSE" ]; then
  grep -q "MIT" "$PROJECT_DIR/LICENSE" && pass "LICENSE 为 MIT" || fail "LICENSE 不是 MIT"
else
  fail "LICENSE 不存在，跳过内容检查"
fi

# ---- 4. 命名一致性（不应包含旧名 aiguide） ----
echo ""
echo "[4/5] 命名一致性 (aicoach, 非 aiguide)"

# 文件名不应为 aiguide
[ ! -f "$PROJECT_DIR/.claude/agents/aiguide.md" ] && pass "无旧文件 agents/aiguide.md" || fail "存在旧文件 agents/aiguide.md"
[ ! -f "$PROJECT_DIR/.claude/commands/aiguide.md" ] && pass "无旧文件 commands/aiguide.md" || fail "存在旧文件 commands/aiguide.md"

# ---- 5. 文件非空 ----
echo ""
echo "[5/5] 文件非空检查"

for f in "${REQUIRED_FILES[@]}"; do
  if [ -f "$PROJECT_DIR/$f" ]; then
    [ -s "$PROJECT_DIR/$f" ] && pass "文件非空: $f" || fail "文件为空: $f"
  fi
done

# ---- 汇总 ----
echo ""
echo "========================================="
echo "  结果: $PASS 通过, $FAIL 失败"
echo "========================================="

[ "$FAIL" -eq 0 ] && exit 0 || exit 1
