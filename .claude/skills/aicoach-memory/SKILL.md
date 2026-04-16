---
name: aicoach-memory
description: "AICoach 用户记忆管理 — 加载/保存/展示用户学习画像"
---

# AICoach 记忆管理

管理用户学习画像的加载、保存和展示。

## 记忆加载流程

会话开始时自动加载用户画像：

1. 确认用户身份（user_id）
2. 执行 `scripts/memory-read.sh <user_id>` 读取画像 JSON
3. 如果画像不存在，执行 `scripts/memory-init.sh <user_id>` 初始化
4. 将画像数据加载到当前会话上下文

## 记忆保存流程

会话结束或关键节点自动保存：

1. 收集本次会话的更新（评估结果、学习进度、新的会话记录）
2. 合并更新到当前画像数据，更新 `metadata.last_updated`
3. 执行 `scripts/memory-write.sh <user_id> '<json_data>'` 原子写入
4. 确认保存成功

## 用户画像展示模板

向用户展示画像时使用以下格式：

```
📋 学习画像 — {basics.name}
━━━━━━━━━━━━━━━━━━━━━━

🎯 目标方向: {basics.target_track}
📊 当前水平: {basics.current_level}

💡 能力评估 (满分5):
  编程能力:     {"█" * programming} {assessment.programming}
  AI/ML理论:    {"█" * ai_ml_theory} {assessment.ai_ml_theory}
  LLM实践:      {"█" * llm_practice} {assessment.llm_practice}
  Agent经验:    {"█" * agent_experience} {assessment.agent_experience}
  ─────────────
  综合评分:     {assessment.overall_score}

📅 学习计划: 第 {learning_plan.current_week}/{learning_plan.recommended_weeks} 周
📝 已完成: {len(learning_plan.completed_topics)} 个主题

⚙️ 偏好: {preferences.teaching_pace}节奏 | {preferences.learning_style}风格 | {preferences.language}
```

## 用户数据管理

- **查看画像**: 使用展示模板向用户展示当前画像摘要
- **修改画像**: 通过会话交互收集更新，调用写入脚本保存
- **删除画像**: 删除 `.claude/memory/profiles/{user_id}.json` 文件
