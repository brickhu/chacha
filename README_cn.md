# chacha — AI 资源查找器

> "查查"就是帮你查一查。想知道什么，问 chacha 就好。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![skills.sh](https://img.shields.io/badge/skills.sh-chacha-38bdae)](https://skills.sh/brickhu/chacha)

[English](./README.md) | [中文](./README_cn.md)

chacha 是一个 AI 驱动的资源发现代理，专注于**电影、剧集和图书**。三大核心能力：

## 1. 提取有效链接

传统 BT 站需要：搜索 → 找条目 → 进详情页 → 找磁力按钮 → 复制。每一步都可能是死胡同——页面打不开、链接已失效、需要点击跳转。

chacha 直接一步到位：**从搜索页、API、DHT 聚合器同时提取磁力和网盘链接**，对每个 HTTP 链接做 HEAD 请求验证存活状态，去重后输出可直接复制的完整 `magnet:?xt=urn:btih:...` 字符串。

> 每条链接都经过验证 ✅，不会出现复制下来才发现是死链的情况。

## 2. 跨源聚合搜索

**9 个搜索源同时并行**，覆盖面远超任何单一 BT 站：

| 源 | 定位 |
|---|---|
| 磁力熊 | 豆瓣高分电影 1080P |
| SeedHub | 豆瓣榜单自动匹配 |
| YTS | 小体积高清电影 |
| 1337x | 4K 资源 |
| BT4G | DHT 聚合，千万级索引 |
| BitSearch | DHT 聚合，结构化数据 |
| Nyaa | 动漫首选 |
| 夸克网盘 | 中文云盘资源 |
| WebSearch | 兜底搜索 |

**域名自愈**：站点被封/换域名时，AI 自动通过 WebSearch 发现新地址并缓存，后续搜索秒级恢复。不依赖任何单一网站，不依赖 GitHub 同步。

## 3. 信息聚合总结

一条消息包含传统流程需要 3-5 个网站才能凑齐的信息：

```
🎬 星际穿越 Interstellar (2014)
⭐ IMDb 8.7 · 豆瓣 9.4 · RT 86%/91%
🎭 马修·麦康纳 / 安妮·海瑟薇 / 杰西卡·查斯坦
🔥 看点：诺兰用虫洞和黑洞把硬科幻拍成了父女情——五维空间那场戏让整个影院静默

磁力链接:
✅ magnet:?xt=urn:btih:XXXX  1080p 12.3GB  seeds:1500
✅ magnet:?xt=urn:btih:YYYY  4K HDR 45.2GB  seeds:320
⚠️ 夸克网盘 https://pan.quark.cn/s/ZZZZ  提取码: chacha
```

## 快速上手

```
/chacha 星际穿越
/chacha Interstellar
/chacha 诺兰              ← 创作者模式，列出作品列表
/chacha hot               ← 发现模式：热搜/最新/排行榜
```

## 安装

```bash
npx skills add brickhu/chacha
```

安装完成后，使用 `/chacha <查询内容>` 即可开始搜索。支持 Claude Code、Codex、Cursor、Windsurf、Cline、Trae。

## 工作原理

1. 识别查询意图（作品/创作者/发现模式）
2. 并行搜索 IMDb、豆瓣、烂番茄获取评分与卡司
3. 并行运行 9 个搜索源提取磁力/网盘链接
4. 验证链接存活状态，去重，按质量排序
5. 生成包含信息摘要和可复制链接的回复

## 免责声明

下载资源仅供**个人学习/研究使用**。版权归原作者所有，请支持正版。

## 许可证

MIT
