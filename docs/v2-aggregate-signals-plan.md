# V2 Plan: Aggregate Performance Signals Backend

## The Problem
Individual `brand_performance.md` files are local and isolated. No user knows what post formats, topics, or hooks perform best *across* users. The plugin gives personal memory but no community signal.

## The Solution: GitHub-Based Opt-In Data Collective

Users opt in to share anonymized post performance data. A GitHub repo aggregates it. The plugin reads the aggregate back as enhanced best practices.

**Why GitHub (not Supabase/Cloudflare):**
- Zero infrastructure cost and zero ops
- Fully transparent — users can audit exactly what's shared
- Scales to thousands of users with no backend changes
- GitHub Actions handles aggregation for free
- Raw file URLs serve the data back to the plugin instantly

---

## Architecture

```
[User's local brand_performance.md]
         ↓  (opt-in, anonymized)
[Plugin: /share command]
         ↓  gh CLI or curl
[GitHub Repo: career-brand-data]
         ↓  GitHub Action (nightly)
[Aggregated: signals/aggregate.json]
         ↓  raw.githubusercontent.com URL
[Plugin reads on every /brand session]
         ↓
[Enhanced linkedin_algorithm.md updates]
```

---

## Data Schema

### What Users Submit (`submissions/YYYY-MM-DD-[hash].json`)
```json
{
  "submitted_at": "2026-03-27",
  "plugin_version": "1.2.0",
  "post": {
    "topic_pillar": "builder_story",
    "hook_type": "tension_opener",
    "language": "english",
    "length_chars": 1102,
    "has_image": false,
    "hashtag_count": 2,
    "posted_time": "tuesday_morning"
  },
  "performance": {
    "reactions": 47,
    "comments": 12,
    "shares": 3,
    "performance_tier": "high"
  }
}
```

**What is NOT collected:**
- Post text content
- User identity (name, handle, email)
- Company or employer
- Any personally identifiable information

### Aggregate Output (`signals/aggregate.json`)
```json
{
  "generated_at": "2026-03-27",
  "sample_size": 847,
  "top_performing": {
    "hook_types": ["tension_opener", "counterintuitive_claim", "specific_number"],
    "topic_pillars": ["builder_story", "opinionated_take"],
    "optimal_length_chars": { "min": 900, "max": 1300 },
    "best_posting_times": ["tuesday_morning", "wednesday_morning", "thursday_morning"],
    "language_split": { "english": 0.68, "hebrew": 0.21, "bilingual": 0.11 }
  },
  "avoid": {
    "hook_types": ["humble_brag", "generic_wisdom"],
    "topic_pillars": ["cert_announcement"],
    "posting_times": ["friday_afternoon", "weekend"]
  }
}
```

---

## Opt-In UX (Plugin Side)

### First time setup asks:
```
Want to contribute anonymized post performance data to improve
recommendations for all users?

What's shared: topic type, hook format, post length, reactions/comments count.
What's NOT shared: post text, your name, your company, any identifiable info.

[Y] Yes, contribute anonymously   [N] No thanks
```

Saved to `brand_automation.md` as:
```
- data_sharing: opted_in | opted_out
- data_sharing_since: YYYY-MM-DD
```

### Share command (triggered after logging performance):
When user logs performance in `brand_performance.md`, the skill detects opt-in status and submits automatically — no extra step required.

### Manual share command (optional):
```
/brand share-performance
```
Submits all entries in `brand_performance.md` that haven't been shared yet.

---

## Submission Mechanism (Two Options)

### Option A: GitHub CLI (simplest, requires gh auth)
```bash
gh api repos/[owner]/career-brand-data/contents/submissions/$(date +%Y-%m-%d)-$(openssl rand -hex 4).json \
  --method PUT \
  --field message="Add performance submission" \
  --field content=$(echo '{"..."}' | base64)
```

### Option B: GitHub Personal Access Token via curl (no gh CLI required)
Store token in `brand_automation.md` (user provides their own PAT with write access to the data repo). No server-side secrets needed.

### Option C: Pull Request flow (most transparent)
Plugin creates a local JSON file, opens a PR to the data repo. Maintainer reviews and merges. Slower but fully auditable.

**Recommendation for V2 launch:** Option A (gh CLI). Most Claude Code users already have it. Fall back gracefully if not available.

---

## Aggregation (GitHub Actions)

`.github/workflows/aggregate.yml` in the data repo:
```yaml
name: Aggregate Signals
on:
  schedule:
    - cron: '0 3 * * *'  # nightly at 3am UTC
  workflow_dispatch:

jobs:
  aggregate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run aggregation
        run: node scripts/aggregate.js
      - name: Commit aggregate
        run: |
          git config user.email "bot@career-brand-plugin"
          git config user.name "Aggregator Bot"
          git add signals/aggregate.json
          git commit -m "Update aggregate signals $(date +%Y-%m-%d)" || exit 0
          git push
```

`scripts/aggregate.js`: reads all `submissions/*.json`, computes stats, writes `signals/aggregate.json`.

---

## Plugin Reads Aggregate

In the brand skill "First: Load Context" section, add:
```bash
curl -s https://raw.githubusercontent.com/[owner]/career-brand-data/main/signals/aggregate.json \
  2>/dev/null || echo "{}"
```

If fetch fails (no internet, repo down), silently fall back to embedded defaults. Never block the user.

Aggregate is used to:
1. Override specific fields in `linkedin_algorithm.md` with community-observed data
2. Surface in Mode 3 brainstorm: "Community data shows builder stories are performing 2.4x better than how-tos this month"

---

## Privacy Model

| Data point | Collected | Rationale |
|-----------|-----------|-----------|
| Post text | No | Could identify user or employer |
| User name/handle | No | Anonymity |
| Topic pillar | Yes | Pure category, not content |
| Hook type | Yes | Structural pattern only |
| Post length (chars) | Yes | Aggregate metric |
| Reactions/comments | Yes | Public engagement counts |
| Posting time (slot) | Yes | Day + time-of-day bucket only |
| Language | Yes | English/Hebrew/bilingual only |

---

## Milestones

| Milestone | What |
|-----------|------|
| V2.0 | Data repo setup, submission script, opt-in UX, gh CLI path |
| V2.1 | GitHub Actions aggregation, plugin reads aggregate.json |
| V2.2 | Aggregate influences brainstorm ranking and algorithm defaults |
| V2.3 | Changelog in aggregate.json — plugin shows "Updated March 2026: X trends" |

---

## Open Questions
- Minimum sample size before aggregate is trusted (suggest: 50 submissions before surfacing community signals)
- How to handle outliers / fake submissions (basic statistical filtering in aggregation script)
- Whether to open-source the data repo or keep submissions private (recommendation: submissions private, aggregate.json public)
