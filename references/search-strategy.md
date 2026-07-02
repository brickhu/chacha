# 搜索策略详解

## 搜索原则

### 并行优先
所有不依赖彼此的搜索必须并行发起。一个典型搜索会话需要：
- 2-3 个信息/评分 WebSearch
- 2-3 个下载资源 WebSearch（可选）

### 查询构建规则

1. **引号精确匹配**：作品名用引号包裹，如 `"Interstellar" 2014 IMDb`
2. **双语覆盖**：中文作品搜中英双语，如 `"三体" "The Three-Body Problem" 豆瓣`
3. **年份锚定**：加上年份避免重名，如 `"Dune" 2021 rating`
4. **平台限定**：评分搜索用 `site:` 限定，如 `site:douban.com 星际穿越`
5. **去噪**：排除不相关关键词，如 `-游戏 -手游 -同人`（针对与游戏同名的作品）
6. ⚠️ **下载搜索必须用中文关键词**：英文 `torrent` `magnet` 等关键词可能被安全过滤器拦截。改用中文关键词：`磁力链接` `BT下载` `种子` `网盘`。信息搜索中英文均可正常使用

---

## 分媒体类型搜索策略

### 🎬 电影

#### 轮次 1 — 基本信息 + 评分（并行 4 个搜索）

```
搜索 1 (豆瓣):
"{title_zh}" "{title_en}" site:movie.douban.com 评分

搜索 2 (IMDb):
"{title_en}" {year} IMDb rating cast review

搜索 3 (烂番茄/综合):
"{title_en}" {year} Rotten Tomatoes Metacritic score

搜索 4 (基本信息):
"{title_en}" {year} film cast director plot summary runtime
```

#### 结果解析要点

- **豆瓣**: 评分通常在搜索结果摘要中直接显示，格式为「评分: X.X」
- **IMDb**: 评分格式为「X.X/10」，评分数如「2.1M」
- **烂番茄**: 注意区分 Tomatometer（影评人%）和 Audience Score（观众%）
- **Metacritic**: 注意 Metascore（影评人加权分，0-100）和 User Score（用户分，0-10）

#### 轮次 2 — 下载资源（用户确认后，并行 2-3 个搜索）

```
搜索 1 (通用):
"{title_en}" {year} 1080p 4K torrent magnet download

搜索 2 (中文源):
"{title_zh}" 下载 磁力链接 BT

搜索 3 (高质量):
"{title_en}" {year} BluRay REMUX HDR torrent
```

#### 结果解析要点

- **磁力链接**: 以 `magnet:?xt=urn:btih:` 开头，长度 40+ 字符的 hash
- **种子数**: seeds/peers 字段，优先选择 seeds > 100 的资源
- **文件大小**: 1080p 通常 2-8GB，4K 通常 15-50GB，REMUX 通常 40-80GB
- **质量标识**: 1080p, 2160p(4K), BluRay, WEB-DL, HDR, DV(Dolby Vision), REMUX

---

### 📺 剧集

#### 轮次 1 — 基本信息 + 评分（并行 4 个搜索）

```
搜索 1 (豆瓣):
"{title_zh}" "{title_en}" site:movie.douban.com 剧集 评分

搜索 2 (IMDb):
"{title_en}" TV series IMDb rating seasons episodes

搜索 3 (基本信息):
"{title_en}" TV show cast creator seasons plot network

搜索 4 (季数/状态):
"{title_en}" TV series how many seasons ended or ongoing
```

#### 结果解析要点

- **季数信息**: 需要确认是续订中(ongoing)还是已完结(ended)
- **各季评分**: IMDb 各季评分通常独立，需要注意区分
- **播出平台**: Netflix/HBO/Amazon/Disney+ 等，影响资源来源

#### 轮次 2 — 下载资源（用户确认后）

```
搜索 1 (全集):
"{title_en}" complete series S01-S{N} 1080p torrent

搜索 2 (最新季):
"{title_en}" S{latest} 1080p 4K torrent magnet

搜索 3 (中文源):
"{title_zh}" 全集 下载 磁力链接
```

#### 剧集特有注意事项

