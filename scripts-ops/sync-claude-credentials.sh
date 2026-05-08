#!/bin/bash
# keychain의 Claude OAuth 토큰을 ~/.claude/.credentials.json로 동기화
# CloudCLI(SDK)가 file 기반 auth만 읽기 때문에 필요
set -e
LOG=~/agents/cobot/projects/cloudcli/logs/credentials-sync.log
mkdir -p "$(dirname "$LOG")"
ts() { date '+%Y-%m-%d %H:%M:%S'; }

if NEW=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null); then
  if ! [ -f ~/.claude/.credentials.json ] || ! diff -q <(echo "$NEW") ~/.claude/.credentials.json >/dev/null 2>&1; then
    umask 077
    echo "$NEW" > ~/.claude/.credentials.json
    chmod 600 ~/.claude/.credentials.json
    EXP=$(echo "$NEW" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('claudeAiOauth',{}).get('expiresAt',0))")
    echo "$(ts) UPDATED, expiresAt=$EXP" >> "$LOG"
  else
    echo "$(ts) noop (same)" >> "$LOG"
  fi
else
  echo "$(ts) ERROR: keychain item not found" >> "$LOG"
  exit 1
fi
