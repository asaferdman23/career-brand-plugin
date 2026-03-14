# Career Brand Plugin for Claude Code

Personal branding & career strategy for developers. Create LinkedIn content, plan content calendars, get career advice, prep for interviews — all powered by AI with your unique story.

## Install

For local development, load the plugin directly:

```bash
claude --plugin-dir /absolute/path/to/career-brand-plugin
```

Claude Code marketplace installs use `/plugin install`, not `claude plugin add`. Until this repo is published through a Claude Code marketplace, `--plugin-dir` is the correct way to test it.

## Commands

Plugin skills are namespaced in Claude Code, so you invoke them as:

- `/career-brand:brand`
- `/career-brand:career`

### `/career-brand:brand` — Personal Branding & LinkedIn Content

Create LinkedIn posts with a storyteller voice, plan monthly content calendars, brainstorm ideas, and set post reminders.

```
/career-brand:brand I just shipped a feature that uses AI to generate event layouts
/career-brand:brand plan my month
/career-brand:brand ideas
/career-brand:brand set a reminder to tell me when it's time to post
```

**First run:** The skill asks for your LinkedIn plus 3 follow-up questions to build your career profile.

**What it does:**
- Drafts posts in a storyteller voice (no "I'm thrilled to announce" ever)
- Offers 2-3 hook variations to choose from
- Suggests language based on your audience
- Plans monthly content calendars aligned with your career goals
- Reads your git log for build-in-public material
- Can schedule in-session post reminders using Claude Code scheduled tasks
- Ships a `Notification` hook so reminder turns can raise a desktop notification when Claude needs your input
- Dispatches a `career-advisor` subagent to align content with your career strategy

### `/career-brand:career` — Career Co-Pilot

Career direction, job search, networking strategy, and interview prep.

```
/career-brand:career what kind of roles should I target?
/career-brand:career [paste a job listing]
/career-brand:career networking
/career-brand:career interview prep for senior fullstack role
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
- `brand_automation.md` — reminder conditions and scheduling preferences

A **career-advisor subagent** is dispatched for deep strategic thinking — content theme planning, opportunity evaluation, networking strategy.

## Post Reminders

The brand skill can now collect reminder conditions and create Claude Code scheduled tasks for post reminders.

Example prompts:

```text
/career-brand:brand remind me every weekday at 9:00 if I still have no post drafted this week
/career-brand:brand set up a reminder to check my brand calendar every Tuesday and Thursday
/career-brand:brand remind me tomorrow at 18:00 to draft the builder story from this week's commits
```

Important limitations from Claude Code:

- Scheduled tasks are session-scoped. They disappear when you exit Claude Code.
- Recurring tasks expire after 3 days unless recreated.
- For durable reminders that survive restarts, you need an external scheduler such as Claude Desktop scheduled tasks or GitHub Actions.
- Desktop notifications depend on your OS having `osascript`, `notify-send`, or `powershell.exe` available.

## Who Is This For

- Developers who want to build a LinkedIn presence but hate writing corporate-speak
- Engineers with side projects/startups who need their content to serve dual goals
- Career changers or people with non-traditional backgrounds (sports, military, self-taught) — this plugin treats your unique story as a superpower
- Anyone who wants a career co-pilot that gives real advice, not motivational fluff

## Contributing

PRs welcome. If you have ideas for new modes, content pillars, or career features — open an issue or submit a PR.
