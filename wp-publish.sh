#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
#  GO Journal — WordPress Publisher
#  Used by Claude Code to push posts to gymnasticsonline.com
#
#  Requires environment variables (set once in ~/.zshrc):
#    export GO_WP_URL="https://gymnasticsonline.com"
#    export GO_WP_USER="kym"
#    export GO_WP_PASS="xxxx xxxx xxxx xxxx xxxx xxxx"
#
#  Usage:
#    bash wp-publish.sh [options]
#
#  Options:
#    --title        "Article title"            (required)
#    --content-file path/to/content.html       (required)
#    --category     category-id                (required, integer)
#    --tags         "tag1,tag2,tag3"           (optional)
#    --image        hero-image.jpg             (optional, file in current dir)
#    --excerpt      "Short excerpt text"       (optional)
#    --status       draft|publish              (default: draft)
#    --post-id      123                        (optional, for updating existing post)
#    --slug         "url-slug"                 (optional, auto-generated if omitted)
# ─────────────────────────────────────────────────────────────
set -euo pipefail

# ── Defaults ─────────────────────────────────────
TITLE=""
CONTENT_FILE=""
CATEGORY=""
TAGS=""
IMAGE=""
EXCERPT=""
STATUS="draft"
POST_ID=""
SLUG=""

# ── Parse arguments ───────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --title)        TITLE="$2";        shift 2 ;;
    --content-file) CONTENT_FILE="$2"; shift 2 ;;
    --category)     CATEGORY="$2";    shift 2 ;;
    --tags)         TAGS="$2";        shift 2 ;;
    --image)        IMAGE="$2";       shift 2 ;;
    --excerpt)      EXCERPT="$2";     shift 2 ;;
    --status)       STATUS="$2";      shift 2 ;;
    --post-id)      POST_ID="$2";     shift 2 ;;
    --slug)         SLUG="$2";        shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

# ── Validate credentials ──────────────────────────
if [[ -z "${GO_WP_URL:-}" || -z "${GO_WP_USER:-}" || -z "${GO_WP_PASS:-}" ]]; then
  echo ""
  echo "❌  Missing WordPress credentials."
  echo ""
  echo "Add these to your ~/.zshrc (then run: source ~/.zshrc):"
  echo ""
  echo '  export GO_WP_URL="https://gymnasticsonline.com"'
  echo '  export GO_WP_USER="kym"'
  echo '  export GO_WP_PASS="your-application-password"'
  echo ""
  exit 1
fi

# ── Validate required args ────────────────────────
if [[ -z "$TITLE" ]]; then
  echo "❌  --title is required"; exit 1
fi
if [[ -z "$CONTENT_FILE" || ! -f "$CONTENT_FILE" ]]; then
  echo "❌  --content-file must be a valid file path"; exit 1
fi

WP_API="$GO_WP_URL/wp-json/wp/v2"
AUTH_HEADER="Authorization: Basic $(echo -n "$GO_WP_USER:$GO_WP_PASS" | base64)"

echo ""
echo "── GO Journal Publisher ──────────────────────"
echo "  Title:   $TITLE"
echo "  Status:  $STATUS"
[[ -n "$POST_ID" ]] && echo "  Mode:    UPDATE (post #$POST_ID)" || echo "  Mode:    CREATE"
echo ""

# ── Step 1: Upload hero image (if provided) ───────
MEDIA_ID=""
if [[ -n "$IMAGE" ]]; then
  if [[ ! -f "$IMAGE" ]]; then
    echo "⚠️   Image file not found: $IMAGE — skipping image upload"
  else
    echo "⏳  Uploading image: $IMAGE"
    MIME_TYPE=$(file --mime-type -b "$IMAGE" 2>/dev/null || echo "image/jpeg")
    UPLOAD_RESPONSE=$(curl -s -X POST \
      "$WP_API/media" \
      -H "$AUTH_HEADER" \
      -H "Content-Disposition: attachment; filename=\"$(basename "$IMAGE")\"" \
      -H "Content-Type: $MIME_TYPE" \
      --data-binary "@$IMAGE")

    MEDIA_ID=$(echo "$UPLOAD_RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('id',''))" 2>/dev/null || true)
    if [[ -z "$MEDIA_ID" ]]; then
      echo "⚠️   Image upload failed — post will be created without hero image"
      echo "    Response: $UPLOAD_RESPONSE" | head -c 300
    else
      echo "✅  Image uploaded (media ID: $MEDIA_ID)"
    fi
  fi
