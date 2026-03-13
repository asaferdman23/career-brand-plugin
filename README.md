# Career Brand Plugin for Claude Code

Personal branding & career strategy for developers. Create LinkedIn content, plan content calendars, get career advice, prep for interviews — all powered by AI with your unique story.

## Install

```bash
claude plugin add github:asaferdman23/career-brand-plugin
```

## Commands

### `/brand` — Personal Branding & LinkedIn Content

Create LinkedIn posts with a storyteller voice, plan monthly content calendars, and brainstorm ideas.

```
/brand I just shipped a feature that uses AI to generate event layouts
/brand plan my month
/brand ideas
```

**First run:** The skill asks 7 quick questions to build your career profile. Takes 2 minutes.

**What it does:**
- Drafts posts in a storyteller voice (no "I'm thrilled to announce" ever)
- Offers 2-3 hook variations to choose from
- Suggests language based on your audience
- Plans monthly content calendars aligned with your career goals
- Reads your git log for build-in-public material
- Dispatches a career-advisor agent to align content with your career strategy

### `/career` — Career Co-Pilot

Career direction, job search, networking strategy, and interview prep.

```
/career what kind of roles should I target?
/career [paste a job listing]
/career networking
/career interview prep for senior fullstack role
```

**Modes:**
- **Career direction** — stay vs. leave, what roles to target, startup timing
- **Job search** — target companies, profile optimization, resume tailoring, salary guidance
- **Networking** — who to connect with, communities, commenting strategy
- **Interview prep** — behavioral stories, "tell me about yourself", mock interviews

**Dual-path aware:** If you have a side project or startup, every recommendation accounts for both your job search AND your project.

## How It Works

Both skills share context through memory files:
- `user_career_profile.md` — your career background (created on first run)
- `career_goals.md` — your current targets (created by `/career`)
- `brand_calendar.md` — your monthly content plan (created by `/brand`)
- `brand_performance.md` — what posts worked (you report, it learns)

A **career-advisor agent** is dispatched for deep strategic thinking — content theme planning, opportunity evaluation, networking strategy.

## Who Is This For

- Developers who want to build a LinkedIn presence but hate writing corporate-speak
- Engineers with side projects/startups who need their content to serve dual goals
- Career changers or people with non-traditional backgrounds (sports, military, self-taught) — this plugin treats your unique story as a superpower
- Anyone who wants a career co-pilot that gives real advice, not motivational fluff

## Contributing

PRs welcome. If you have ideas for new modes, content pillars, or career features — open an issue or submit a PR.
