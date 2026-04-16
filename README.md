# AICoach - AI Agent 开发一站式学习导师

> 基于 [AgentGuide](https://github.com/caoyang2002/AgentGuide) 知识体系打造的 AI 专家导师 Agent，帮你从零到一掌握 AI Agent 开发，拿下理想 Offer。

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](./LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Agent-blueviolet)](https://claude.com/claude-code)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/Zoenamed/aicoach/pulls)

---

## 它能做什么？

AICoach 是一个**一站式 AI Agent 开发学习导师**，具备 6 大功能模块，根据你的输入自动匹配：

| 模块 | 功能 | 触发方式 |
|------|------|----------|
| **水平诊断** | 交互式评估你的当前水平，推荐学习起点 | "测测我的水平" / "从哪开始" |
| **学习路径** | 个性化周学习计划（算法岗 9 周 / 开发岗 8 周） | "帮我制定学习计划" |
| **技术深潜** | 5 步教学法深入讲解核心技术 | "讲讲 RAG" / "什么是 Context Engineering" |
| **项目指导** | 从 500+ 项目库推荐最适合你的实战项目 | "推荐项目" / "做什么练手" |
| **面试陪练** | 模拟真实面试，逐题评分 + 参考答案 + 追问 | "模拟面试" / "考我 Agent 知识" |
| **求职辅导** | 简历优化、薪资谈判、HR 面、转行策略 | "帮我优化简历" / "怎么谈薪资" |

**双赛道覆盖**：同时支持算法工程师和开发工程师方向

---

## 快速开始

AICoach 提供 **3 种使用方式**，选择最适合你的：

### 方式 1: Claude Code Agent（推荐）

> 最完整的体验，可实时读取 AgentGuide 知识库文档

1. 将本项目克隆到你的工作目录：
```bash
git clone https://github.com/Zoenamed/aicoach.git
cd aicoach
```

2. 在 Claude Code 中通过 `/agents` 调用 **aicoach**

### 方式 2: Claude Code 斜杠命令

> 一条命令启动，自动匹配功能

1. 确保 `.claude/commands/aicoach.md` 在你的项目中
2. 在 Claude Code 中输入 `/aicoach` + 你的需求：
```
/aicoach 我是 Python 后端开发，想转 AI Agent 方向，帮我规划学习路线
/aicoach 模拟一场 RAG 系统面试
/aicoach 推荐适合中级水平的项目
```

### 方式 3: 通用 System Prompt

> 可在 ChatGPT / Claude / 任何 LLM 中使用

1. 打开 [`prompts/system-prompt.md`](./prompts/system-prompt.md)
2. 复制 `---` 之间的完整内容
3. 粘贴到任意 LLM 的 System Prompt / 自定义指令中
4. 开始对话即可

---

## 项目结构

```
aicoach/
├── .claude/
│   ├── agents/
│   │   └── aicoach.md          # Claude Code Agent 定义（完整版，可读取知识库）
│   └── commands/
│       └── aicoach.md          # 斜杠命令版（自动功能匹配）
├── prompts/
│   └── system-prompt.md        # 通用 System Prompt（知识内嵌，任意 LLM 可用）
├── tests/
│   └── test_project.sh         # 项目结构与内容验证测试
├── README.md
└── LICENSE
```

### 三个版本的区别

| 特性 | Agent 定义 | 斜杠命令 | System Prompt |
|------|-----------|---------|---------------|
| 使用场景 | `/agents` 调用 | `/aicoach` 调用 | 任意 LLM |
| 知识来源 | 实时读取文档 | 实时读取文档 | 内嵌精华版 |
| 信息深度 | 最深（全量文档） | 最深（全量文档） | 核心框架 |
| 自动匹配 | 需手动选模块 | 自动匹配功能 | 自动匹配功能 |
| 依赖 | AgentGuide 项目 | AgentGuide 项目 | 无依赖 |

---

## 功能详解

### 水平诊断

通过 5 轮交互式问答评估你的：
- 编程基础（Python / 后端经验）
- AI/ML 理论（Transformer / Attention / Embedding）
- LLM 实操（API / 框架使用）
- Agent 经验（系统搭建 / RAG）
- 目标与时间预算

输出：水平判定 + 推荐起点 + 前置知识 + 时间预估

### 面试陪练

支持 8 种面试类型：
1. 理论面（LLM 基础 107 题）
2. RAG 专项
3. Agent 专项
4. 编程面
5. 算法岗深度
6. 开发岗深度
7. 系统设计
8. HR 面

每题给出：⭐ 评分 + 优点 + 改进 + 参考答案 + 追问方向

### 技术深潜

5 步教学法：
1. 概念讲解（通俗类比）
2. 原理深入（按需调整深度）
3. 代码示例（可运行）
4. 面试关联（怎么问 / 怎么答）
5. 简历写法（算法版 + 开发版）

---

## 知识来源

AICoach 的知识体系基于 **[AgentGuide](https://github.com/caoyang2002/AgentGuide)** 开源项目，涵盖：

- 14 篇技术深度文档（Context Engineering、12-Factor Agent、记忆系统、评估体系...）
- 16 份面试题库（1000+ 面试题，覆盖理论/编程/系统设计/HR）
- 3 套学习路线图（算法 9 周 / 开发 8 周 / 简易版）
- 500+ Agent 工作流模板与 93+ 结构化项目推荐

---

## 贡献

欢迎提交 PR 来改进 AICoach！你可以：
- 优化 Prompt 提升教学效果
- 添加新的功能模块
- 改进面试题库和评分标准
- 翻译为其他语言

---

## 致谢

- [AgentGuide](https://github.com/caoyang2002/AgentGuide) — 核心知识体系来源
- [Claude Code](https://claude.com/claude-code) — Agent 运行平台

---

## License

[MIT](./LICENSE)
