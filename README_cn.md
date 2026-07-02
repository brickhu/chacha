# chacha — AI 资源搜索助理

> 告诉 AI 你需要什么，它帮你浏览各大资源网站和搜索平台，找到有效的资源链接。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![skills.sh](https://img.shields.io/badge/skills.sh-chacha-38bdae)](https://skills.sh/brickhu/chacha)

[English](./README.md) | [中文](./README_cn.md)

chacha 是一个 AI 资源搜索助理。告诉它你想看什么、想读什么——它同时搜索多个资源站和搜索平台，提取下载链接，验证存活，返回可直接复制的磁力链接和网盘地址。

## 为什么用 chacha？

搜索引擎给你**网页**，磁力站给你**单站索引**，chacha 给你**验证过的下载链接**——省掉搜索 → 点开 → 翻详情页 → 复制 → 发现死链的循环。

| vs. 搜索引擎 | vs. 磁力站 |
|---|---|
| 直接提取 `magnet:` 链接，不是给网页让你自己找 | 一次搜 9 个源，不是一个一个试 |
| 网盘链接展示前已 HEAD 验证存活 | 跳过进详情页找磁力按钮的四步流程 |
| 评分、卡司、剧情一条消息全给 | 站点换域名自动发现，零维护 |
| 搜索引擎找**网页**，chacha 找**链接** | 磁力站列**列表**，chacha 给**有效链接** |

## 可搜索的资源类型

| 类型 | 示例 | 覆盖源 |
|------|------|--------|
| 🎬 **电影** | 星际穿越、让子弹飞、奥本海默 | 豆瓣/IMDb/RT + 6 个磁力源 + 网盘 |
| 📺 **剧集** | 黑镜、权力的游戏、隐秘的角落 | 按季下载、全季合集 |
| 🎨 **番剧** | 進撃の巨人、鬼滅之刃、咒術廻戦 | Bangumi/MAL + Nyaa 首选 |
| 📚 **图书** | 三体、活着、百年孤独 | 豆瓣/Goodreads + 电子书下载 |
| 🎬 **创作者** | 诺兰、是枝裕和、刘慈欣 | 作品列表 + 评分排行 |
| 🔥 **发现** | `/chacha hot`、`/chacha new`、`/chacha top` | 50 条排行榜 |
| 🌍 **按地区** | `/chacha 日本`、`/chacha 国产`、`/chacha 韩国` | 按国家/地区过滤 |

## 工作原理

```
/chacha 星际穿越
  → 检查结果缓存（24h 有效期内直接命中）
  → 并行信息搜索：豆瓣 · IMDb · 烂番茄
  → 并行资源搜索（9 源）：
     · BT4G、BitSearch（DHT 聚合，千万级索引）
     · 1337x、YTS（国际 BT 站）
     · Nyaa（番剧首选）
     · SeedHub、磁力熊（中文资源站）
     · 夸克网盘
     · WebSearch（兜底）
  → 验证网盘链接存活（HEAD 请求）
  → 去重，按画质排序
  → 返回紧凑结果：
     # 🎬 星际穿越 Interstellar
     * **导演**: Christopher Nolan · 2014 · USA/UK · 169min
     * **主演**: 马修·麦康纳 / 安妮·海瑟薇 / ...
     * **评分**: ★ ★ ★ ★ ★ ｜ IMDb 8.7 · 豆瓣 9.4 · RT 86%/91%
     ✅ magnet:?xt=urn:btih:...  1080p  12GB  seeds:1500
     ✅ magnet:?xt=urn:btih:...  4K     45GB  seeds:320
```

域名挂了？AI 自动 WebSearch 找新地址，写入本地配置，下次秒恢复。

## 快速开始

```bash
npx skills add brickhu/chacha
```

然后在 AI 工具（Claude Code、Codex、Cursor、Windsurf、Cline、Trae）中使用：

```
/chacha 星际穿越
/chacha Interstellar
/chacha 诺兰              ← 创作者模式，列出作品列表
/chacha 日本              ← 地区模式，发现日本高分作品
/chacha hot               ← 发现模式：热搜 / 最新 / 排行榜
/chacha sources           ← 查看已配置的搜索源
/chacha discover sources  ← 发现并添加新搜索源
```

## 数据存储

所有用户数据存储在 `~/.config/chacha/`，不受 skill 更新影响：

```
~/.config/chacha/
├── sources.json          ← 搜索源配置（默认 + 自定义 + 自愈更新）
├── search-cache.json     ← 搜索结果缓存（24h 过期）
```

## 免责声明

chacha 是一个开源工具，仅聚合互联网上的公开信息。它**不**：

- 托管、存储或分发任何受版权保护的文件
- 运营任何存储媒体内容的服务器
- 与所搜索的网站存在任何关联

所有下载链接均来自第三方网站。chacha 对这些链接的内容、可用性和合法性没有任何控制权。

用户需自行承担以下责任：

- 遵守所在地的版权法律法规
- 仅下载拥有合法访问权限的内容
- 下载内容仅限个人学习/研究使用

项目维护者对用户通过本工具获取第三方链接后的行为不承担任何责任。

如果您是版权持有人，认为本项目便利了对您内容的访问，请在 GitHub 提交 issue，我们会认真处理。

## 许可证

MIT
