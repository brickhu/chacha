# Output Templates

## Core Rule

Info is compact and front-loaded. Download links are the main content. Basic info + ratings take 1-2 lines. Download resources take 80%+ of the output. Links must be directly copyable — full magnet strings, cloud links with extraction codes.

---

## Movie Output Template

```markdown
# 🎬 {Title} ({Original Title}) · {year} · {director} · {runtime}
> IMDb **{rating}** · Douban **{rating}** · Rotten Tomatoes **{score}%** · {genres}
>
> {One-line plot summary, max two lines}

## 🔗 Download Resources

> ⚠️ For personal study/research only. Copyright belongs to the original creators.

### 🔗 Download Resources

| # | Type | Quality | Size | Link | Code |
|---|------|---------|------|------|------|
| 1 | 🧲 Magnet | 4K HDR | 22GB | `magnet:?xt=urn:btih:...` 🔗 | — |
| 2 | 🧲 Magnet | 1080p | 8GB | `magnet:?xt=urn:btih:...` 🔗 | — |
| 3 | ☁️ Quark | 4K REMUX | 80GB | `https://pan.quark.cn/s/xxxx` 🔗 | `xxxx` |
| 4 | ☁️ Baidu | 1080p | 7GB | `https://pan.baidu.com/s/xxxx` 🔗 | `xxxx` |

💡 For archiving: REMUX/BluRay. For daily watching: 1080p ~8GB is enough.
```

**Key requirements:**
- Single unified table. **Type** column distinguishes: 🧲 Magnet / ☁️ Quark / ☁️ Baidu / ☁️ Ali
- **Link** column shows the URL followed by 🔗. User just says the row number ("1") → you execute `echo "<link>" | pbcopy` immediately. No "copy" prefix needed
- Cloud drive links use full `https://` URLs. Magnet links use full `magnet:?xt=urn:btih:` URIs
- Sort: magnet first (by quality), then cloud drives. Never fabricate links

---

## TV Show Output Template

```markdown
# 📺 {Title} ({Original Title}) · {year} · {seasons} seasons · {status}
> IMDb **{rating}** · Douban **{rating}** · {creator} · {network}
>
> {One-line plot summary}

## 🔗 Download Resources

| # | Type | Scope | Quality | Size | Link | Code |
|---|------|------|------|------|------|------|
| 1 | 🧲 Magnet | S01-S{N} Complete | 1080p | 42GB | `magnet:?xt=urn:btih:...` 🔗 | — |
| 2 | ☁️ Quark | Complete | 1080p | 42GB | `https://pan.quark.cn/s/xxxx` 🔗 | `xxxx` |

 ⚠️ For personal study/research only.
```

---

## Book Output Template

```markdown
# 📚 {Title} ({Original Title}) · {author} · {year} · {publisher}
> Goodreads **{rating}** · Douban **{rating}** · ISBN: {ISBN}
>
> {One-line summary}

## 🔗 Download Resources

> ⚠️ For personal study/research only.

| # | Type | Format | Size | Link | Code |
|---|------|------|------|------|------|
| 1 | ☁️ Quark | EPUB | 2MB | `https://pan.quark.cn/s/xxxx` 🔗 | `xxxx` |
| 2 | ☁️ Baidu | PDF | 5MB | `https://pan.baidu.com/s/xxxx` 🔗 | `xxxx` |
```

---

## Creator / Director Works List Template

```markdown
# 🎬 {Creator Name} ({Alternate Name}) · Notable Works

> {One-line bio: nationality / era / style tags}

| # | Title | Year | Rating (Douban) | Rating (IMDb) | Genre |
|---|-------|------|-----------------|---------------|-------|
| 1 | **{title}** | {year} | {rating} | {rating} | {genres} |
| 2 | **{title}** | {year} | {rating} | {rating} | {genres} |
| ... | ... | ... | ... | ... | ... |

---
Type **/chacha {title}** to search download resources for a specific work
```

---

## Discovery List Template (hot / new / top)

Display 50 items in a compact ranked table.

```markdown
# {🔥 hot / 🆕 new / 🏆 top} {Movies / TV Shows / Books} · {year}

> {One-line description of the ranking source}

| # | Title | Year | Rating (Douban) | Rating (IMDb) | Genre |
|---|-------|------|-----------------|---------------|-------|
| 1 | **{title}** | {year} | {rating} | {rating} | {genres} |
| 2 | **{title}** | {year} | {rating} | {rating} | {genres} |
| ... | ... | ... | ... | ... | ... |
| 50 | **{title}** | {year} | {rating} | {rating} | {genres} |

---
Type **/chacha {title}** to search download resources for a specific work
```

**Key requirements:**
- Show exactly 50 items, sorted by relevance to the command (hot=newest buzz, new=release date, top=rating)
- Title is bolded and clickable for drill-down
- Include both Douban and IMDb ratings when available
- After the list, prompt the user to type `/chacha {title}` for any work they want download links for
