#!/usr/bin/env bash

# Compact, single-line Claude Code status. Claude passes session data as JSON.
input=$(cat)

reset='\033[0m'
dim='\033[2m'
cyan='\033[36m'
yellow='\033[33m'
red='\033[31m'
green='\033[32m'
magenta='\033[35m'

field() {
	jq -r "$1 // empty" <<<"$input"
}

color_for_percentage() {
	local percentage=$1
	if [ "$percentage" -ge 80 ]; then
		printf '%s' "$red"
	elif [ "$percentage" -ge 60 ]; then
		printf '%s' "$yellow"
	else
		printf '%s' "$green"
	fi
}

format_time_left() {
	local resets_at=$1 remaining days hours minutes
	[ -n "$resets_at" ] || return
	remaining=$((resets_at - $(date +%s)))
	[ "$remaining" -gt 0 ] || {
		printf 'now'
		return
	}

	days=$((remaining / 86400))
	hours=$(((remaining % 86400) / 3600))
	minutes=$(((remaining % 3600) / 60))
	if [ "$days" -gt 0 ]; then
		printf '%sd' "$days"
	elif [ "$hours" -gt 0 ]; then
		printf '%sh' "$hours"
	else
		printf '%sm' "$minutes"
	fi
}

print_percentage() {
	local label=$1 value=$2 resets_at=$3 rounded color prefix time_left
	if [ -z "$value" ]; then
		printf '%b%s --%b' "$dim" "$label" "$reset"
		return
	fi

	rounded=$(printf '%.0f' "$value")
	color=$(color_for_percentage "$rounded")
	[ "$rounded" -ge 80 ] && prefix="! " || prefix=""
	printf '%b%s%s %s%%%b' "$color" "$prefix" "$label" "$rounded" "$reset"
	time_left=$(format_time_left "$resets_at")
	[ -n "$time_left" ] && printf ' (%s left)' "$time_left"
}

cwd=$(field '.workspace.current_dir // .cwd')
if [ "$cwd" = "/" ]; then
	project="/"
else
	trimmed_cwd=${cwd%/}
	project=${trimmed_cwd##*/}
fi

model=$(field '.model.display_name // .model.id')
model=${model%% (*}
effort=$(field '.effort.level')
fast_mode=$(field '.fast_mode')

branch=$(field '.worktree.branch // .workspace.git_worktree')
git_detail=""
if [ -n "$cwd" ] && git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
	[ -n "$branch" ] || branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
	git_status=$(git -C "$cwd" status --porcelain --untracked-files=normal 2>/dev/null)
	if [ -n "$git_status" ]; then
		changed_files=$(printf '%s\n' "$git_status" | wc -l | tr -d ' ')
		read -r additions deletions <<<"$(
			git -C "$cwd" diff --numstat HEAD -- 2>/dev/null |
				awk '{ if ($1 ~ /^[0-9]+$/) added += $1; if ($2 ~ /^[0-9]+$/) removed += $2 } END { printf "%d %d", added, removed }'
		)"
		git_detail="* Δ${changed_files} +${additions} −${deletions}"
	fi
fi

context=$(field '.context_window.used_percentage')
five_hour=$(field '.rate_limits.five_hour.used_percentage')
five_hour_reset=$(field '.rate_limits.five_hour.resets_at')
seven_day=$(field '.rate_limits.seven_day.used_percentage')
seven_day_reset=$(field '.rate_limits.seven_day.resets_at')

printf '%b%s%b' "$cyan" "$project" "$reset"
printf ' · %b%s%b' "$magenta" "${model:-Claude}" "$reset"
[ -n "$effort" ] && printf ' %b%s%b' "$magenta" "$effort" "$reset"
[ "$fast_mode" = "true" ] && printf ' %bfast%b' "$yellow" "$reset"
if [ -n "$branch" ]; then
	printf ' · %b%s%s%b' "$yellow" "$branch" "$git_detail" "$reset"
fi
printf ' · '
print_percentage ctx "$context" ""
printf ' · '
print_percentage 5h "$five_hour" "$five_hour_reset"
printf ' · '
print_percentage 7d "$seven_day" "$seven_day_reset"
printf '\n'
