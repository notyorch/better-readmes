---
name: write-readme
description: Generate a structured, audience-aware README.md for any project. Use when the user wants to create or generate a README for their project.
---

# write-readme

Generate a structured, audience-aware README.md for any project.

## When to Use This Skill

Invoke `/write-readme` when you want to generate a README.md for a project. Run it from the project's root directory.

## Protocol

Follow every step in order. Do not skip steps. Do not ask multiple questions in one message.

---

### Step 1 — Scan the codebase (automatic, no prompts)

Read the following files if they exist, in this priority order:

| Priority | File | What to extract |
|---|---|---|
| 1 | `package.json` | name, scripts, dependencies, devDependencies |
| 2 | `requirements.txt` / `pyproject.toml` | Python dependencies |
| 3 | `Cargo.toml` | Rust dependencies |
| 4 | `go.mod` | Go dependencies |
| 5 | `Dockerfile` | runtime, base image |
| 6 | `Makefile` | build/run targets |
| 7 | `index.js`, `main.py`, `main.rs`, `app.py`, `index.ts`, `main.go` | exports, CLI commands, API routes, component names |
| 8 | `README.md` (existing) | any existing content to preserve or reference |

**If none of the above files exist**, ask:
> "I couldn't find any config files. What language/framework is this project using?"

---

### Step 2 — Ask: audience (always ask this first, before any other question)

> "Is this a: (A) Academic project, (B) Business project, or (C) Personal/open-source project?"

Store the answer as `AUDIENCE`. Use it in Step 7 (tone matrix).

---

### Step 3 — Ask: emojis (ask immediately after audience)

> "Use emojis in section headers? (yes / no)"

Store the answer as `EMOJIS` (boolean). Use it in Step 11 when rendering section headers.

When `EMOJIS = yes`, prepend this emoji to each section header:

| Section | Emoji |
|---|---|
| Technologies | 🛠️ |
| Features | ✨ |
| Uses | 🎯 |
| Process | 🔧 |
| Learnings | 💡 |
| How can it be improved? | 🚀 |
| Running the project | ▶️ |
| Video | 🎬 |

When `EMOJIS = no`, render plain headers: `## Section Name`.

---

### Step 4 — Ask: which sections to skip (ask immediately after emojis)

Present the full section list and let the user opt out:

> "Here are the sections I'll include. Type the letters of any to **skip**, or press Enter to keep all:
> A) Technologies  B) Features  C) Uses  D) Process  E) Learnings  F) How can it be improved?  G) Running the project  H) Video  I) Hero image"

Store the set of skipped sections as `SKIPPED`. Every later step — inference, questions, and the final template — must silently omit any section in `SKIPPED`. No placeholder, no `_Coming soon._` for skipped sections.

---

### Step 5 — Section inference rules

For each section **not in `SKIPPED`**, use this table to decide whether to infer or ask:

| Section | Strategy | Fallback if unanswered |
|---|---|---|
| Title | Infer from `name` in package.json or current folder name | Ask |
| Hero image | Cannot infer — ask | Omit if skipped or no URL given |
| Technologies | Infer from dependency files | Ask: "What technologies does this use?" |
| Features | Infer from exports, routes, CLI commands, component names | Ask: "List the main features" |
| Uses | Cannot infer — ask | Write `_Coming soon._` if user skips the question |
| Process | Cannot infer — ask | Write `_Coming soon._` if user skips the question |
| Learnings | Cannot infer — ask | Write `_Coming soon._` if user skips the question |
| How can it be improved? | Cannot infer — ask | Write `_Coming soon._` if user skips the question |
| Running the project | Infer from scripts/Makefile/Dockerfile. Priority: Docker > npm/yarn > make > direct command | Ask if nothing found |
| Video | Cannot infer — ask | Omit section entirely if user says skip |

---

### Step 6 — Ask questions sequentially (one at a time, never in bulk)

Ask only what could not be inferred in Step 5, and only for sections **not in `SKIPPED`**. Use this order and wording:

1. "What is this project used for? Who uses it?"
2. "Briefly describe how you built it — decisions, approach, tools."
3. "What did you learn building this?"
4. "Any known limitations or ideas for future improvement?"
5. "Do you have a screenshot or banner image for the top? Paste a URL or type 'skip'."
6. "Do you have a demo video? Enter the URL or type 'skip'."
   - If URL given → ask: "Should I show it as a (A) plain link or (B) clickable thumbnail?"

**Never ask about something already extracted from code.**
**Never ask about a section the user chose to skip in Step 4.**
**Never ask two questions in the same message.**

---