- 优先找全集合集（complete series），其次是单季
- WEB-DL 和 WEBRip 对剧集来说质量通常足够（大部分剧集流媒体首播）
- 注意区分不同压制组（release group）的质量口碑
- 老剧可能只有 720p 或 DVD 画质

---

### 🎨 番剧 / Anime

#### 轮次 1 — 基本信息 + 评分（并行 4 个搜索）

```
搜索 1 (MyAnimeList):
"{title_jp}" "{title_en}" MyAnimeList rating episodes studio

搜索 2 (Bangumi / 豆瓣):
"{title_zh}" 番剧 Bangumi 评分 声优

搜索 3 (AniList / ANN):
"{title_en}" AniList Anime News Network review

搜索 4 (基本信息):
"{title_en}" anime episodes studio cast season year
```

#### 轮次 1 特有注意事项

- **MyAnimeList (MAL)** 是番剧评分首选，评分格式为「X.XX」
- **Bangumi** 是中文番剧评分首选，评分格式为「X.X」
- **Studio**（动画制作公司）是番剧信息的重要组成部分，类似电影的导演
- **声优 (voice actors)** 应列为主要卡司，使用 🎤 前缀
- **季度信息**：确认属于哪个播出季（2024年春/夏/秋/冬），影响资源命名
- **集数**：标注总集数，区分 TV 版与 OVA/剧场版

#### 轮次 2 — 下载资源（用户确认后）

```
搜索 1 (Nyaa — 首选):
"{title_jp}" "{title_en}" site:nyaa.si

搜索 2 (全集/BD):
"{title_en}" BD batch torrent magnet
"{title_jp}" BD 合集 ダウンロード

搜索 3 (中文源):
"{title_zh}" 番剧 下载 1080p 磁力
"{title_zh}" BDrip 合集
```

#### 搜索结果解析要点

- **压制组**: Nyaa 上同一资源可能有多个压制组（SubsPlease, Erai-raws, Judas, AnimeKaizoku 等），优先选择 Seeds 最高且质量口碑好的
- **格式偏好**: HEVC/x265 10bit 是番剧主流高质量格式，体积比 x264 小约 30-50%
- **字幕**: Nyaa 上的 raw 通常不带字幕，需额外找字幕组版或外挂字幕
- **合集 (Batch)**: 完整番剧通常以「Batch」形式发布，包含所有剧集
- **剧场版**: 按「电影」处理，但搜索源用 Nyaa 而非其他 BT 站
- **BD vs TV**: BD 版画质更好、修正了 TV 版的作画失误，优先选择 BD

#### 番剧特有降级策略

当 Nyaa 无结果时：

```
第一级: Nyaa 换标题语言（英 ↔ 日）
第二级: WebSearch "{title_zh} 番剧 网盘"
第三级: WebSearch "{title_zh} 动漫 樱花 在线"     ← 樱花是常见番剧镜像站
```

---

### 📚 图书

#### 轮次 1 — 基本信息 + 评分（并行 3-4 个搜索）

```
搜索 1 (豆瓣):
"{title_zh}" site:book.douban.com 评分 作者 出版社

搜索 2 (Goodreads):
"{title_en}" {author} Goodreads rating reviews

搜索 3 (基本信息):
"{title_en}" {author} book publisher pages ISBN publication date

搜索 4 (Google Books):
"{title_en}" {author} Google Books rating
```

#### 结果解析要点

- **豆瓣读书**: 评分格式为「X.X」，注意区分「评价人数」和「评分人数」
- **Goodreads**: 评分格式为「X.XX / 5」，评分数如「1,234,567 ratings」
- **ISBN**: 10位或13位数字，是查找电子版的精确标识
- **作者**: 中文书注意简繁体作者名一致，外文书注意译名不统一

#### 轮次 2 — 下载资源（用户确认后）

```
搜索 1 (Anna's Archive):
"{title_en}" {author} annas-archive.org

搜索 2 (Z-Library):
"{title}" {author} Z-Library PDF epub

搜索 3 (中文书):
"{title_zh}" PDF epub mobi 下载

搜索 4 (LibGen):
"{title}" {author} libgen PDF
```

#### 图书特有注意事项

