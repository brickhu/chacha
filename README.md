# chacha — AI Resource Finder

> 查查 (chá chá) means "look it up" in Chinese. Just ask — chacha finds it.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![skills.sh](https://img.shields.io/badge/skills.sh-chacha-38bdae)](https://skills.sh/brickhu/chacha)
[English](./README.md) | [中文](./README_cn.md)

chacha is an AI-powered resource discovery agent for **movies, books, and TV shows**. It aggregates ratings from multiple platforms (IMDb, Douban, Rotten Tomatoes, Goodreads) and finds download links (magnet, BT, cloud drives) — all in one shot.

## Installation

### Quick Install

For **Claude Code**, **Codex**, **Cursor**, **Windsurf**, **Cline**, and **Trae** — just one command:

```bash
npx skills add brickhu/chacha
```

Once installed, use `/chacha <query>` to start searching.

### Manual Install

For harnesses that don't support `npx skills add` (e.g. **Workbuddy**, **Aside**), download and install manually:

1. Download the latest release:
   ```bash
   curl -L -o chacha.zip https://github.com/brickhu/chacha/archive/refs/heads/master.zip
   ```

2. Upload the `chacha.zip` file in your harness client to install.

## Features

- 🎬 **Movie search** — ratings from IMDb, Douban, Rotten Tomatoes + magnet/BT/cloud links
- 📺 **TV show search** — season-by-season ratings + complete series downloads
- 📚 **Book search** — Goodreads & Douban ratings + ebook download links

## Quick Start

**Search by title:**

```
/chacha Interstellar
/chacha 星际穿越
/chacha 千と千尋の神隠し
/chacha 三体
```

**Search by creator:**

```
/chacha Christopher Nolan
/chacha 诺兰
/chacha 刘慈欣
```

**Discover trending / new / top:**

```
/chacha hot
/chacha new
/chacha top
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
