---
name: chacha
description: "Tell AI what you need — it browses major resource sites and search platforms to find valid download links for you. ① Extract valid links ② Cross-source aggregated search ③ Info aggregation"
create_by: fei
---

# chacha — AI Resource Finder

"Chacha" (查查) means "look it up" in Chinese. Tell it what you need — it browses major resource sites and search platforms to find valid download links for you. Three core capabilities:

1. **Extract valid links** — Directly extract magnet and cloud drive links from search pages / APIs, verify availability via HEAD requests, deduplicate, and output ready-to-copy strings
2. **Cross-source aggregated search** — 9 sources in parallel (cilixiong / SeedHub / YTS / 1337x / BT4G / BitSearch / Nyaa / Quark / WebSearch), with self-healing domains
3. **Info aggregation** — IMDb/Douban ratings, cast, plot, highlight + download links in a single message

## Language Adaptation

**Detect the user's language from their query and respond in the same language.** Examples:

- User types `/chacha Interstellar` → respond in English
- User types `/chacha 星际穿越` → respond in Chinese
- User types `/chacha 千と千尋の神隠し` → respond in Japanese

All output labels, hints, and interaction text should match the user's language. Only download search queries are fixed (see Search Language Rules below).

## Core Principles

- **Info always wins**: Even if all download sources fail, still output the info section (ratings, cast, plot, highlight). A result with no links is better than no result.
- **Downloads first**: Download links are the primary output when available. Info is compact and front-loaded; 80% of the output is copyable download links
- **One shot**: Info and download searches run in parallel — no step-by-step confirmation. The user invoked this skill to find resources
- **Copyable links**: Display magnet links as full `magnet:?xt=urn:btih:...` strings. Cloud drive links include extraction codes. No icon-only placeholders
- **WebSearch first**: All data via WebSearch + WebFetch. No external MCP dependency
- **MCP enhancement**: If TorrentClaw MCP or douban-mcp-cli is configured, prefer them for structured data
- **Real results only**: All ratings and links must come from search results. Never fabricate data
- **Link validity check**: Before presenting download links, perform a quick validity check on cloud drive / HTTP URLs (HEAD request with `curl -sL -o /dev/null -w "%{http_code}" --max-time 5`). Filter out 404/expired links. Magnet links are verified by hash format (`btih:[a-fA-F0-9]{40}`). Broken links = wasted user trust

## Workflow

### Step 1: Parse Input

Extract from the user's message:
- **Input content** (required)
- **Input type**: Work title OR Creator name (director / author)

**Classification rules:**
- If the input is `hot`, `new`, or `top` → **Discovery Mode**, show a ranked list of trending/newest/top-rated works
- If the input is a country/region name (e.g. "日本", "国产", "韩国", "美国", "UK", "France", "India", "泰国") → **Country Mode**, discover well-rated works from that country
- If the input contains words like "director", "author", "works", "filmography", "bibliography", "导演", "作者", "作品", or is a known creator name → **Creator Mode**, show their works list
- If the input contains anime-related keywords ("番剧", "动漫", "动画", "anime") or is a known anime title → **Anime Mode**, search as anime media type
- Otherwise → **Work Mode**, search for a single work directly

**Work Mode** — continue parsing:
- **Title** (required)
- **Year** (optional, for exact matching)
- **Media type** (movie / TV show / book / anime)

**Auto-detect anime**: If the title is a known anime (e.g. "进击的巨人", "鬼灭之刃", "Naruto", "One Piece") or the user explicitly says "番剧" / "动漫" / "anime", set media type to `anime` without asking.

If the media type is ambiguous, use `AskUserQuestion` (in the user's language):
```
What type of media is this?
- 🎬 Movie
- 📺 TV Show
- 📚 Book
- 🎨 Anime
```

**Creator Mode** — continue parsing:
- **Creator name** (required)
- **Field**: Film director / Author / Anime director / Mangaka (infer from context if possible; otherwise ask)

**Discovery Mode** — continue parsing:

The user invoked `hot`, `new`, or `top`. First, ask what type of media they're interested in (in the user's language):

```
What type of media are you looking for?
- 🎬 Movie
- 📺 TV Show
- 📚 Book
- 🎨 Anime
```

Then proceed to Discovery Mode search (see Step 2).

**Country Mode** — continue parsing:

The user input is a country/region name (e.g. "日本", "国产", "韩国", "美国"). First, ask what type of media they're interested in (in the user's language):

```
What type of media are you looking for?
- 🎬 Movie
- 📺 TV Show
- 📚 Book
- 🎨 Anime
```

