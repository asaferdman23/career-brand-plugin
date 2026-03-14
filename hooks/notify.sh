#!/usr/bin/env bash
set -euo pipefail

title="Claude Code"
message="Career Brand needs your attention"

case "$(uname -s)" in
  Darwin)
    osascript -e "display notification \"${message}\" with title \"${title}\"" >/dev/null 2>&1 || true
    ;;
  Linux)
    if command -v notify-send >/dev/null 2>&1; then
      notify-send "${title}" "${message}" >/dev/null 2>&1 || true
    fi
    ;;
  *)
    if command -v powershell.exe >/dev/null 2>&1; then
      powershell.exe -Command "[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null; [System.Windows.Forms.MessageBox]::Show('${message}', '${title}')" >/dev/null 2>&1 || true
    fi
    ;;
esac
