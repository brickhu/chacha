# 数据源参考

## 信息与评分类

### 电影/剧集

| 数据源 | 覆盖 | 是否需要 Key | 说明 |
|--------|------|-------------|------|
| **TMDB** (api.themoviedb.org) | 电影+剧集 | 免费注册 | 最全面的免费影视数据库，150+ API 端点。提供基本信息、评分、卡司、海报、预告片。通过 WebFetch 直接调 API |
| **OMDb** (omdbapi.com) | 电影+剧集 | 免费注册 | 轻量 API，直接返回 IMDb/烂番茄/Metacritic 评分。1000次/天 |
| **豆瓣搜索** (search.douban.com) | 电影+剧集+图书 | 无 | 中文用户首选评分平台。通过 WebSearch `site:douban.com` 获取评分和基本信息 |
| **IMDb** (imdb.com) | 电影+剧集 | 无(搜索) | 全球最大影视数据库。通过 WebSearch 获取评分和详情页信息 |
| **烂番茄** (rottentomatoes.com) | 电影+剧集 | 无(搜索) | 专业影评人+观众双评分系统。通过 WebSearch 获取 |
| **Metacritic** (metacritic.com) | 电影+剧集+游戏 | 无(搜索) | 加权平均评分。通过 WebSearch 获取 |

#### TMDB API 快速参考

```
# 搜索电影
https://api.themoviedb.org/3/search/movie?api_key={KEY}&query={title}&language=zh-CN

# 搜索剧集
https://api.themoviedb.org/3/search/tv?api_key={KEY}&query={title}&language=zh-CN

# 电影详情（含评分+卡司+海报）
https://api.themoviedb.org/3/movie/{id}?api_key={KEY}&language=zh-CN&append_to_response=credits

# 剧集详情
https://api.themoviedb.org/3/tv/{id}?api_key={KEY}&language=zh-CN&append_to_response=credits

# 图片基础 URL
https://image.tmdb.org/t/p/w500/{poster_path}
```

#### OMDb API 快速参考

```
# 按标题搜索（返回 IMDb/RT/Metacritic 评分）
https://www.omdbapi.com/?t={title}&y={year}&apikey={KEY}

# 按 IMDb ID 搜索
https://www.omdbapi.com/?i={imdb_id}&apikey={KEY}
```

### 图书

| 数据源 | 覆盖 | 是否需要 Key | 说明 |
|--------|------|-------------|------|
| **Open Library** (openlibrary.org) | 图书 | 无需 | 完全免费、CC0 数据。支持 ISBN 查询、搜索、评分。通过 WebFetch 调 API |
| **Google Books** (books.google.com) | 图书 | 免费 Key | 元数据丰富，有评分和评分数。搜索支持 `intitle:`、`inauthor:` 限定 |
| **豆瓣读书** (book.douban.com) | 图书 | 无(搜索) | 中文图书评分首选。通过 WebSearch 获取评分和书评 |
| **Goodreads** (goodreads.com) | 图书 | 无(搜索) | 全球最大读书社区。API 已关闭，通过 WebSearch 获取评分 |

#### Open Library API 快速参考

```
# 搜索图书
https://openlibrary.org/search.json?q={title}+{author}&fields=*

# 按 ISBN 查询
https://openlibrary.org/isbn/{ISBN}.json

# 获取作品详情
https://openlibrary.org/works/{work_id}.json

# 封面图片
https://covers.openlibrary.org/b/isbn/{ISBN}-L.jpg
```

#### Google Books API 快速参考

```
# 搜索图书
https://www.googleapis.com/books/v1/volumes?q={title}+inauthor:{author}&key={KEY}

# 按 ISBN 查询
https://www.googleapis.com/books/v1/volumes?q=isbn:{ISBN}&key={KEY}
```

---

## 下载资源类

> **域名活性管理**：所有搜索源统一存储在 `~/.config/chacha/sources.json`（一个文件）。首次运行自动从 `scripts/domains.json` 初始化。站点域名过期时，AI 自动通过 WebSearch 发现新域名并写入同一文件。用户自定义源、AI 自愈都修改同一个文件，无多级合并逻辑。

### 电影/剧集 BT/磁力

#### ⭐ 首选：磁力熊 (cilixiong.com)

磁力熊是目前实测最优质的中文磁力站，专注豆瓣 7.5 分以上电影 1080P 下载，无广告、链接存活率高。

