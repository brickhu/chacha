# Interaction Guide

## After Search Completes

Display results directly — compact info, download links as the main body. If a resource category has no results, note "Not found" with a brief reason.

**Then offer CLI actions** (in the user's language) so the user can act on links without leaving the terminal. **Copy commands come first — that's what users need most in a CLI:**

```
What do you want to do?
- 📋 "Copy link 1" — copy to clipboard
- 🌐 "Open in browser" — launch default browser
- 🧲 "Open magnet" — launch torrent client
- 💾 "Download directly" — curl/wget
```

## CLI Commands by Platform

| Action | macOS | Linux | Windows (Git Bash) |
|--------|-------|-------|---------------------|
| Copy to clipboard | `echo "url" \| pbcopy` | `echo "url" \| xclip -sel c` | `echo "url" \| clip` |
| Open in browser | `open "url"` | `xdg-open "url"` | `start "url"` |
| Open magnet | `open "magnet:..."` | `xdg-open "magnet:..."` | `start "magnet:..."` |
| Download file | `curl -C - -o file "url"` | `wget -c "url"` | `curl -C - -o file "url"` |

Always auto-detect the user's OS and use the correct command. Display the exact command ready to copy-paste.

## Handling Duplicate Titles

If search results are ambiguous:
- Use `AskUserQuestion` to list candidates for the user to choose from
- Show each candidate's year + type + primary creator to differentiate

## Handling Fuzzy Input (Did You Mean?)

If the input returns clearly unrelated results, or results contain a phonetically/visually similar but more well-known name:

1. **Never return a flat failure.** Analyze similar names appearing in search results
2. Use `AskUserQuestion` to show the most likely correct names (1-3 candidates):

```
No exact results for "{input}". Did you mean:

- 🎬 "{suggestion_1}" ({year}) — {brief description}
- 🎬 "{suggestion_2}" ({year}) — {brief description}
- 🔍 None of these — search for "{input}" anyway
```

3. **Common correction patterns** (apply across languages):
   - Typos: `Intersteller` → `Interstellar`
   - Homophones / similar-sounding: Chinese pinyin confusion, Japanese kanji misreading
   - Mixed script: `無間道` (traditional) → `无间道` (simplified)
   - Name approximation: similar-but-wrong actor/director names
   - Partial title: `Shawshank` → `The Shawshank Redemption`
   - Mixed input: `inception 盗梦` → `Inception` (or `盗梦空间`)

4. If the user chooses "None of these", force-search with the original input and mark results with a warning that the search term may be incorrect