### Step 7 — Apply tone per audience

Use the `AUDIENCE` answer from Step 2 to adjust the framing of each section:

| Section | Academic (A) | Business (B) | Project (C) |
|---|---|---|---|
| Features | System capabilities + research scope | Business value, ROI, user outcomes | Technical capabilities, what it enables |
| Uses | Target audience (researchers, students, discipline) | Who uses it, market context, business use cases | Who uses it, what they can build with it |
| Process | Methodology, design decisions, technical approach | Development approach, trade-offs, tech stack rationale | Story-driven dev journey, decisions made |
| Learnings | Research findings, academic insights, limitations discovered | Business lessons, technical decisions that worked or failed | Personal growth, technical insights, surprises |
| How can it be improved? | Research limitations, open problems, future work | Roadmap, feature backlog, scalability plans | Contribution opportunities, known limitations |

---

### Step 8 — Technologies format

Render each technology as a shield.io badge, one per line:

```markdown
![React](https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB)
![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=for-the-badge&logo=typescript&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-43853D?style=for-the-badge&logo=node.js&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)
```

Use the correct shield.io badge for each detected technology. If unsure of the exact badge URL, use:
`https://img.shields.io/badge/{{Name}}-grey?style=for-the-badge`

---

### Step 9 — Video section format

**Plain link:**
```markdown
## Video
[Watch the demo](URL)
```

**Clickable thumbnail — YouTube URL:**
Extract VIDEO_ID from the YouTube URL (`v=` parameter or path after `youtu.be/`).
```markdown
## Video
[![Demo Video](https://img.youtube.com/vi/VIDEO_ID/0.jpg)](URL)
```

**Clickable thumbnail — non-YouTube URL:**
```markdown
## Video
[![Demo Video](https://img.shields.io/badge/Watch-Demo-red?style=for-the-badge&logo=youtube)](URL)
```

**Skipped:** Do not write the Video section at all. No placeholder. No `_Coming soon._`

---

### Step 10 — Hero image format

Place the hero image directly under the title, before any other content.

**Image URL provided:**
```markdown
![{{ALT_TEXT}}]({{IMAGE_URL}})
```

Use a short, descriptive `ALT_TEXT` (e.g. the project name or "Project banner").

**Skipped or no URL:** Do not write anything. No placeholder.

---

### Step 11 — Write README.md

Write the file using this template. Fill every `{{placeholder}}`. Do not leave any placeholder unfilled. Omit any section in `SKIPPED`. Prepend emojis to headers only when `EMOJIS = yes` (see Step 3).

```markdown
# {{TITLE}}

{{HERO_IMAGE: image markdown if URL provided (Step 10), else omit entirely}}

## Technologies
{{TECHNOLOGIES: one shield.io badge per line, see Step 8}}

## Features
{{FEATURES: bullet list, 3-7 items, tone adjusted per Step 7}}

## Uses
{{USES: 2-3 sentences, tone adjusted per Step 7}}

## Process
{{PROCESS: 2-4 sentences, tone adjusted per Step 7}}

## Learnings
{{LEARNINGS: bullet list or short paragraph, tone adjusted per Step 7}}

## How can it be improved?
{{IMPROVEMENTS: bullet list, 2-5 items, tone adjusted per Step 7}}

## Running the project
{{RUNNING: fenced code blocks with commands, up to 3 run methods in priority order}}

## Video
{{VIDEO: apply format from Step 9, or omit this section entirely if skipped}}
```

**Rules:**
- Sections in `SKIPPED` are omitted completely — no header, no placeholder, no `_Coming soon._`
- For a non-skipped section with no answer and no inferred content → write `_Coming soon._`
- Video and Hero image are never written with a placeholder — they are simply absent when skipped or no URL was given
- Never invent features, tools, or behavior not present in the actual code

---

### Step 12 — Confirm and offer to publish

After writing README.md, say:

> "README.md written. Review it and let me know if you want any changes."

Then ask:

> "Want to publish it to GitHub now? I can run /publish-readme to push the README and set the repo's About description and topics. (yes / no)"

- If the user says **yes** → invoke the `publish-readme` skill (the `/publish-readme` flow) and follow its protocol.
- If the user says **no** → say: "No problem. Run /publish-readme whenever you're ready to push to GitHub."

---

## Anti-patterns

- Do not invent features not present in the code
- Do not write sections the user chose to skip in Step 4
- Do not add `_Coming soon._` for skipped sections, Video, or Hero image
- Do not ask multiple questions in one message
- Do not ask for something already extracted from code
- Do not add emojis to headers unless the user said yes in Step 3
