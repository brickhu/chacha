# Output Templates

## Core Rule

Info is compact and front-loaded. Download links are the main content. Basic info + ratings + cast take 3-4 lines. A one-line highlight (看点) draws the user in. Download resources take 80%+ of the output. Links must be directly copyable — full magnet strings, cloud links with extraction codes. All links must pass validity check before presentation.

---

## Movie Output Template

```markdown
# 🎬 {Title} ({Original Title}) · {year} · {director} · {runtime}
> IMDb **{rating}** · Douban **{rating}** · Rotten Tomatoes **{score}%** · {genres}
> 🎭 {Actor1} / {Actor2} / {Actor3} / {Actor4} / {Actor5}
>
> {One-line plot summary, max two lines}
>
> 🔥 **看点**：{One compelling sentence — what makes THIS movie unmissable}

## 🔗 Download Resources

> ⚠️ For personal study/research only. Copyright belongs to the original creators.

| # | Type | Quality | Size | Status | Link | Code |
|---|------|---------|------|--------|------|------|
| 1 | 🧲 Magnet | 4K HDR | 22GB | ✅ | `magnet:?xt=urn:btih:...` 🔗 | — |
| 2 | 🧲 Magnet | 1080p | 8GB | ✅ | `magnet:?xt=urn:btih:...` 🔗 | — |
| 3 | ☁️ Quark | 4K REMUX | 80GB | ✅ | `https://pan.quark.cn/s/xxxx` 🔗 | `xxxx` |
| 4 | ☁️ Baidu | 1080p | 7GB | ❌ 已失效 | — | — |

💡 For archiving: REMUX/BluRay. For daily watching: 1080p ~8GB is enough.
```

**Key requirements:**
- 🎭 **Cast line**: List 3-5 main actors, separated by ` / `. Use localized names matching the user's language
- 🔥 **看点**: One unique, compelling sentence tailored to this specific work. Never generic. Lead with director style, plot hook, or standout element
- **Status column**: ✅ 有效 / ⚠️ 疑似失效 / ❌ 已失效 — based on HEAD request or magnet format check
- Single unified table. **Type** column distinguishes: 🧲 Magnet / ☁️ Quark / ☁️ Baidu / ☁️ Ali
- **Link** column shows the URL followed by 🔗. User just says the row number ("1") → you execute `echo "<link>" | pbcopy` immediately
- Cloud drive links use full `https://` URLs. Magnet links use full `magnet:?xt=urn:btih:` URIs
- Sort: valid links first (✅), then magnet by quality, then cloud drives. Expired links (❌) at bottom
- Never fabricate links

---

## TV Show Output Template

```markdown
# 📺 {Title} ({Original Title}) · {year} · {seasons} seasons · {status}
> IMDb **{rating}** · Douban **{rating}** · {creator} · {network}
> 🎭 {Actor1} / {Actor2} / {Actor3} / {Actor4} / {Actor5}
>
> {One-line plot summary}
>
> 🔥 **看点**：{One compelling sentence — the hook that makes this series binge-worthy}

## 🔗 Download Resources

| # | Type | Scope | Quality | Size | Status | Link | Code |
|---|------|------|------|------|--------|------|------|
| 1 | 🧲 Magnet | S01-S{N} Complete | 1080p | 42GB | ✅ | `magnet:?xt=urn:btih:...` 🔗 | — |
| 2 | ☁️ Quark | Complete | 1080p | 42GB | ✅ | `https://pan.quark.cn/s/xxxx` 🔗 | `xxxx` |

 ⚠️ For personal study/research only.
```

---

## Book Output Template

```markdown
# 📚 {Title} ({Original Title}) · {author} · {year} · {publisher}
> Goodreads **{rating}** · Douban **{rating}** · ISBN: {ISBN}
>
> {One-line summary}
>
> 🔥 **看点**：{One compelling sentence — the idea, style, or insight that makes this book worth reading}

## 🔗 Download Resources

> ⚠️ For personal study/research only.

| # | Type | Format | Size | Status | Link | Code |
|---|------|------|------|--------|------|------|
| 1 | ☁️ Quark | EPUB | 2MB | ✅ | `https://pan.quark.cn/s/xxxx` 🔗 | `xxxx` |
| 2 | ☁️ Baidu | PDF | 5MB | ❌ 已失效 | — | — |
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
