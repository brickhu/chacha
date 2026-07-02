#!/usr/bin/env bash
# chacha/search.sh — Direct resource search via curl scraping
# Usage: ./search.sh <site> <query>
# Sites: seedhub | yts | 1337x | quark | cilixiong | bt4g | bitsearch | nyaa
#
# Domain resolution (priority order):
#   1. /tmp/chacha-domains-cache.json — AI 通过 WebSearch 发现的域名
#   2. scripts/domains.json — 硬编码默认域名
#   全部失败 → 输出 SITE_DEAD:<site>，AI 会自动 WebSearch 找新域名

set -euo pipefail

SITE="${1:-}"
QUERY="${2:-}"
UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36"

die() { echo "ERROR: $*" >&2; exit 1; }
[ -z "$SITE" ] && die "Usage: search.sh <seedhub|yts|1337x|quark|cilixiong|bt4g|bitsearch|nyaa> <query>"

urlencode() {
  echo "$1" | sed 's/ /%20/g;s/:/%3A/g;s/\//%2F/g;s/?/%3F/g;s/&/%26/g;s/=/%3D/g'
}

ENCODED=$(urlencode "$QUERY")

# ─── Domain resolution ──────────────────────────────────────────────────

DOMAINS_FILE="$(dirname "$0")/domains.json"
DOMAINS_CACHE="/tmp/chacha-domains-cache.json"
CUSTOM_SOURCES="$HOME/.config/chacha/sources.json"

# Returns domain per line: 自愈缓存 → 用户自定义源 → 硬编码默认源
_resolve_domains() {
  local site="$1"
  python3 -c "
import json, os, sys

cache_file = '$DOMAINS_CACHE'
defaults_file = '$DOMAINS_FILE'
custom_file = '$CUSTOM_SOURCES'
site_key = '$site'
output = []

# 1) Self-healing cache (AI-discovered domains)
if os.path.exists(cache_file):
    try:
        with open(cache_file) as f:
            cache = json.load(f)
        entry = cache.get(site_key, {})
        d = entry.get('domain', '')
        if d and d not in output:
            output.append(d)
    except: pass

# 2) User custom sources (~/.config/chacha/sources.json)
#    Survives skill updates — user can add/modify sources via natural language
if os.path.exists(custom_file):
    try:
        with open(custom_file) as f:
            custom = json.load(f)
    except: pass
    src = custom.get(site_key, {})
    d = src.get('domain', '')
    if d and d not in output:
        output.append(d)
    for m in src.get('mirrors', []):
        if m and m not in output:
            output.append(m)

# 3) Defaults (shipped domains.json)
try:
    with open(defaults_file) as f:
        defaults = json.load(f)
    src = defaults.get('sources', {}).get(site_key, {})
    d = src.get('domain', '')
    if d and d not in output:
        output.append(d)
    for m in src.get('mirrors', []):
        if m and m not in output:
            output.append(m)
except: pass

for d in output:
    print(d)
" 2>/dev/null || true
}

# ─── Helper: try URL, pipe through parser ───────────────────────────────

# Usage: try_domains <site> <path_template> <curl_args...> -- <parser_cmd>
#   按 _resolve_domains 返回的域名列表逐个尝试，第一个有返回就停
#   全部失败 → exit code 2
try_domains() {
  local site="$1"; shift
  local path_tpl="$1"; shift
  local -a curl_args=()
  local parser=()
  local sep_found=0
  for arg in "$@"; do
    if [ "$arg" = "--" ]; then
      sep_found=1
    elif [ "$sep_found" -eq 0 ]; then
      curl_args+=("$arg")
    else
      parser+=("$arg")
    fi
  done

  local domains
  domains=$(_resolve_domains "$site")

  while IFS= read -r domain; do
    [ -z "$domain" ] && continue
    local url="https://${domain}${path_tpl/\{query\}/$ENCODED}"
    local result
    result=$(curl -sL --max-time 10 "${curl_args[@]}" "$url" 2>/dev/null | "${parser[@]}" 2>/dev/null || true)
    if [ -n "$result" ]; then
      echo "$result"
      return 0
    fi
  done <<< "$domains"

  # 全部域名尝试失败 — 通知 AI 去发现新域名
  echo "SITE_DEAD:${site}"
  return 2
}

# ─── Site-specific parsers (each accepts stdin, returns results) ─────────

parse_seedhub() {
  perl -nle 'print $1 while m{(magnet:\?xt=urn:btih:[a-zA-Z0-9]+)}g' | sort -u | head -10
}

