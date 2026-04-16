#!/usr/bin/env bash
# 评估与教学 Prompt 模板验证测试
# TDD: 先写测试，再创建模板文件

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TEMPLATES="$PROJECT_DIR/prompts/templates"
PASS=0
FAIL=0

pass() { PASS=$((PASS + 1)); echo "  PASS: $1"; }
fail() { FAIL=$((FAIL + 1)); echo "  FAIL: $1"; }

echo "========================================="
echo "  评估与教学 Prompt 模板验证测试"
echo "========================================="

# ---- 1. 模板文件存在性 ----
echo ""
echo "[1/6] 模板文件存在性"

declare -a TEMPLATE_FILES=(
  "level-entry.md"
  "level-intermediate.md"
  "level-advanced.md"
  "cold-start.md"
  "memory-display.md"
  "capability-tags.md"
  "dimension-routing.md"
)

for f in "${TEMPLATE_FILES[@]}"; do
  if [ -f "$TEMPLATES/$f" ]; then
    [ -s "$TEMPLATES/$f" ] && pass "存在且非空: $f" || fail "文件为空: $f"
  else
    fail "文件缺失: $f"
  fi
done

# ---- 2. 三级模板内容验证 ----
echo ""
echo "[2/6] 三级模板内容验证"

if [ -f "$TEMPLATES/level-entry.md" ]; then
  grep -q "类比" "$TEMPLATES/level-entry.md" && pass "entry 包含: 类比解释" || fail "entry 缺失: 类比解释"
  grep -q "简化" "$TEMPLATES/level-entry.md" && pass "entry 包含: 简化代码" || fail "entry 缺失: 简化代码"
  grep -q "下一步" "$TEMPLATES/level-entry.md" && pass "entry 包含: 下一步建议" || fail "entry 缺失: 下一步建议"
else
  fail "level-entry.md 不存在，跳过内容检查"
fi

if [ -f "$TEMPLATES/level-intermediate.md" ]; then
  grep -q "术语" "$TEMPLATES/level-intermediate.md" && pass "intermediate 包含: 正确术语" || fail "intermediate 缺失: 正确术语"
  grep -q "实现" "$TEMPLATES/level-intermediate.md" && pass "intermediate 包含: 多种实现" || fail "intermediate 缺失: 多种实现"
  grep -q "优缺点\|优劣\|对比" "$TEMPLATES/level-intermediate.md" && pass "intermediate 包含: 优缺点对比" || fail "intermediate 缺失: 优缺点对比"
else
  fail "level-intermediate.md 不存在，跳过内容检查"
fi

if [ -f "$TEMPLATES/level-advanced.md" ]; then
  grep -q "论文" "$TEMPLATES/level-advanced.md" && pass "advanced 包含: 论文引用" || fail "advanced 缺失: 论文引用"
  grep -q "生产" "$TEMPLATES/level-advanced.md" && pass "advanced 包含: 生产约束" || fail "advanced 缺失: 生产约束"
  grep -q "讨论" "$TEMPLATES/level-advanced.md" && pass "advanced 包含: 开放讨论" || fail "advanced 缺失: 开放讨论"
else
  fail "level-advanced.md 不存在，跳过内容检查"
fi

# ---- 3. 冷启动模板验证 ----
echo ""
echo "[3/6] 冷启动模板验证"

if [ -f "$TEMPLATES/cold-start.md" ]; then
  grep -q "自然对话\|自然地\|聊天" "$TEMPLATES/cold-start.md" && pass "cold-start 包含: 自然对话式开场" || fail "cold-start 缺失: 自然对话式开场"
  grep -q "信号\|signal" "$TEMPLATES/cold-start.md" && pass "cold-start 包含: 信号检测规则" || fail "cold-start 缺失: 信号检测规则"
  grep -q "3轮\|三轮\|3 轮" "$TEMPLATES/cold-start.md" && pass "cold-start 包含: 3轮内完成初评" || fail "cold-start 缺失: 3轮内完成初评"
  # 不应包含问卷式提问
  if grep -q "问卷\|请填写\|请选择以下" "$TEMPLATES/cold-start.md"; then
    fail "cold-start 不应包含问卷式提问"
  else
    pass "cold-start 不包含问卷式提问"
  fi
else
  fail "cold-start.md 不存在，跳过内容检查"
fi

# ---- 4. 能力标签模板验证 ----
echo ""
echo "[4/6] 能力标签模板验证"

if [ -f "$TEMPLATES/capability-tags.md" ]; then
  grep -q "已掌握\|✅" "$TEMPLATES/capability-tags.md" && pass "capability-tags 包含: 已掌握展示" || fail "capability-tags 缺失: 已掌握展示"
  grep -q "在学习\|正在学\|📚" "$TEMPLATES/capability-tags.md" && pass "capability-tags 包含: 在学习展示" || fail "capability-tags 缺失: 在学习展示"
  grep -q "还未接触\|未接触\|🔮" "$TEMPLATES/capability-tags.md" && pass "capability-tags 包含: 还未接触展示" || fail "capability-tags 缺失: 还未接触展示"
  # 不应包含直接等级词
  if grep -q "入门级\|初级\|中级\|高级别" "$TEMPLATES/capability-tags.md"; then
    fail "capability-tags 不应包含直接等级词（入门级/初级/中级/高级别）"
  else
    pass "capability-tags 不包含直接等级词"
  fi
else
  fail "capability-tags.md 不存在，跳过内容检查"
fi

# ---- 5. 记忆展示模板验证 ----
echo ""
echo "[5/6] 记忆展示模板验证"

if [ -f "$TEMPLATES/memory-display.md" ]; then
  grep -q "我对你的理解\|对你的了解" "$TEMPLATES/memory-display.md" && pass "memory-display 包含: 理解展示区" || fail "memory-display 缺失: 理解展示区"
  grep -q "编辑\|修改\|纠正\|更正" "$TEMPLATES/memory-display.md" && pass "memory-display 包含: 用户可编辑提示" || fail "memory-display 缺失: 用户可编辑提示"
  grep -q "查看\|删除\|清空\|管理" "$TEMPLATES/memory-display.md" && pass "memory-display 包含: 数据管理入口" || fail "memory-display 缺失: 数据管理入口"
else
  fail "memory-display.md 不存在，跳过内容检查"
fi

# ---- 6. 维度分离逻辑验证 ----
echo ""
echo "[6/6] 维度分离逻辑验证"

if [ -f "$TEMPLATES/dimension-routing.md" ]; then
  pass "dimension-routing.md 存在"
  grep -q "维度\|dimension" "$TEMPLATES/dimension-routing.md" && pass "dimension-routing 包含: 维度映射规则" || fail "dimension-routing 缺失: 维度映射规则"
  grep -q "不均匀\|不平衡\|差异" "$TEMPLATES/dimension-routing.md" && pass "dimension-routing 包含: 不均匀水平处理" || fail "dimension-routing 缺失: 不均匀水平处理"
else
  fail "dimension-routing.md 不存在，跳过内容检查"
fi

# ---- 汇总 ----
echo ""
echo "========================================="
echo "  结果: $PASS 通过, $FAIL 失败"
echo "========================================="

[ "$FAIL" -eq 0 ] && exit 0 || exit 1
