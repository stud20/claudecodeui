#!/usr/bin/env bash
#
# bulk-register-projects.sh
#
# cobot/projects/ 아래 30개 프로젝트를 cloudcli 사이드바에 일괄 등록한다.
# - displayName 에 카테고리 접두사([영상], [에셋] 등)를 붙여 사이드바를 정렬한다.
# - 이미 등록된 프로젝트(409 active_conflict)는 건너뛴다.
# - 인증은 JWT(localStorage 'auth-token')를 환경변수로 받는다.
#
# 사용법:
#   1) 브라우저에서 cloudcli 접속 → DevTools → Application → Local Storage
#      → 'auth-token' 값 복사
#   2) export CLOUDCLI_TOKEN='eyJhbGciOi...'
#   3) ./scripts-ops/bulk-register-projects.sh
#
# 옵션:
#   BASE_URL        기본 http://127.0.0.1:3009
#   PROJECTS_ROOT   기본 /Users/ysk/agents/cobot/projects
#   DRY_RUN=1       실제 호출 없이 어떤 프로젝트가 등록될지만 출력

set -euo pipefail

BASE_URL="${BASE_URL:-http://127.0.0.1:3009}"
PROJECTS_ROOT="${PROJECTS_ROOT:-/Users/ysk/agents/cobot/projects}"
DRY_RUN="${DRY_RUN:-0}"

if [[ -z "${CLOUDCLI_TOKEN:-}" && "${DRY_RUN}" != "1" ]]; then
  echo "ERROR: CLOUDCLI_TOKEN 환경변수가 비어 있습니다." >&2
  echo "       브라우저 cloudcli → DevTools → Local Storage → 'auth-token' 복사 후" >&2
  echo "       export CLOUDCLI_TOKEN='...' 로 지정하세요." >&2
  exit 1
fi

# name | category | displayName
# 표시명은 "[카테고리] 폴더명" 패턴.
PROJECTS=(
  "project-archiver|영상|[영상] project-archiver"
  "sense-of-cut|영상|[영상] sense-of-cut"
  "video-thumbnailer|영상|[영상] video-thumbnailer"
  "video-processor-finder|영상|[영상] video-processor-finder"
  "video-processor-eagle-plugin|영상|[영상] video-processor-eagle-plugin"
  "video-reference-project|영상|[영상] video-reference-project"
  "FCPworkflow|영상|[영상] FCPworkflow"
  "resolve-bar|영상|[영상] resolve-bar"

  "reference-collector|에셋|[에셋] reference-collector"
  "asset-tagger|에셋|[에셋] asset-tagger"
  "eagle-toolkit|에셋|[에셋] eagle-toolkit"
  "gen-board|에셋|[에셋] gen-board"
  "portfolio-writer|에셋|[에셋] portfolio-writer"
  "portfolio-parser|에셋|[에셋] portfolio-parser"
  "obsidian-vault|에셋|[에셋] obsidian-vault"

  "neuo-desktop|NEUO|[NEUO] neuo-desktop"
  "neuo-platform|NEUO|[NEUO] neuo-platform"

  "comfyui-mcp-server|MCP|[MCP] comfyui-mcp-server"
  "memory-journal-mcp-server|MCP|[MCP] memory-journal-mcp-server"

  "cloudcli|인프라|[인프라] cloudcli"
  "ecc-skills|인프라|[인프라] ecc-skills"

  "stud-coin|코인|[코인] stud-coin"

  "stud-hq|개인|[개인] stud-hq"
  "stud20|개인|[개인] stud20"
  "stud20-remix|개인|[개인] stud20-remix"
  "quest-09-watch|개인|[개인] quest-09-watch"
  "quest-09-relay|개인|[개인] quest-09-relay"
  "hwp-converter|개인|[개인] hwp-converter"
)

ok=0
skip=0
fail=0
missing=0

for entry in "${PROJECTS[@]}"; do
  IFS='|' read -r name category displayName <<<"$entry"
  path="$PROJECTS_ROOT/$name"

  if [[ ! -d "$path" ]]; then
    echo "  [missing] $name (경로 없음: $path)"
    missing=$((missing + 1))
    continue
  fi

  if [[ "$DRY_RUN" == "1" ]]; then
    printf "  [dry-run] %-50s -> %s\n" "$path" "$displayName"
    continue
  fi

  payload=$(cat <<JSON
{"path": "$path", "customName": "$displayName"}
JSON
)

  http_code=$(curl -sS -o /tmp/cloudcli_register_resp.json -w "%{http_code}" \
    -X POST "$BASE_URL/api/projects/create-project" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $CLOUDCLI_TOKEN" \
    -d "$payload" || echo "000")

  case "$http_code" in
    200|201)
      printf "  [  ok  ] %s\n" "$displayName"
      ok=$((ok + 1))
      ;;
    409)
      printf "  [ skip ] %s (이미 등록됨)\n" "$displayName"
      skip=$((skip + 1))
      ;;
    *)
      body=$(cat /tmp/cloudcli_register_resp.json 2>/dev/null || echo "")
      printf "  [ FAIL ] %s (HTTP %s) %s\n" "$displayName" "$http_code" "$body"
      fail=$((fail + 1))
      ;;
  esac
done

echo
echo "결과: ok=$ok skip=$skip fail=$fail missing=$missing"

if [[ "$fail" -gt 0 ]]; then
  exit 1
fi
