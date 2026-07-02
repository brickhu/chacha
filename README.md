# chacha — AI Resource Search Assistant

> 查查 (chá chá) means "look it up" in Chinese. Tell it what you need — it finds valid download links for you.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![skills.sh](https://img.shields.io/badge/skills.sh-chacha-38bdae)](https://skills.sh/brickhu/chacha)
[English](./README.md) | [中文](./README_cn.md)

chacha is an AI resource search assistant. You tell it what you want to watch or read — it browses resource sites and search platforms in parallel, extracts download links, verifies they're alive, and returns ready-to-copy magnets and cloud drive URLs.

## Why not just use a search engine?

| Task | Search Engine | chacha |
|------|--------------|--------|
| Find a download link | Returns web pages, you click around | Extracts `magnet:` links directly |
| Link alive? | You find out after clicking | ✅ HEAD-verified before output |
| Quality info | 2-3 extra tabs (IMDb, Douban, RT) | Included in one message |
| Multiple sources | Search again per source | 9 sources in parallel |
| Dead domain | You wait for site to come back | AI auto-discovers new domain |

Search engines are great at finding *websites*. chacha is purpose-built for finding *download links*.

## Why not just use a BT site?

BT sites list every uploaded torrent — chacha does the work for you:

- **No browsing**: skips the search → click → detail page → copy magnet flow
- **No dead links**: validates cloud drive URLs before you see them
- **Cross-source**: queries 9 sources at once, not one at a time
- **Self-healing**: when a site changes domain, AI finds the new one automatically

## What you can search

| Type | Examples | Sources |
|------|----------|---------|
| 🎬 **Movie** | Interstellar, 星际穿越, Parasite | IMDb, Douban, RT + 6 magnet sources + cloud drives |
| 📺 **TV Show** | Breaking Bad, 权力的游戏, 黑镜 | Per-season downloads, complete series |
| 🎨 **Anime** | 進撃の巨人, 鬼滅の刃, One Piece | MyAnimeList, Bangumi + Nyaa primary |
| 📚 **Book** | 三体, 1984, Sapiens | Goodreads, Douban + ebook downloads |
| 🎬 **Director** | Christopher Nolan, 诺兰 | Ranked works list with ratings |
| 📺 **Trending** | `/chacha hot`, `/chacha new`, `/chacha top` | 50-item ranked discovery lists |
| 🌍 **By country** | `/chacha 日本`, `/chacha 韩国`, `/chacha France` | Filtered by region |

## How it works

```
/chacha 星际穿越
  → Check ~/.config/chacha/search-cache.json (24h TTL)
  → Parallel info search: IMDb · Douban · Rotten Tomatoes
  → Parallel download search (9 sources):
     · BT4G, BitSearch (DHT aggregators)
     · 1337x, YTS (torrent sites)
     · Nyaa (anime)
     · SeedHub, cilixiong (Chinese catalog)
     · Quark cloud drive
     · WebSearch (fallback)
  → Verify cloud drive links via HEAD request
  → Deduplicate, sort by quality
  → Return compact result:
     # 🎬 星际穿越 Interstellar
     * **Director**: Christopher Nolan · 2014 · USA/UK · 169min
     * **Cast**: 马修·麦康纳 / 安妮·海瑟薇 / ...
     * **Rating**: ★ ★ ★ ★ ★ ｜ IMDb 8.7 · 豆瓣 9.4 · RT 86%/91%
     ✅ magnet:?xt=urn:btih:...  1080p  12GB  seeds:1500
     ✅ magnet:?xt=urn:btih:...  4K     45GB  seeds:320
```

When a site domain is dead, AI auto-discovers the new address via WebSearch and caches it — no maintenance needed.

## Quick Start

```bash
npx skills add brickhu/chacha
```

Then in your AI harness (Claude Code, Codex, Cursor, Windsurf, Cline, Trae):

```
/chacha Interstellar
/chacha 星际穿越
/chacha 诺兰              ← creator mode: works list
/chacha 日本              ← country mode: discover Japanese works
/chacha hot               ← discovery mode: trending / new / top
/chacha sources           ← list configured search sources
/chacha discover sources  ← find and add new sources
```

## Data Storage

All user data lives in `~/.config/chacha/` — survives skill updates:

```
~/.config/chacha/
├── sources.json          ← search sources (default + custom + self-healed)
├── search-cache.json     ← cached results (24h TTL)
```

## Disclaimer

Download resources are provided for **personal study/research only**. All copyrights belong to the original creators. Please support official releases.

## License

MIT