parse_yts() {
  python3 -c "
import json, sys
data = json.load(sys.stdin)
for m in data.get('data',{}).get('movies',[]):
    for t in m.get('torrents',[]):
        print(f\"{t['quality']} | {t['size']} | {t['url']} | seeds:{t['seeds']}\")
" 2>/dev/null || true
}

parse_1337x() {
  perl -nle 'print $1 while m{(/torrent/\d+/[^"]+)}g' | sort -u
}

parse_cilixiong() {
  perl -nle 'print $1 while m{href=\"(magnet:\?xt=urn:btih:[^"]+)\"}' | head -10
}

parse_quark() {
  perl -nle 'print $1 while m{(https?://pan\.quark\.cn/s/[a-zA-Z0-9]+)}g' | sort -u | head -10
}

parse_bt4g() {
  python3 -c "
import re, sys, html
text = sys.stdin.read()
magnets = re.findall(r'(magnet:\?xt=urn:btih:[a-fA-F0-9]+)', text)
entries = re.findall(
    r'<a[^>]*href=\"/torrent/([a-fA-F0-9]+)\"[^>]*>([^<]+)</a>.*?'
    r'seeds[^:]*:\s*(\d+).*?'
    r'size[^:]*:\s*([^<]+)',
    text, re.DOTALL
)
if magnets:
    for m in magnets[:15]:
        print(m)
elif entries:
    for h, name, seeds, size in entries[:10]:
        print(f\"magnet:?xt=urn:btih:{h} | {html.unescape(name.strip())} | seeds:{seeds} | {size.strip()}\")
else:
    hashes = re.findall(r'[a-fA-F0-9]{40}', text)
    for h in hashes[:10]:
        print(f\"magnet:?xt=urn:btih:{h}\")
" 2>/dev/null || true
}

parse_bitsearch() {
  python3 -c "
import json, sys
data = json.load(sys.stdin)
results = data.get('data', {}).get('results', []) if isinstance(data.get('data'), dict) else []
for r in results[:15]:
    magnet = r.get('magnet', '')
    name = r.get('name', '')
    seeds = r.get('seeds', 0)
    size = r.get('size', '')
    if magnet:
        print(f\"{magnet} | {name} | seeds:{seeds} | {size}\")
" 2>/dev/null || true
}

parse_nyaa() {
  python3 -c "
import re, sys
text = sys.stdin.read()
rows = re.findall(
    r'<tr[^>]*>.*?href=\"(magnet:\?xt=urn:btih:[^\"]+)\".*?'
    r'<td[^>]*class=\"[^\"]*text-center[^\"]*\"[^>]*>(\d+)</td>.*?'
    r'<td[^>]*class=\"[^\"]*text-center[^\"]*\"[^>]*>(\d+)</td>.*?</tr>',
    text, re.DOTALL
)
for magnet, seeds, leechers in rows[:15]:
    print(f\"{magnet} | seeds:{seeds} | leechers:{leechers}\")
if not rows:
    magnets = re.findall(r'(magnet:\?xt=urn:btih:[a-fA-F0-9]+)', text)
    for m in magnets[:15]:
        print(m)
" 2>/dev/null || true
}

# ─── Site dispatch ──────────────────────────────────────────────────────

COMMON_HEADERS=(-H "User-Agent: $UA" -H "Accept-Language: zh-CN,zh;q=0.9")
JSON_HEADERS=(-H "User-Agent: $UA" -H "Accept: application/json")

case "$SITE" in

seedhub)
  try_domains seedhub "/search?q={query}" \
    "${COMMON_HEADERS[@]}" -- parse_seedhub
  ;;

yts)
  try_domains yts "/api/v2/list_movies.json?query_term={query}&limit=10" \
    "${COMMON_HEADERS[@]}" -- parse_yts
  ;;

1337x)
  try_domains 1337x "/search/{query}/1/" \
    "${COMMON_HEADERS[@]}" -- parse_1337x
  ;;

cilixiong)
  local domains
  domains=$(_resolve_domains cilixiong)
  local found=0
  while IFS= read -r domain; do
    [ -z "$domain" ] && continue
    local search_url="https://${domain}/search?q=${ENCODED}"
    local search_html
    search_html=$(curl -sL --max-time 10 "${COMMON_HEADERS[@]}" "$search_url" 2>/dev/null || true)
    if [ -z "$search_html" ] || echo "$search_html" | grep -qi "cloudflare\|cf-browser-verify\|Just a moment"; then
      continue
    fi
    echo "$search_html" | perl -nle 'print $1 while m{href="(/movie/[^"]+\.html)"}g' | \
      sed "s|^|https://${domain}|" | sort -u | head -5 | \
      while read -r detail_url; do
        curl -sL --max-time 10 "${COMMON_HEADERS[@]}" "$detail_url" 2>/dev/null | parse_cilixiong
      done
    found=1
    break
  done <<< "$domains"
  [ "$found" -eq 0 ] && echo "SITE_DEAD:cilixiong"
  ;;

quark)
  try_domains quark "/search?keyword={query}" \
    "${COMMON_HEADERS[@]}" -- parse_quark
  ;;

bt4g)
  try_domains bt4g "/search?q={query}" \
    --max-time 15 "${COMMON_HEADERS[@]}" -H "Accept: text/html,application/xhtml+xml" -- parse_bt4g
  ;;

bitsearch)
  try_domains bitsearch "/api/search?q={query}" \
    --max-time 10 "${JSON_HEADERS[@]}" -- parse_bitsearch
  ;;

nyaa)
  try_domains nyaa "/?q={query}&s=seeders&o=desc" \
    --max-time 10 "${COMMON_HEADERS[@]}" -- parse_nyaa
  ;;

*)
  die "Unknown site: $SITE. Valid: seedhub | yts | 1337x | quark | cilixiong | bt4g | bitsearch | nyaa"
  ;;

esac
