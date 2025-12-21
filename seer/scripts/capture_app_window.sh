#!/usr/bin/env bash
set -euo pipefail

out=${1:-/tmp/app-window-shot.png}
process=${2:-}

if [[ -z "${process}" ]]; then
  process=$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true' 2>/dev/null || true)
fi

pos=$(osascript -e "tell application \"System Events\" to tell process \"${process}\" to get position of window 1" 2>/dev/null || true)
size=$(osascript -e "tell application \"System Events\" to tell process \"${process}\" to get size of window 1" 2>/dev/null || true)

if [[ -z "${pos}" || -z "${size}" ]]; then
  echo "error: window not found for process '${process}'"
  echo "hint: verify app is running, Accessibility enabled for terminal, and process name (try exact app name)"
  exit 1
fi

pos=$(echo "${pos}" | tr -d ' ')
size=$(echo "${size}" | tr -d ' ')

x=${pos%,*}
y=${pos#*,}
w=${size%,*}
h=${size#*,}

screencapture -x -R "${x},${y},${w},${h}" "${out}"

echo "${out}"
