# chacha — AI Resource Finder

> 查查 (chá chá) means "look it up" in Chinese. Just ask — chacha finds it.

[![中文文档](https://img.shields.io/badge/文档-中文版-red)](./README_cn.md)

chacha is an AI-powered resource discovery agent for **movies, books, and TV shows**. It aggregates ratings from multiple platforms (IMDb, Douban, Rotten Tomatoes, Goodreads) and finds download links (magnet, BT, cloud drives) — all in one shot.

## Installation

```bash
npx skills add brickhu/chacha
```

This installs the `chacha` skill globally. Once installed, use `/chacha <query>` in Claude Code to start searching.

## Features

- 🎬 **Movie search** — ratings from IMDb, Douban, Rotten Tomatoes + magnet/BT/cloud links
- 📺 **TV show search** — season-by-season ratings + complete series downloads
- 📚 **Book search** — Goodreads & Douban ratings + ebook download links
- 🎥 **Creator mode** — search by director or author to discover their works
- 🌐 **Multi-language** — responds in the same language as your query (English, 中文, 日本語)
- ⚡ **One-shot** — info and download links returned simultaneously, no step-by-step

## Quick Start

```
/chacha Interstellar
/chacha 星际穿越
/chacha 千と千尋の神隠し
/chacha Christopher Nolan
/chacha 三体
```

## How It Works

1. Parses your query to determine media type (movie/TV/book) or creator mode
2. Searches across the web for ratings and metadata in parallel
3. Scrapes SeedHub, YTS, 1337x, Quark, and other sources for download links
4. Returns a structured table with copyable magnet links and cloud drive URLs

## Output Format

All results include:
- **Compact info header** — title, year, director/author, ratings (1-2 lines)
- **Download resource table** — type, quality, size, copyable links, extraction codes
- **Quick actions** — copy to clipboard, open in browser, open magnet, download directly

## Requirements

- [Claude Code](https://claude.ai/code) (the skill runs as a Claude Code skill)
- No additional dependencies — uses WebSearch + bash scraping scripts

## Disclaimer

Download resources are provided for **personal study/research only**. All copyrights belong to the original creators. Please support official releases.

## License

MIT

## Related

- [中文文档 (Chinese README)](./README_cn.md)
- Remote repository: [github.com/brickhu/chacha](https://github.com/brickhu/chacha)
