# chacha — AI 资源查找器

> "查查"就是帮你查一查。想知道什么，问 chacha 就好。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![skills.sh](https://img.shields.io/badge/skills.sh-chacha-38bdae)](https://skills.sh/brickhu/chacha)

[English](./README.md) | [中文](./README_cn.md)

chacha 是一个 AI 驱动的资源发现代理，专注于**电影、图书和电视剧**。它聚合来自多个平台（IMDb、豆瓣、Rotten Tomatoes、Goodreads）的评分，并一站式查找下载链接（磁力链接、BT、云盘）。

## 安装

### 快速安装

支持 **Claude Code**、**Codex**、**Cursor**、**Windsurf**、**Cline**、**Trae**，一条命令即可：

```bash
npx skills add brickhu/chacha
```

安装完成后，使用 `/chacha <查询内容>` 即可开始搜索。

### 手动安装

对于不支持 `npx skills add` 的 harness（如 **Workbuddy**、**Aside**），可以下载后手动安装：

1. 下载最新版本：
   ```bash
   curl -L -o chacha.zip https://github.com/brickhu/chacha/archive/refs/heads/master.zip
   ```

2. 在你的 harness 客户端中上传 `chacha.zip` 安装包即可。

## 功能特性

- 🎬 **电影搜索** — IMDb、豆瓣、Rotten Tomatoes 评分 + 磁力/BT/云盘链接
- 📺 **剧集搜索** — 分季评分 + 全季下载资源
- 📚 **图书搜索** — Goodreads 和豆瓣评分 + 电子书下载链接

## 快速上手

**按标题搜索：**

```
/chacha 星际穿越
/chacha Interstellar
/chacha 千と千尋の神隠し
/chacha 三体
```

**按创作者搜索：**

```
/chacha 诺兰
/chacha Christopher Nolan
/chacha 刘慈欣
```

**发现热门 / 最新 / 高分：**

```
/chacha hot
/chacha new
/chacha top
```

## 工作原理

1. 解析你的查询，判断媒体类型（电影/剧集/图书）或进入创作者模式
2. 并行搜索网络上的评分和元数据
3. 从 SeedHub、YTS、1337x、夸克网盘等来源抓取下载链接
4. 返回结构化表格，包含可复制的磁力链接和云盘地址

## 输出格式

所有结果包含：
- **紧凑的信息头部** — 标题、年份、导演/作者、评分（1-2 行）
- **下载资源表格** — 类型、画质、大小、可复制链接、提取码
- **快捷操作** — 复制到剪贴板、浏览器打开、打开磁力链接、直接下载

## 环境要求

- [Claude Code](https://claude.ai/code)（该技能作为 Claude Code 技能运行）
- 无需额外依赖 — 使用 WebSearch + bash 抓取脚本

## 免责声明

下载资源仅供**个人学习/研究使用**。版权归原作者所有，请支持正版。

## 许可证

MIT

## 相关链接

- [English README](./README.md)
- 远程仓库：[github.com/brickhu/chacha](https://github.com/brickhu/chacha)