| 项目 | 详情 |
|------|------|
| **主站** | `cilixiong.com` |
| **镜像** | `cilixiong.net`、`cilixiong.cc` |
| **定位** | 豆瓣高分电影1080P磁力下载 |
| **筛选标准** | 只收录豆瓣 7.5 分以上影片 |
| **CDN** | Cloudflare |
| **直接抓取** | `bash scripts/search.sh cilixiong "{title}"` |

**站点结构：**
- 列表页：`/movie/index.html` → `/movie/index_2.html` ...（分页）
- 详情页：`/movie/{id}.html`
- 磁力链接位于：`<div class="tabs-container">` → `<a href="magnet:?xt=urn:btih:...">`
- 电影名/评分/日期：详情页前 3 个 `<span>` 标签

**抓取策略：**
1. 直接 `curl` 搜索页 → 提取详情页 URL → 逐个提取磁力链接（可能被 Cloudflare 拦截）
2. WebSearch `site:cilixiong.com {title}` → 命中搜索引擎缓存的详情页 → WebFetch 提取磁力链接
3. 镜像轮换：主站不可用时尝试 `.net` / `.cc`

#### 🧲 其他中文磁力搜索站
| **磁力猫** | cilimao.com | 老牌中文站，支持画质/体积筛选 |
| **磁力犬** | ciliquan.com | 零广告零跳转 |
| **磁力悠悠** | ciliuu.com | 自研爬虫，资源新 |
| **吴签磁力** | wuqiancili.com | 专注高清影视 |
| **小草磁力** | xiaocaocili.com | 极简无弹窗 |
| **SeedHub** | seedhub.cc | 豆瓣榜单自动匹配磁力，存活5年+ |
| **比特大雄** | btdx8.vip | 磁力+在线观看 |
| **磁力熊猫** | cilixiongmao.com | 轻量高效 |

#### 🌍 国际 BT 站（资源最全）

| 站点 | 域名 | 特点 |
|------|------|------|
| **BT4G** | bt4gpro.com | ⭐ DHT聚合，千万级索引。`scripts/search.sh bt4g` 直出磁力+种子数 |
| **BitSearch** | bitsearch.to | ⭐ DHT聚合，JSON API，磁力+种子+大小结构化数据。`scripts/search.sh bitsearch` |
| **1337x** | 1337x.to | 4K资源多，按热度排序 |
| **YTS** | yts.mx | 小体积高清电影，1080p仅1-3GB |
| **The Pirate Bay** | thepiratebay.org | 全球种子最全 |
| **TorrentGalaxy** | torrentgalaxy.to | 更新快，含IMDb评分 |
| **Nyaa** | nyaa.si | ⭐⭐ **番剧/动漫首选源**，按种子数排序。搜日文或英文名。`scripts/search.sh nyaa` |
| **Knaben** | knaben.org | 显示种子健康度 |

##### BT4G 抓取说明

```
搜索页: https://bt4gpro.com/search?q={query}
策略: curl 搜索页 → python3 解析 magnet 链接 + 种子数
    - 优先提取 magnet:?xt=urn:btih: 直接链接
    - 回退提取 /torrent/{hash} 链接补全 magnet
    - 再回退提取任意 40 位 hex hash
输出: magnet 链接 / "magnet | title | seeds:N | size" 格式
```

##### BitSearch API 说明

```
API: https://api.bitsearch.to/api/search?q={query}
类型: JSON API，直接解析
返回结构: { status, data: { results: [{ magnet, name, seeds, leechers, size }] } }
输出: "magnet | name | seeds:N | size" 格式
```

##### Nyaa 抓取说明

```
搜索页: https://nyaa.si/?q={query}&s=seeders&o=desc (按做种数排序)
适用: 番剧 / 动漫 / 剧场版动画
注意: 必须用英/日文标题搜，中文标题几乎无命中
策略: curl 搜索页 → python3 解析表格行提取 magnet + seeds + leechers
输出: "magnet | seeds:N | leechers:N" 格式
```

#### 🎨 番剧 / Anime 专属源

| 来源 | 说明 |
|------|------|
| **Nyaa** (nyaa.si) | ⭐⭐ **番剧首选**。需搜日文/英文名，中文名基本命中不了。按种子数排序 |
| **AniDex** (anidex.info) | 备用，索引较全 |
| **Tokyo Toshokan** (tokyotosho.info) | 老牌，部分 Nyaa 不收录的资源在这里 |
| **动漫花园** (dmhy.org) | 中文番剧社区，种子带字幕 |
| **蜜柑计划** (mikanani.me) | RSS 订阅型，资源更新快，中文资源多 |

