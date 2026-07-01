#!/usr/bin/env bash
# chacha/search.sh — Direct resource search via curl scraping
# Usage: ./search.sh <site> <query>
# Sites: seedhub | yts | 1337x | quark | cilixiong

set -euo pipefail

SITE="${1:-}"
QUERY="${2:-}"
UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36"

die() { echo "ERROR: $*" >&2; exit 1; }
[ -z "$SITE" ] && die "Usage: search.sh <seedhub|yts|1337x|quark|cilixiong> <query>"

urlencode() {
  local str="$1"
  # Basic URL encoding for search queries
  echo "$str" | sed 's/ /%20/g;s/:/%3A/g;s/\//%2F/g;s/?/%3F/g;s/&/%26/g;s/=/%3D/g'
}

ENCODED=$(urlencode "$QUERY")

case "$SITE" in

seedhub)
  # SeedHub — search page returns HTML with magnet links
  # Pattern: magnet:?xt=urn:btih:XXXX found in <a href="magnet:...">
  URL="https://www.seedhub.cc/search?q=${ENCODED}"
  curl -sL -H "User-Agent: $UA" "$URL" 2>/dev/null | \
    grep -oP 'magnet:\?xt=urn:btih:[a-zA-Z0-9]+' | \
    sort -u | head -10
  ;;

yts)
  # YTS.mx — API-based, returns JSON
  URL="https://yts.mx/api/v2/list_movies.json?query_term=${ENCODED}&limit=10"
  curl -sL -H "User-Agent: $UA" "$URL" 2>/dev/null | \
    python3 -c "
import json, sys
data = json.load(sys.stdin)
for m in data.get('data',{}).get('movies',[]):
    for t in m.get('torrents',[]):
        print(f\"{t['quality']} | {t['size']} | {t['url']} | seeds:{t['seeds']}\")
" 2>/dev/null || echo "[]"
  ;;

1337x)
  # 1337x — search page, extract torrent page links
  URL="https://1337x.to/search/${ENCODED}/1/"
  curl -sL -H "User-Agent: $UA" "$URL" 2>/dev/null | \
    grep -oP '/torrent/\d+/[^"]+' | \
    sed 's|^|https://1337x.to|' | \
    sort -u | head -10
  ;;

cilixiong)
  # 磁力熊 — 豆瓣高分电影1080P磁力下载 (cilixiong.com)
  # Mirrors: cilixiong.com | cilixiong.net | cilixiong.cc
  # Structure: <div class="masonry"> → <a> detail links → <div class="tabs-container"> → magnet <a>
  DOMAIN="cilixiong.com"

  # Try search page first, fall back to Google site: search
  SEARCH_URL="https://${DOMAIN}/search?q=${ENCODED}"
  HTML=$(curl -sL --max-time 10 -H "User-Agent: $UA" \
    -H "Accept: text/html,application/xhtml+xml" \
    -H "Accept-Language: zh-CN,zh;q=0.9" \
    "$SEARCH_URL" 2>/dev/null || echo "")

  if [ -z "$HTML" ] || echo "$HTML" | grep -qi "cloudflare\|cf-browser-verify\|Just a moment"; then
    # Site behind Cloudflare — try mirror or output stub for WebSearch fallback
    HTML=$(curl -sL --max-time 10 -H "User-Agent: $UA" \
      -H "Accept-Language: zh-CN,zh;q=0.9" \
      "https://cilixiong.net/search?q=${ENCODED}" 2>/dev/null || echo "")
  fi

  if [ -n "$HTML" ] && ! echo "$HTML" | grep -qi "cloudflare\|cf-browser-verify\|Just a moment"; then
    # Extract detail page URLs from search results
    echo "$HTML" | grep -oP 'href="(/movie/[^"]+\.html)"' | \
      sed "s|href=\"|https://${DOMAIN}|; s|\"$||" | sort -u | head -5 | \
      while read -r detail_url; do
        detail_html=$(curl -sL --max-time 10 -H "User-Agent: $UA" \
          -H "Accept-Language: zh-CN,zh;q=0.9" "$detail_url" 2>/dev/null || echo "")
        # Extract magnet links from tabs-container
        echo "$detail_html" | grep -oP 'href="(magnet:\?xt=urn:btih:[^"]+)"' | \
          sed 's/href="//;s/"$//' | head -5
      done
  else
    # Output stub — caller should fall back to WebSearch site:cilixiong.com
    echo "CILIXIONG_CF_BLOCKED"
  fi
  ;;

quark)
  # PanSearch API — aggregate quark cloud links
  URL="https://pan.search.avxhm.com/search?keyword=${ENCODED}"
  curl -sL -H "User-Agent: $UA" "$URL" 2>/dev/null | \
    grep -oP 'https?://pan\.quark\.cn/s/[a-zA-Z0-9]+' | \
    sort -u | head -10
  ;;

*)
  die "Unknown site: $SITE. Valid: seedhub | yts | 1337x | quark | cilixiong"
  ;;

esac