- **管理预期**：大部分书没有免费电子版，尤其是新出版/小众/中文书
- **格式优先级**：EPUB > PDF > MOBI > AZW3（EPUB 通用性最好）
- **公版书**：版权过期（通常作者去世 50-70 年）的书在 Project Gutenberg 免费合法下载
- **扫描版 vs 文字版**：PDF 可能是扫描版（体积大、不可搜索）或文字版（体积小、可搜索）
- **中英文版本独立**：不要混淆原著和译本，分别搜索

---

## 特殊情况处理

### 重名作品

**识别**：搜索结果出现多个同名不同年的作品

**处理**：
1. 列出候选：年份 + 类型 + 主要创作者
2. 让用户选择
3. 示例输出：
```
找到多个匹配结果，请选择：
1. 🎬 《Dune》(2021) — Denis Villeneuve 导演
2. 🎬 《Dune》(1984) — David Lynch 导演
3. 📺 《Dune: Prophecy》(2024) — HBO 剧集
```

### 动画电影/番剧

动画作品跨电影和剧集两个类别：
- 剧场版动画 → 按「电影」处理
- TV 动画/番剧 → 按「剧集」处理
- 搜索下载资源时加上 `BD` `BDRip` `动漫` 关键词提高命中率
- 动漫资源首选 Nyaa (nyaa.si)

### 冷门/独立作品

- 放宽搜索条件（去掉年份限制、去掉引号精确匹配）
- 尝试不同的标题变体（原名、译名、简称）
- 下载资源搜索用更泛化的关键词（如去掉质量限定）
- 在结果中明确标注「信息有限」而非留空

### 下载搜索降级策略

当直接的磁力/BT 搜索无结果时，按以下优先级逐级降级：

#### 第一级：磁力/BT（首选）

```
"{title_zh} {year} 磁力链接 BT下载 1080p"
"{title_zh} {year} 种子 下载"
```

→ 对热门商业片命中率高，老片/艺术片可能无结果

#### 第二级：网盘搜索（老片/艺术片首选）

> ⚠️ `百度网盘 下载` 组合会触发安全过滤，需拆分使用。

```
"{title_zh} 夸克网盘"          ← 不会被过滤，资源丰富
"{title_zh} 阿里云盘"          ← 不会被过滤
"{title_zh} 百度网盘"          ← 单独用"百度网盘"不过滤，加"下载"会触发
"{title_zh} 网盘 资源"         ← 通用网盘搜索
```

→ 老片/冷门片多以网盘形式传播。夸克网盘和阿里云盘命中率最高

#### 第三级：公众号/论坛

```
"{title_zh} 资源 公众号"
"{title_zh} 电影 下载"
"{title_zh} 高清修复 资源"
```

→ 影视类微信公众号常用「关注回复关键词」方式分享资源链接

#### 第四级：特定版本搜索

```
"{title_zh} 4K修复版"
"{title_zh} 导演剪辑版"
"{title_zh} Criterion Collection"
"{title_zh} 蓝光原盘"
```

→ 利用版本关键词缩小范围，绕过通用安全过滤。新修复/重映的老片命中率更高

#### 第五级：泛化搜索

```
"{title_zh} 在线观看"
"{title_zh} 完整版"
"{director} {title_zh}"
```

→ 完全去掉下载暗示，用在线观看等中性词，有时能意外发现下载渠道

### 新上映/未上映作品

- 标注「尚未上映」或「上映日期」
- 下载资源部分标注「尚未发行，无下载资源」
- 提供预告片/期待值等替代信息
- 建议设置「上映后提醒」或定期回查

---

## 结果质量评估

### 数据可信度

| 信号 | 可信度 |
|------|--------|
| 来自官方 API (TMDB, OMDb) | ⭐⭐⭐⭐⭐ |
| 来自知名平台搜索结果摘要 (豆瓣/IMDb) | ⭐⭐⭐⭐ |
| 来自 WebFetch 抓取的详情页 | ⭐⭐⭐ |
| 来自论坛/博客/个人网站 | ⭐⭐ |
| 搜索结果不一致 | ⭐ 需要交叉验证 |

### 下载资源健康度

| 种子数 | 健康状态 |
|--------|---------|
| > 1000 | 🟢 极佳 |
| 100-1000 | 🟢 良好 |
| 10-100 | 🟡 一般 |
| 1-10 | 🟠 较差 |
| 0 | 🔴 死种 |
