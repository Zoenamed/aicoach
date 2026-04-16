# 用户画像 JSON Schema

用户画像存储在 `.claude/memory/profiles/{user_id}.json`。

## 顶层结构

| 字段 | 类型 | 说明 |
|------|------|------|
| metadata | object | 元信息 |
| basics | object | 基本信息 |
| assessment | object | 能力评估 |
| learning_plan | object | 学习计划 |
| history | object | 学习历史 |
| preferences | object | 偏好设置 |

## metadata

| 字段 | 类型 | 说明 |
|------|------|------|
| user_id | string | 用户唯一标识 (uuid 或自定义) |
| created_at | string | 创建时间 (ISO date) |
| last_updated | string | 最后更新时间 (ISO date) |
| version | string | Schema 版本，当前 "1.0" |

## basics

| 字段 | 类型 | 说明 |
|------|------|------|
| name | string | 用户名称 |
| target_track | string | 目标方向: algorithm / development / both |
| current_level | string | 当前水平: entry / intermediate / advanced |

## assessment

| 字段 | 类型 | 说明 |
|------|------|------|
| programming | int | 编程能力 1-5 |
| ai_ml_theory | int | AI/ML 理论 1-5 |
| llm_practice | int | LLM 实践 1-5 |
| agent_experience | int | Agent 经验 1-5 |
| overall_score | float | 综合评分 1-5 |
| last_assessed | string | 最近评估时间 (ISO date) |

## learning_plan

| 字段 | 类型 | 说明 |
|------|------|------|
| recommended_weeks | int | 建议学习周数 |
| start_week | int | 起始周 |
| current_week | int | 当前周 |
| completed_topics | array[string] | 已完成主题列表 |

## history

| 字段 | 类型 | 说明 |
|------|------|------|
| sessions | array[object] | 学习会话记录 |

### session 对象

| 字段 | 类型 | 说明 |
|------|------|------|
| date | string | 日期 (ISO date) |
| type | string | 类型: diagnostic / learning / interview / project |
| summary | string | 会话摘要 |
| scores | object | 评分 (自由结构) |

## preferences

| 字段 | 类型 | 说明 |
|------|------|------|
| teaching_pace | string | 教学节奏: slow / normal / fast |
| learning_style | string | 学习风格: theory / practice / mixed |
| language | string | 语言: zh / en |
