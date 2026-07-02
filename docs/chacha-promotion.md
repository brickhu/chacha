# chacha：AI 资源搜索助理

> 告诉 AI 你想看什么，它帮你找资源。

---

想看电影的时候，流程一般是这样的：

1. 打开豆瓣看评分
2. 切到 IMDb 确认
3. 去烂番茄再看看
4. 打开磁力站搜索
5. 点进详情页复制链接
6. 发现链接已失效
7. 换一个站重来

整个过程少说十分钟，最后可能空手而归。

chacha 把上面七步压缩成一步。

---

## 用法

安装：

```bash
npx skills add brickhu/chacha
```

然后在命令行输入：

```
/chacha 星际穿越
```

几秒后，直接返回：

```
# 🎬 星际穿越 Interstellar
* **导演**: Christopher Nolan · 2014 · USA/UK · 169min
* **评分**: ★ ★ ★ ★ ★ ｜ IMDb 8.7 · 豆瓣 9.4 · RT 86%/91%

✅ magnet:?xt=urn:btih:...  1080p  12GB  seeds:1500
✅ magnet:?xt=urn:btih:...  4K     45GB  seeds:320
```

不需要打开任何网页。

---

## 它能做什么

| 类型 | 支持 |
|------|------|
| 电影 | IMDb + 豆瓣 + RT 评分，磁力/网盘下载 |
| 剧集 | 按季搜索，支持选集 |
| 番剧 | MyAnimeList + Bangumi 评分，Nyaa 源 |
| 图书 | Goodreads + 豆瓣评分，电子书下载 |
| 创作者 | 导演/作者的作品列表 |
| 排行榜 | 热门、最新、高分 50 条 |
| 按地区 | `/chacha 日本`、`/chacha 国产` |

---

## 和搜索引擎、磁力站有什么区别

搜索引擎给你**网页**，磁力站给你**列表**，chacha 给你**验证过的链接**。

| 场景 | 传统方式 | chacha |
|------|---------|--------|
| 找链接 | 你自己找网页 → 翻详情 → 复制 | 直接输出 `magnet:` |
| 链接是活的吗 | 打开才知道 | 先验证，再展示 |
| 评分/信息 | 另开 2-3 个站 | 一条消息全包含 |
| 搜几个源 | 一个一个试 | 9 个源同时搜 |
| 站点被封 | 等它恢复 | 自动发现新域名 |

---

## 域名自动修复

磁力站经常换域名。chacha 内置了自愈机制：

1. 搜索失败 → 输出 `SITE_DEAD`
2. AI 自动搜索该站点的新域名
3. 写入本地配置
4. 下次直接用新地址

不需要手动更新任何配置。

---

## 技术原理

每次搜索，AI 并行执行：

- 3 路信息搜索：豆瓣、IMDb、烂番茄
- 9 路资源搜索：BT4G、BitSearch、1337x、YTS、Nyaa、SeedHub、磁力熊、夸克网盘、WebSearch
- 验证网盘链接存活（HEAD 请求）
- 去重、按质量排序

结果缓存 24 小时，相同查询秒回。

所有用户数据存储在 `~/.config/chacha/`，升级 skill 不丢失。

---

## 安装

支持 Claude Code、Codex、Cursor、Windsurf、Cline、Trae。

```bash
# 一键安装
npx skills add brickhu/chacha

# 使用
/chacha 星际穿越
/chacha 诺兰
/chacha hot
```

项目开源：[github.com/brickhu/chacha](https://github.com/brickhu/chacha)

---

> 下载资源仅供个人学习/研究使用。版权归原作者所有，请支持正版。
