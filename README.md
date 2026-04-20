# AICoach — AI Agent 开发一站式学习导师

> 基于 [AgentGuide](https://github.com/caoyang2002/AgentGuide) 知识体系打造的 AI 专家导师,覆盖**水平诊断 / 学习路径 / 技术深潜 / 项目指导 / 面试陪练 / 求职辅导** 6 大模块,双赛道(算法岗 / 开发岗)通用。

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](./LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Agent-blueviolet)](https://claude.com/claude-code)
[![Codex Skill](https://img.shields.io/badge/OpenAI_Codex-Skill-000000)](https://developers.openai.com/codex)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/Zoenamed/aicoach/pulls)

---

## 目录

- [它能做什么](#它能做什么)
- [快速开始 — 按平台选择](#快速开始--按平台选择)
  - [Claude Code(原生)](#1-claude-code原生支持)
  - [OpenAI Codex(Skill)](#2-openai-codex-skill)
  - [通用 System Prompt(ChatGPT / Claude 网页 / 任意 LLM)](#3-通用-system-promptchatgpt--claude-网页--任意-llm)
  - [其他 Agent 工具通用适配](#4-其他-agent-工具通用适配cursor--copilot--gemini--opencode--)
- [功能详解](#功能详解)
- [项目结构](#项目结构)
- [致谢与 License](#致谢)

---

## 它能做什么

| # | 模块 | 功能 | 触发方式(自然语言) |
|---|------|------|---------|
| 1 | **水平诊断** | 交互式 5 维评估,推荐学习起点 | "测测我的水平" / "从哪开始" |
| 2 | **学习路径** | 9 周算法 / 8 周开发 的个性化周计划 | "帮我制定学习计划" |
| 3 | **技术深潜** | 5 步教学法 讲透核心技术 | "讲讲 RAG" / "什么是 Context Engineering" |
| 4 | **项目指导** | 从 500+ 项目库 推荐 2-3 个实战项目 | "推荐项目" / "做什么练手" |
| 5 | **面试陪练** | 一次一题模拟面试 + ⭐评分 + 参考答案 | "模拟面试" / "考我 Agent 知识" |
| 6 | **求职辅导** | 简历 / 薪资谈判 / HR 面 / 转行 | "优化简历" / "怎么谈薪资" |

**关键特性**:记忆用户画像(跨会话连续)、根据水平自动调整教学深度、所有建议可溯源到 AgentGuide 文档。

---

## 快速开始 — 按平台选择

> 选一个最顺手的平台即可。Claude Code 体验最完整(能实时读取知识库文件);Codex / 通用 Prompt 两种方式内容也覆盖完整,差异仅在"实时读取文档"的能力。

### 1. Claude Code(原生支持)

最推荐。Agent 定义、斜杠命令、记忆脚本全部开箱即用。

**安装**
```bash
git clone https://github.com/Zoenamed/aicoach.git
cd aicoach
```

**调用方式(任选其一)**

| 方式 | 命令 | 适用场景 |
|---|---|---|
| Subagent | 在 Claude Code 中输入 `/agents`,选择 **aicoach** | 需要对话式、长流程的学习陪伴 |
| Slash command | 直接输入 `/aicoach <你的需求>` | 一句话命令式使用 |

**示例**
```
/aicoach 我是 Python 后端开发,想转 AI Agent 方向,帮我规划学习路线
/aicoach 模拟一场 RAG 系统面试
/aicoach 推荐适合中级水平的项目
```

**依赖**:`AgentGuide/` 软链接(仓库已自带)、`scripts/memory-*.sh`(用户画像记忆)。保持在仓库根目录运行即可。

---

### 2. OpenAI Codex (Skill)

AICoach 打包为符合 [obra/superpowers](https://github.com/obra/superpowers) 规范的 `SKILL.md`,Codex 原生支持该格式。

**安装 — 项目级(当前项目内可用)**
```bash
cd /your/project
mkdir -p .agents/skills
cp -r /path/to/aicoach/.claude/commands/integrations/codex/aicoach .agents/skills/
```

**安装 — 用户级(全局可用)**
```bash
mkdir -p ~/.agents/skills
cp -r /path/to/aicoach/.claude/commands/integrations/codex/aicoach ~/.agents/skills/
```

**调用方式**
- **显式触发**:在 Codex 提示符输入 `$aicoach`,或使用 `/skills` 选择
- **隐式触发**:Codex 根据 `description` 自动匹配用户需求

**示例**
```
$aicoach 帮我做一次 Agent 系统设计面试
```

**细节**:见 [`.claude/commands/integrations/codex/README.md`](./.claude/commands/integrations/codex/README.md)。

---

### 3. 通用 System Prompt(ChatGPT / Claude 网页 / 任意 LLM)

不想装任何工具、只想在浏览器里用的方式。知识已内嵌进 prompt,无外部依赖。

**使用步骤**
1. 打开 [`prompts/system-prompt.md`](./prompts/system-prompt.md)
2. 复制 `---` 之间的完整内容
3. 粘贴到:
   - ChatGPT → 创建 Custom GPT 的 Instructions
   - Claude 网页/桌面 → Project 的 Custom Instructions
   - 任意支持 System Prompt 的 LLM API
4. 开始对话

**和前两种方式的差别**:
- ✅ 零依赖,任何 LLM 都能用
- ❌ 不能实时读取 AgentGuide 原文档(知识为内嵌精简版)
- ❌ 不带跨会话用户画像记忆

---

### 4. 其他 Agent 工具通用适配(Cursor / Copilot / Gemini / OpenCode / …)

本仓库 `.claude/commands/integrations/` 下为以下工具预留了集成说明:`aider / antigravity / claude-code / codex / cursor / gemini-cli / github-copilot / kimi / mcp-memory / openclaw / opencode / qwen / windsurf`。

**当前状态**:仅 **Claude Code**(原生)和 **Codex**(SKILL.md)已包含可直接部署的 aicoach 配置文件。其他工具目录暂时只有占位 README,**没有**自动生成的 aicoach 专属文件。

**如果你用的是上面列出的其他工具**,推荐用下面的通用方式接入 —— 所有这些工具都支持某种形式的"系统指令 / 规则文件":

| 工具 | 把下方内容粘贴到哪里 |
|---|---|
| Cursor | 项目根 `.cursor/rules/aicoach.mdc` 或全局 Rules |
| Aider | 项目根 `CONVENTIONS.md` |
| Windsurf | 项目根 `.windsurfrules` |
| GitHub Copilot | `.github/copilot-instructions.md` |
| Gemini CLI | `~/.gemini/` 的 skill / 系统指令位置 |
| OpenCode / Qwen / Kimi | 按各自 agent 定义格式包装 |

**粘贴什么内容**:[`prompts/system-prompt.md`](./prompts/system-prompt.md) 中 `---` 之间的完整 prompt。

**不编造具体路径**:各工具的最佳位置随版本变化,请以其官方文档为准。以上表格只列给出常见约定,实际使用前确认一下。

---

## 功能详解

所有模块的交互都是**对话式**的 —— 直接用自然语言说需求,AICoach 会自动匹配到对应模块。下文只概述每个模块"你会得到什么",完整交互协议见 [`.claude/agents/aicoach.md`](./.claude/agents/aicoach.md)。

### 模块 1:水平诊断

AICoach 通过 5 个维度的交互式问答评估(**每次只问 1-2 个问题**,不轰炸):

1. 编程基础(Python / 后端经验)
2. AI/ML 理论(Transformer / Attention / Embedding)
3. LLM 实操(API / 框架使用)
4. Agent 经验(系统搭建 / RAG)
5. 目标与时间预算

**你会得到**:水平判定 · 推荐学习起点 · 需补前置知识 · 预计到面试水平的周数。

### 模块 2:学习路径

根据诊断结果,从两套路线图生成**个性化周计划**:

- **算法赛道** — 9 周,重点:理论推导、实验设计、论文产出
- **开发赛道** — 8 周,重点:系统架构、工程实现、性能优化

**你会得到**:每周目标(带学时)+ 必读/选读资源 + 实践任务(带验收标准)+ 面试关联。

### 模块 3:技术深潜(5 步教学法)

对任何核心话题(Context Engineering / 12-Factor Agent / RAG / 记忆系统 / 评估 / SFT 微调 / 沙箱安全 …),按以下结构讲解:

1. **概念讲解** — 通俗类比
2. **原理深入** — 按水平调整深度
3. **代码示例** — 可运行
4. **面试关联** — 怎么问 / 怎么答
5. **简历写法** — 算法版 + 开发版

### 模块 4:项目指导

读取 93+ 结构化项目库,按你的水平和方向推荐 2-3 个,每个附:推荐理由 + 预计时间 + 技术栈 + **简历价值(双版本)** + 分阶段实施计划。

| 难度 | 周期 | 示例 |
|---|---|---|
| 入门 | 2-3 周 | 基础 RAG / 聊天机器人 / OCR 应用 |
| 中级 | 4-6 周 | Agent 工作流 / 高级 RAG / 语音处理 |
| 高级 | 8-12 周 | 多智能体系统 / 模型微调 / 生产级部署 |

### 模块 5:面试陪练(8 种模式)

理论面 / RAG / Agent / 编程 / 算法岗深度 / 开发岗深度 / 系统设计 / HR。

**规则**:严格一次一题,等你答完再继续。每题给:

- ⭐ 评分(1-5 星)
- 优点 / 改进点
- 参考高分答案
- 面试官可能的追问方向

面试结束给**整体评估报告**(理论深度 / 表达清晰度 / 实战经验 / 思维逻辑 四维度打分 + 行动建议)。

### 模块 6:求职辅导

- 简历优化(STAR 法则 + 量化指标)
- 求职策略(目标公司 / 投递时机 / 内推)
- 薪资谈判(市场参考 / 话术 / Offer 对比)
- HR 面准备(常见问题 / 职业规划 / 离职原因)
- 转行策略(怎么包装已有经验)

### 用户数据(仅 Claude Code / Codex 支持跨会话记忆)

随时可说:"我的档案" / "修改评估" / "重新开始" / "删除记忆" / "导出数据"。

通用 System Prompt 方式没有跨会话持久化 —— 每次新对话需要重新建立上下文。

---

## 项目结构

```
aicoach/
├── .claude/
│   ├── agents/aicoach.md                          # Claude Code Agent(完整版)
│   ├── commands/
│   │   ├── aicoach.md                             # Claude Code 斜杠命令
│   │   └── integrations/
│   │       ├── codex/aicoach/SKILL.md             # Codex Skill(superpowers 规范)
│   │       └── <其他工具>/README.md               # 占位说明
│   └── skills/aicoach-memory/                     # 用户记忆技能
├── prompts/
│   ├── system-prompt.md                           # 通用 System Prompt
│   └── templates/                                 # 冷启动 / 深度路由 / 能力标签 等
├── scripts/
│   ├── memory-init.sh / memory-read.sh / memory-write.sh  # 用户画像持久化
├── tests/                                         # 项目结构与内容验证
├── AgentGuide/                                    # → 知识库(符号链接)
├── README.md
└── LICENSE
```

### 三种使用方式对比

| 特性 | Claude Code | Codex Skill | 通用 System Prompt |
|---|---|---|---|
| 调用方式 | `/agents` / `/aicoach` | `$aicoach` / 隐式 | 粘贴到 LLM 的系统指令 |
| 知识来源 | 实时读取 AgentGuide 文档 | 实时读取 AgentGuide 文档 | 内嵌精华版 |
| 信息深度 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| 跨会话记忆 | ✅ | ✅ | ❌ |
| 外部依赖 | Claude Code | OpenAI Codex | 无 |

---

## 贡献

欢迎 PR 改进 AICoach:
- 优化 Prompt 提升教学效果
- 补充新的面试题或项目推荐
- 为尚未生成专属配置的工具(Cursor / Aider / Copilot 等)贡献适配文件
- 翻译为其他语言

---

## 致谢

- [AgentGuide](https://github.com/caoyang2002/AgentGuide) — 核心知识体系来源
- [Claude Code](https://claude.com/claude-code) — Agent 运行平台
- [obra/superpowers](https://github.com/obra/superpowers) — Skill 规范参考

## License

[MIT](./LICENSE)
