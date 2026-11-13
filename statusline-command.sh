#!/usr/bin/env bash

input=$(cat)

# Model display name
model=$(echo "$input" | jq -r '.model.display_name // empty')

# Context window usage
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Rate limits
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# Build progress bar (10 chars wide)
build_bar() {
  local pct="$1"
  local width=10
  local filled=$(echo "$pct $width" | awk '{printf "%d", int($1 / 100 * $2 + 0.5)}')
  local empty=$(( width - filled ))
  local bar=""
  local i
  for (( i=0; i<filled; i++ )); do bar="${bar}#"; done
  for (( i=0; i<empty; i++ )); do bar="${bar}-"; done
  echo "$bar"
}

parts=()

# Model
[ -n "$model" ] && parts+=("$(printf '\033[0;36m%s\033[0m' "$model")")

# Context bar
if [ -n "$used_pct" ]; then
  bar=$(build_bar "$(printf '%.0f' "$used_pct")")
  pct_label=$(printf '%.0f' "$used_pct")
  parts+=("$(printf 'ctx \033[0;33m[%s]\033[0m %s%%' "$bar" "$pct_label")")
fi

# 5-hour rate limit
if [ -n "$five_pct" ]; then
  pct_label=$(printf '%.0f' "$five_pct")
  parts+=("$(printf '5h: %s%%' "$pct_label")")
fi

# 7-day rate limit
if [ -n "$week_pct" ]; then
  pct_label=$(printf '%.0f' "$week_pct")
  parts+=("$(printf '7d: %s%%' "$pct_label")")
fi

# Join parts with separator
output=""
for part in "${parts[@]}"; do
  if [ -z "$output" ]; then
    output="$part"
  else
    output="$output  |  $part"
  fi
done

printf '%b\n' "$output"