Then proceed to Country Mode search (see Step 2).

### Step 2: Parallel Search

#### Work Mode (info + downloads simultaneously)

Launch all searches in parallel. **Never wait for info results before searching downloads — one shot.**

**Info searches (2-3):**
```
Movie/TV Show:
- "{title} {year} IMDb rating cast director plot"    ← cast/actors is mandatory
- "{title} {year} 主演 演员 豆瓣评分"                  ← for Chinese cast names
- "{title} {year} Rotten Tomatoes score review"       ← optional, as needed

Anime:
- "{title} {year} MyAnimeList rating anime review"    ← MAL is primary anime rating source
- "{title} 动漫 评分 豆瓣 Bangumi"                     ← Chinese anime rating platforms
- "{title} AniList rating synopsis"                    ← optional, as needed
```

**Info extraction checklist:**
- ☑ Title (original + localized)
- ☑ Year / Season (for anime: e.g. "Spring 2024")
- ☑ Director / Studio (for anime: include animation studio)
- ☑ **Main cast** (at least top 3-5 actors / voice actors, with role names if available)
- ☑ Ratings (IMDb + Douban minimum; for anime: MyAnimeList + Bangumi)
- ☑ Genre tags
- ☑ One-line plot summary
- ☑ Episodes (for anime TV series: total episode count)

**Season selection (TV Show / multi-season Anime only):**
After info search confirms the show has 2+ seasons, ask the user which season to search:

```
📺 {title} has {N} seasons. Which one do you want?
1. Season 1 ({year_start})
2. Season 2 ({year_start+1})
...
N. All seasons (Complete Series)
```

Store the answer as `{season}` variable. For download searches:
- If user picks a specific season → use `S{season:02d}` (e.g. S01, S05) in queries
- If user picks "All seasons" → use `Complete Series` / `S01-S{N}`

Proceed directly — don't wait for confirmation after selection.

**Download searches (WebSearch + direct scraping, launched simultaneously):**

> **Search Language Rules**: English `torrent` / `magnet` keywords trigger safety filters. Always use Chinese keywords for download searches.

> **Title variables**: `{title}` = original input, `{title_en}` = English title, `{title_zh}` = Chinese title, `{title_jp}` = Japanese/romaji title (for anime). For TV Shows with a season selected, append `S{season:02d}` to the title (e.g. `"Black Mirror S01"`). For "All seasons", use `"Complete Series"` or `"S01-S{N}"`.

**Tier 1 — Direct scraping (highest link quality, runs in parallel):**

For TV Shows, append `{season}` (e.g. `S01`, `S05`, `Complete`) to the search query.
```
bash scripts/search.sh cilixiong "{title} {season}"    ← ⭐ cilixiong — Douban-rated movies, best link survival
bash scripts/search.sh seedhub "{title_en} {season}"   ← SeedHub — Douban-matched magnets
bash scripts/search.sh yts "{title_en}"                ← YTS — movies only, skip for TV Shows
bash scripts/search.sh 1337x "{title_en} {season}"     ← 1337x — 4K resources
bash scripts/search.sh bt4g "{title_en} {season}"      ← ⭐ BT4G — DHT aggregator, millions of entries
bash scripts/search.sh bitsearch "{title_en} {season}" ← ⭐ BitSearch — DHT aggregator API
bash scripts/search.sh nyaa "{title_jp} {season}"      ← ⭐ Nyaa — anime primary source
bash scripts/search.sh quark "{title_zh} {season}"     ← Quark cloud drive
```

**Tier 2 — WebSearch fallback:**

For TV Shows, append season keyword (e.g. `S01`, `第1季`, `Complete Series`) to each query.
```
Movie:
- "{title_zh} site:cilixiong.com"                ← ⭐ search engine-cached cilixiong pages
- "{title_zh} {year} 磁力链接 BT下载 1080p"
- "{title_zh} 夸克网盘"
- "{title_zh} 阿里云盘"

TV Show (append {season} to title):
- "{title_zh} {season} site:cilixiong.com"
- "{title_zh} {season} seedhub"
- "{title_zh} {season} bt4g"
- "{title_zh} {season} {year} 磁力链接 BT下载"
- "{title_zh} {season} 夸克网盘"

Anime:
- "{title_jp} {season} site:nyaa.si"             ← ⭐ Nyaa search engine cache
- "{title_en} {season} site:nyaa.si"
- "{title_zh} 番剧 BD 下载 1080p"
- "{title_zh} 动漫 樱花"
```

