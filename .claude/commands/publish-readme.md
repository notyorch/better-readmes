---
name: publish-readme
description: Push a project's README.md to GitHub and set the repo's About description and topics automatically. Use when the user wants to publish their README to GitHub.
---

# publish-readme

Push a project's README.md to GitHub and set the repo's About description and topics automatically.

## When to Use This Skill

Invoke `/publish-readme` from a project directory that already has a `README.md`. Typically run after `/write-readme`.

## Protocol

Follow every step in order. Do not skip steps. Stop and print instructions if any prerequisite fails.

---

### Step 1 — Check prerequisites

Run each check in order. Stop immediately if one fails — print the fail message and do nothing else.

**Check 1: GitHub CLI installed**
```bash
gh --version
```
If this fails → print: "GitHub CLI not found. Install it at https://cli.github.com — then run: gh auth login"

**Check 2: GitHub CLI authenticated**
```bash
gh auth status
```
If this fails → print: "Not authenticated with GitHub. Run: gh auth login"

**Check 3: README.md exists**
Check that `README.md` exists in the current working directory.
If missing → print: "No README.md found in this directory. Run /write-readme first."

**Check 4: git repo initialized**
```bash
git rev-parse --is-inside-work-tree
```
If this fails → print: "No git repository found. Run: git init"

---

### Step 2 — Detect existing remote

```bash
git remote get-url origin
```

- If a remote URL is returned → skip to Step 4
- If the command errors or returns nothing → proceed to Step 3

---

### Step 3 — Create GitHub repo (only if no remote exists)

Ask: "Should this repo be public or private?"

Wait for the answer, then ask: "What should the repo be named? (default: {{current directory name}})"

```bash
gh repo create {{name}} --{{public|private}} --source=. --remote=origin
```

---

### Step 4 — Generate About description

Read the README.md:
- Line starting with `#` → project title
- First 3 bullet points under the Features section → key capabilities (match any line containing "Features", e.g. `## Features` or `## ✨ Features`)

From this, generate a one-sentence plain-text description. Rules:
- Max 350 characters
- No markdown (no `**`, no `#`, no backticks)
- No hashtags
- No emoji

```bash
gh repo edit --description "{{generated description}}"
```

---

### Step 5 — Generate topics

Extract topics from two sources:

1. **Technologies section** — map each detected technology to its GitHub topic slug (match any line containing "Technologies", e.g. `## Technologies` or `## 🛠️ Technologies`):
   - React → `react`
   - TypeScript → `typescript`
   - Python → `python`
   - Node.js → `nodejs`
   - Docker → `docker`
   - Go → `golang`
   - Rust → `rust`
   - Vue → `vue`
   - Next.js → `nextjs`
   - PostgreSQL → `postgresql`
   - MongoDB → `mongodb`
   - (use lowercase slug form for any other technology)

2. **Project type** — infer exactly one from: `web-app`, `cli`, `library`, `api`, `mobile`, `data-science`, `devtools`, `game`

Rules:
- All lowercase
- Hyphens instead of spaces
- Max 10 topics total
- No duplicates

```bash
gh repo edit --add-topic {{topic1}} --add-topic {{topic2}} --add-topic {{topic3}} ...
```

---

### Step 6 — Show confirmation summary

Get the authenticated GitHub username:
```bash
gh api user --jq '.login'
```

Print this summary with all values filled in — do not print it with placeholders:

```
About to publish:

  Repo:    github.com/{{username}}/{{repo-name}}
  About:   {{generated description}}
  Topics:  {{topic1}}, {{topic2}}, {{topic3}}, ...

Push now? (yes / no)
```

If user says no → print: "Cancelled. Run /publish-readme again when you're ready." Then stop.

---

### Step 7 — Push

Detect whether README.md is already tracked by git:
```bash
git log --oneline -- README.md
```
- If output is empty → default commit message is `docs: add README`
- If output has lines → default commit message is `docs: update README`

Detect the current branch:
```bash
git branch --show-current
```

Ask the user:
> "Commit message (press Enter for default: '{{default message}}')"

Use the user's input if provided, otherwise use the default.

```bash
git add README.md
git commit -m "{{commit message}}"
git push -u origin {{current branch}}
```

After a successful push, print:
```
Done! View your repo at: https://github.com/{{username}}/{{repo-name}}
```

---

## Anti-patterns

- Do not run `gh repo create` if a remote already exists
- Do not push without showing the confirmation summary and receiving a yes
- Do not use markdown, emoji, or hashtags in the GitHub About description
- Do not use spaces in topic slugs — use hyphens
- Do not generate more than 10 topics
- Do not ask multiple questions in one message
