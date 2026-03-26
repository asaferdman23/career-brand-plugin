# Career Brand Plugin — Development Guide

## What this is
A Claude Code plugin with two skills (`brand`, `career`), one subagent (`career-advisor`), and a notification hook. It helps developers build their personal brand on LinkedIn and manage their career strategy.

## Project structure
```
commands/       — Slash command entry points (thin wrappers that invoke skills)
skills/         — Skill definitions (brand, career) — the core logic
agents/         — Subagent definitions (career-advisor)
hooks/          — Notification hook (inline in hooks.json, notify.sh kept for reference)
index.html      — Landing page (GitHub Pages)
```

## Key conventions

### Multi-profile support
Profiles are stored in the project memory directory under `profiles/profile_[name].md`. The plugin supports managing brands for multiple people — always scope actions to the active profile.

### Paste-first design
LinkedIn browser scraping is unreliable. The primary flow for profile setup is **paste-based input**. Browser scanning is an optional enhancement, never a requirement.

### Subagent error handling
All career-advisor subagent dispatches must have a fallback. If the subagent fails or returns empty, the skill continues with its own analysis. Never block the user on a subagent failure.

### Memory files
- `profiles/profile_[name].md` — career profile per person
- `career_goals.md` — current career targets and decisions
- `brand_calendar.md` — monthly content plan
- `brand_performance.md` — post performance tracking
- `brand_automation.md` — reminder preferences

### Hook
The notification hook is inline in `hooks.json` — no external script dependency, no env vars required. Works on macOS (osascript), Linux (notify-send), and Windows (powershell).

## When editing skills
- Keep the voice guide rules strict — they prevent generic AI-sounding LinkedIn posts
- Always handle the multi-profile case (ask who if ambiguous)
- Test both fresh-profile and existing-profile flows
- Commands in `commands/` are thin — logic lives in `skills/`
