#!/usr/bin/env bash
# Sotto — set the live domain and contact address across the whole site.
#
#   ./scripts/configure.sh --domain sotto.com --email hello@sotto.com
#
# Rewrites canonicals, Open Graph URLs, JSON-LD, robots.txt, sitemap.xml and every
# mailto link. Safe to run more than once. Run it, check `git diff`, then commit.

set -euo pipefail
cd "$(dirname "$0")/.."

OLD_DOMAIN="sotto.services"
OLD_EMAIL="hello@sotto.example"
NEW_DOMAIN=""
NEW_EMAIL=""

while [ $# -gt 0 ]; do
  case "$1" in
    --domain) NEW_DOMAIN="${2:-}"; shift 2 ;;
    --email)  NEW_EMAIL="${2:-}";  shift 2 ;;
    -h|--help) sed -n '2,10p' "$0"; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

if [ -z "$NEW_DOMAIN" ] && [ -z "$NEW_EMAIL" ]; then
  echo "Nothing to do. Pass --domain and/or --email. See --help." >&2
  exit 1
fi

# Accept sotto.com or https://sotto.com/ and normalise to the bare host.
if [ -n "$NEW_DOMAIN" ]; then
  NEW_DOMAIN="${NEW_DOMAIN#https://}"
  NEW_DOMAIN="${NEW_DOMAIN#http://}"
  NEW_DOMAIN="${NEW_DOMAIN%/}"
fi

FILES=(index.html legal/index.html privacy/index.html robots.txt sitemap.xml README.md)

# Values go through the environment, never through the Perl source text: an address
# like hello@sotto.example would otherwise be read as an array interpolation and
# silently vanish from the pattern, even inside \Q...\E.
for f in "${FILES[@]}"; do
  [ -f "$f" ] || continue
  if [ -n "$NEW_DOMAIN" ]; then
    OLD_V="$OLD_DOMAIN" NEW_V="$NEW_DOMAIN" \
      perl -pi -e 's/\Q$ENV{OLD_V}\E/$ENV{NEW_V}/g' "$f"
  fi
  if [ -n "$NEW_EMAIL" ]; then
    OLD_V="$OLD_EMAIL" NEW_V="$NEW_EMAIL" \
      perl -pi -e 's/\Q$ENV{OLD_V}\E/$ENV{NEW_V}/g' "$f"
  fi
done

# Keep the sitemap's lastmod honest.
if [ -n "$NEW_DOMAIN" ] || [ -n "$NEW_EMAIL" ]; then
  perl -pi -e "s{<lastmod>[^<]*</lastmod>}{<lastmod>$(date +%F)</lastmod>}" sitemap.xml
fi

echo "Done."
[ -n "$NEW_DOMAIN" ] && echo "  domain -> https://$NEW_DOMAIN"
[ -n "$NEW_EMAIL" ]  && echo "  email  -> $NEW_EMAIL"
echo
echo "Now check: git diff"
if grep -rq 'class="todo"' --include='*.html' .; then
  echo "Remaining placeholders:"
  grep -rn 'class="todo"' --include='*.html' . | sed 's/^/  /'
else
  echo "No marked placeholders left."
fi