**搜索提示：**
- Nyaa 必须用英文/日文标题搜，中文标题几乎无结果
- 番剧压制组推荐：SubsPlease (画质+体积平衡)、Erai-raws (体积小)、Judas (高画质)
- 合集 (Batch) 优先于单集下载
- 格式：HEVC/x265 10bit 是主流，部分老番只有 x264

#### MCP 工具（优先使用）

| 工具 | 用途 |
|------|------|
| **TorrentClaw MCP** `search_content` | 聚合多站，返回结构化磁力数据（种子数+质量+大小） |

> ⚠️ **重要**：这些站点大多使用 JS 渲染，WebFetch 无法直接抓取。**有效方式**是通过 WebSearch `"{title} {站名}"` 命中搜索引擎缓存的站内结果页。

#### WebSearch 磁力搜索 query 模板

```
# 定向搜索特定站点（优先）— 命中率和链接质量最高
"{title_zh} seedhub"              ← SeedHub 豆瓣匹配
"{title_zh} 磁力猫"               ← 中文老牌站
"{title_zh} btcilixiong"          ← BT磁力熊
"{title_en} 1337x"                ← 国际综合站
"{title_en} yts"                  ← 小体积高清
"{title_en} torrentgalaxy"        ← 更新快

# 通用中文磁力搜索
"{title_zh} {year} 磁力链接 BT下载 1080p"
"{title_zh} {year} 4K 种子"

# 通用英文（可能被过滤，作为补充）
"{title_en} {year} 1080p BluRay torrent"
```

# 剧集合集
"{title} complete S01-S{N} 1080p torrent"

# 🎨 番剧 / Anime
"{title_jp} site:nyaa.si"                    ← ⭐⭐ Nyaa 搜索（日文名）
"{title_en} site:nyaa.si"                    ← Nyaa 英文名搜索
"{title_zh} 番剧 BD 下载"                     ← 中文番剧资源
"{title_zh} 动漫花园"                          ← 中文动漫社区
"{title_jp} batch 1080p torrent"              ← 日文全集搜索
"{title_zh} {year} 动漫 1080p 磁力"
```

### 网盘资源

| 来源 | 类型 | 说明 |
|------|------|------|
| **夸克网盘** | 云盘 | 中文用户常用，命中率高。`scripts/search.sh quark` 通过 PanSearch 聚合搜索 |
| **阿里云盘** | 云盘 | 不限速，资源丰富。搜索站多为JS渲染，通过 WebSearch `"{title} 阿里云盘"` |
| **百度网盘** | 云盘 | 用户基数最大，但搜索关键词敏感。通过 WebSearch `"{title} 百度网盘"` |

> 网盘资源是磁力/BT 的重要补充，老片/冷门片常以网盘形式传播。

### 图书电子版

| 来源 | 类型 | 说明 |
|------|------|------|
| **Z-Library** | 电子书 | 全球最大电子书库。域名经常变更，通过 WebSearch 找最新可用地址 |
| **Anna's Archive** (annas-archive.org) | 电子书 | Z-Lib + LibGen + Sci-Hub 聚合搜索 |
| **Library Genesis** (libgen.is) | 学术+大众 | 老牌电子书库，学术书籍丰富 |
| **Project Gutenberg** (gutenberg.org) | 公版书 | 版权过期的免费公版书 |

#### WebSearch 电子书搜索 query 模板

```
# 通用搜索
"{title} {author} PDF epub download"

# Z-Library
"{title} {author} Z-Library"

# Anna's Archive
"{title} annas-archive.org"

# 中文图书
"{title} PDF 下载 电子书"
"{title} epub mobi 下载"

# 学术/技术书
"{title} {author} libgen PDF"
```

---

## 搜索优先级建议

### 信息聚合优先级

1. **TMDB** — 电影/剧集基本信息首选（结构化 API，数据最全）
2. **豆瓣** — 中文用户评分首选（通过 WebSearch）
3. **IMDb** — 全球用户评分首选（通过 WebSearch + OMDb）
4. **烂番茄** — 影评人视角补充
5. **Open Library / Google Books** — 图书信息首选

### 下载资源优先级

1. **TorrentClaw MCP** — 影视种子首选（结构化数据，含磁力链接）
2. **WebSearch 磁力站** — MCP 不可用时的 fallback
3. **Anna's Archive** — 图书下载首选
4. **WebSearch Z-Library** — 图书 fallback