fi

# ── Step 2: Resolve tags ──────────────────────────
TAG_IDS="[]"
if [[ -n "$TAGS" ]]; then
  echo "⏳  Resolving tags..."
  TAG_IDS=$(python3 - "$TAGS" "$WP_API" "$AUTH_HEADER" <<'PYEOF'
import sys, json, urllib.request, urllib.parse

tags_str = sys.argv[1]
api_base = sys.argv[2]
auth     = sys.argv[3]

tag_names = [t.strip() for t in tags_str.split(',') if t.strip()]
ids = []

for name in tag_names:
    # Search for existing tag
    search_url = f"{api_base}/tags?search={urllib.parse.quote(name)}&per_page=5"
    req = urllib.request.Request(search_url, headers={"Authorization": auth})
    with urllib.request.urlopen(req) as r:
        existing = json.load(r)

    match = next((t for t in existing if t['name'].lower() == name.lower()), None)
    if match:
        ids.append(match['id'])
    else:
        # Create new tag
        data = json.dumps({"name": name}).encode()
        req = urllib.request.Request(
            f"{api_base}/tags",
            data=data,
            headers={"Authorization": auth, "Content-Type": "application/json"},
            method="POST"
        )
        with urllib.request.urlopen(req) as r:
            created = json.load(r)
        ids.append(created['id'])

print(json.dumps(ids))
PYEOF
)
  echo "✅  Tags resolved: $TAGS"
fi

# ── Step 3: Read content ──────────────────────────
CONTENT=$(cat "$CONTENT_FILE")

# ── Step 4: Build JSON payload ────────────────────
PAYLOAD=$(python3 - "$TITLE" "$SLUG" "$EXCERPT" "$STATUS" "$CATEGORY" "$MEDIA_ID" "$TAG_IDS" <<PYEOF
import sys, json

title    = sys.argv[1]
slug     = sys.argv[2]
excerpt  = sys.argv[3]
status   = sys.argv[4]
category = sys.argv[5]
media_id = sys.argv[6]
tag_ids  = json.loads(sys.argv[7])

payload = {
    "title":   title,
    "content": open("$CONTENT_FILE").read(),
    "status":  status,
    "tags":    tag_ids,
}
if slug:      payload["slug"]           = slug
if excerpt:   payload["excerpt"]        = excerpt
if category:  payload["categories"]     = [int(category)]
if media_id:  payload["featured_media"] = int(media_id)

print(json.dumps(payload))
PYEOF
)

# ── Step 5: Create or update post ────────────────
echo "⏳  $([ -n "$POST_ID" ] && echo 'Updating' || echo 'Creating') post..."

if [[ -n "$POST_ID" ]]; then
  ENDPOINT="$WP_API/posts/$POST_ID"
else
  ENDPOINT="$WP_API/posts"
fi

RESPONSE=$(curl -s -X POST \
  "$ENDPOINT" \
  -H "$AUTH_HEADER" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD")

# ── Step 6: Parse response ────────────────────────
python3 - "$RESPONSE" "$STATUS" <<'PYEOF'
import sys, json

raw    = sys.argv[1]
status = sys.argv[2]

try:
    data = json.loads(raw)
except json.JSONDecodeError:
    print(f"\n❌  Unexpected response:\n{raw[:400]}")
    sys.exit(1)

if "code" in data and data.get("code") != 0:
    print(f"\n❌  WordPress error: {data.get('message', 'Unknown error')}")
    sys.exit(1)

post_id   = data.get("id", "?")
post_link = data.get("link", "")
post_slug = data.get("slug", "")

print("")
if status == "publish":
    print(f"✅  Published!")
else:
    print(f"✅  Draft saved!")

print(f"")
print(f"   Post ID:   {post_id}")
print(f"   Slug:      {post_slug}")
print(f"   Link:      {post_link}")
print(f"")
print(f"   Preview:   {post_link}?preview=true")
print(f"   WP Edit:   https://gymnasticsonline.com/wp-admin/post.php?post={post_id}&action=edit")
print(f"")
PYEOF