The scraping script `scripts/search.sh` uses `curl` with proper User-Agent to fetch pages directly and extract magnet/cloud links via perl/python3. It returns structured results faster than WebSearch.

**Self-healing domains**: If the script outputs `SITE_DEAD:<site>`, the site's domain is no longer accessible. The AI should run domain discovery:

1. WebSearch `"{site name} 新地址 2026"` or `"{site name} 最新可用域名"`
2. Extract the current working domain from search results
3. Write to cache: use `python3 -c "import json; ..."` to update `/tmp/chacha-domains-cache.json` (append, don't overwrite other sites)
4. Re-run `search.sh` — it will use the cached domain first
5. If still failing, fall back to Tier 2 WebSearch

#### Creator Mode (works list)

Search for the creator's representative works:

```
Film director:
- "{name} filmography director movies ranked"
- "{name} 导演 作品列表 代表作 豆瓣"
- "{name} best movies IMDb"

Author:
- "{name} books bibliography Goodreads"
- "{name} 作者 作品列表 豆瓣"
- "{name} best books ranked"
```

List 5-10 representative works sorted by rating/popularity. Include ratings for each. After displaying the list, offer follow-up options so the user can drill into a specific work for download resources.

#### Discovery Mode (hot / new / top)

Based on the user's media type selection and the command (`hot` / `new` / `top`), search for ranked lists:

**Search queries (run in parallel):**
```
Movie:
- "{year} best movies {hot|new|top} IMDb ranking"
- "{year} 热门电影 排行榜 豆瓣"
- "{year} most {popular|anticipated|rated} movies Rotten Tomatoes"

TV Show:
- "{year} best TV shows {hot|new|top} IMDb ranking"
- "{year} 热门剧集 排行榜 豆瓣"
- "{year} most {popular|anticipated|rated} TV series Rotten Tomatoes"

Anime:
- "{year} best anime {hot|new|top} MyAnimeList ranking"
- "{year} 热门番剧 排行榜 Bangumi"
- "{season} anime ranking new series"              ← e.g. "spring 2025 anime ranking"

Book:
- "{year} best books {hot|new|top} Goodreads"
- "{year} 热门图书 排行榜 豆瓣"
- "{year} bestseller books NYT"
```

**Command mapping:**
| Command | Meaning | Search focus |
|---------|---------|-------------|
| `hot` | Trending / popular right now | "热门", "trending", "popular" |
| `new` | Recently released / upcoming | "最新", "new releases", "upcoming" |
| `top` | All-time highest rated | "排行榜", "top rated", "best of all time" |

Display **50 items** in a compact ranked table. See `references/output-templates.md` for the discovery list template.

#### Country Mode

Same as Discovery Mode, but filtered by country. The country name (e.g. "日本", "韩国", "France") is injected into search queries to focus on works from that region.

**Search queries (run in parallel):**
```
Movie:
- "best {country} movies {hot|new|top} IMDb ranking"
- "{country} 电影 排行榜 豆瓣"
- "{country} films Rotten Tomatoes top rated"

TV Show:
- "best {country} TV shows {hot|new|top} IMDb ranking"
- "{country} 剧集 排行榜 豆瓣"

Anime (when country is Japan):
- "best anime {hot|new|top} MyAnimeList ranking"
- "日本 番剧 排行榜 Bangumi"

Book:
- "best {country} books {hot|new|top} Goodreads"
- "{country} 图书 排行榜 豆瓣"
```

Display **50 items** in a compact ranked table.

### Step 3: Validate & Aggregate

**3a. Link validity check** — Before presenting, verify all download links:

```
# Cloud drive / HTTP links — HEAD request
curl -sL -o /dev/null -w "%{http_code}" --max-time 5 "<url>"
# 200/301/302/307 → keep. 404/403/410/500 → discard with reason "已失效"

# Magnet links — verify hash format (no network check possible)
echo "<magnet>" | grep -qP 'btih:[a-fA-F0-9]{40}'
# valid format → keep. malformed → discard
```

Mark checked links with status: ✅ Valid / ⚠️ Suspect / ❌ Dead

**3b. Generate highlight** — Write one compelling sentence that makes the user want to watch/read this specific work. Tailor to the work's unique appeal:

- 🎬 **Movie**: Hook from plot premise, directorial style, or standout cast. *Not* generic praise.
- 📺 **TV Show**: Hook from premise, critical buzz, or binge-worthiness.
- 🎨 **Anime**: Hook from animation studio, director, unique premise, or cultural impact.
- 📚 **Book**: Hook from theme, writing style, or why it resonates.

Examples:
```
🔥 Highlight: Nolan tells a spy thriller in reverse with entropy as the antagonist — time itself is the ultimate villain.
🔥 Highlight: Hard sci-fi + crushing loneliness — one man on Mars planting potatoes while the whole Earth holds its breath.
```

**3c. Compile** — Merge info, cast, highlight, and validated download links into the output template.

> **⚠️ Critical: never return nothing.** If all download sources failed (scripts timed out, sites blocked, no matches), still output the info section with a note: `"No download resources found for this title."` The user gets ratings, cast, and highlight — useful information even without links. An empty response is the worst outcome.

## Output Format

**Core rule: Info is compact and front-loaded. Download links are the main content.** Info header (title, ratings, cast, plot, highlight) takes 4-5 lines. Download resources take 80%+ of the output. Links must be directly copyable — full magnet strings, cloud links with extraction codes. Every link must pass validity check before display (✅/⚠️/❌).

**Info is mandatory, links are optional.** If zero download resources are found, output the info section alone with `"No download resources found"` — never return empty-handed.

See `references/output-templates.md` for the full output templates (movie, TV show, book, anime, creator works list, discovery list).

## Custom Search Sources

Users can add or modify search sources through natural language. These customizations are stored in `~/.config/chacha/sources.json` — outside the skill directory, so they survive skill updates.

**How the AI handles "add source" requests:**

When the user says something like:
- "帮我加一个搜索源，叫动漫花园，域名 dmhy.org"
- "把 bt4g 的域名改成 bt4g.life"
- "添加一个新源，名字是 myanime，域名 myanime.me"

The AI should:

1. **Validate** the domain: `curl -sL --max-time 5 "https://{domain}" > /dev/null` — reject if unreachable
2. **Infer the path**: if the site looks like a BT search engine, the path is likely `/search?q={query}`. Common patterns:
   - `/{query}` (path-based search)
   - `/search?q={query}` (query param)
   - `/search?keyword={query}`
3. **Write** to `~/.config/chacha/sources.json`:
   ```bash
   mkdir -p ~/.config/chacha
   python3 -c "
   import json, os
   file = os.path.expanduser('~/.config/chacha/sources.json')
   data = {}
   if os.path.exists(file):
       with open(file) as f:
           data = json.load(f)
   data['{source_name}'] = {
       'domain': '{domain}',
       'mirrors': [],
       'path': '{path}'
   }
   with open(file, 'w') as f:
       json.dump(data, f, indent=2)
   "
   ```
4. **Confirm** to the user: "已添加搜索源 `{name}` ({domain})，下次搜索自动生效"

**Merge priority** (highest to lowest):
1. `/tmp/chacha-domains-cache.json` — AI self-healing cache
2. `~/.config/chacha/sources.json` — user custom sources
3. `scripts/domains.json` — shipped defaults

Custom sources with the same key name as a default source **override** the default (e.g. `"bt4g": {"domain": "bt4g.life"}` replaces the shipped bt4g entry).

## Interaction Guide

See `references/interaction-guide.md` for:
- Follow-up actions after search completes
- CLI commands by platform (macOS / Linux / Windows)
- Handling duplicate titles
- Handling fuzzy input (Did You Mean?)

## Key Notes

1. **Disclaimer**: Download sections must include a "for personal study/research only" notice
2. **Data authenticity**: All ratings, cast, and info must come from search results. Never fabricate
3. **Validity check**: Cloud/HTTP links → HEAD request. Magnet links → hash format check. Mark all links ✅/⚠️/❌
4. **Cast is mandatory**: Always list 3-5 main actors with 🎭 prefix. Search `{title} 主演 演员` for Chinese names. For anime, list voice actors (声优) with 🎤
5. **Highlight must be specific**: One tailored sentence per work. Never copy-paste generic praise
6. **Deduplication**: Remove duplicate resources across sources (by file size, magnet hash)
7. **Quality sorting**: Valid links first (✅), then by quality. Expired (❌) at bottom
8. **Books disclaimer**: Ebook availability is far lower than video. Manage user expectations upfront
9. **Freshness**: Default to using the current year to help filter out stale resources
10. **Anime source priority**: For anime, try Nyaa (nyaa.si) first as primary source, fall back to general BT/cloud sources. Always search by English or Japanese title on Nyaa

## References

- `references/data-sources.md` — Data source details
- `references/search-strategy.md` — Search strategies & query templates
- `references/output-templates.md` — Output format templates (movie, TV, book, creator)
- `references/interaction-guide.md` — Interaction patterns & CLI commands
