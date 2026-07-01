# chacha — AI 资源查找器

> "查查"就是帮你查一查。想知道什么，问 chacha 就好。

[![English Docs](https://img.shields.io/badge/docs-English-blue)](./README.md)

chacha 是一个 AI 驱动的资源发现代理，专注于**电影、图书和电视剧**。它聚合来自多个平台（IMDb、豆瓣、Rotten Tomatoes、Goodreads）的评分，并一站式查找下载链接（磁力链接、BT、云盘）。

## 安装

```bash
npx skills add brickhu/chacha
```

此命令会将 `chacha` 技能安装到全局。安装完成后，在 Claude Code 中使用 `/chacha <查询内容>` 即可开始搜索。

## 功能特性

- 🎬 **电影搜索** — IMDb、豆瓣、Rotten Tomatoes 评分 + 磁力/BT/云盘链接
- 📺 **剧集搜索** — 分季评分 + 全季下载资源
- 📚 **图书搜索** — Goodreads 和豆瓣评分 + 电子书下载链接
- 🎥 **创作者模式** — 按导演或作者搜索其代表作品
- 🌐 **多语言适配** — 根据你的输入语言自动切换回复语言（中文、English、日本語）
- ⚡ **一步到位** — 信息和下载链接同步返回，无需逐步确认

## 快速上手

```
/chacha 星际穿越
/chacha Interstellar
/chacha 千と千尋の神隠し
/chacha 诺兰
/chacha 三体
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
