# 🔌 Multi-CLI Sharing Guide

`better-readmes` is compatible with multiple AI-powered CLIs. Each CLI uses a specific adapter to maintain the same core logic and protocol.

## 📊 CLI Compatibility Matrix

| CLI | Feature Support | Adapter Format | Location |
|---|---|---|---|
| **Gemini CLI** | ✅ Full | TOML | `.gemini/commands/*.toml` |
| **Copilot CLI** | ✅ Full | Markdown + YAML | `.github/instructions/*.md` |
| **Open Code** | ✅ Full | Markdown + YAML | `.opencode/instructions/*.md` |
| **Claude Code** | ✅ Full | Markdown | `.claude/commands/*.md` |

---

## 🚀 Installation

### ♊ Gemini CLI
Copy the command files to your global or local `.gemini/commands` directory:
```bash
mkdir -p ~/.gemini/commands
cp .gemini/commands/*.toml ~/.gemini/commands/
```

### 🤖 Copilot CLI (GitHub)
The instructions are automatically detected if placed in your repository:
```bash
mkdir -p .github/instructions
# Files: write-readme.md, publish-readme.md
```

### 🔓 Open Code / Opencode
The instructions are detected in the `.opencode` directory:
```bash
mkdir -p .opencode/instructions
# Files: write-readme.md, publish-readme.md
```

### 🎭 Claude Code
Add the skills using the `npx skills` command:
```bash
npx skills add ElioUcan/better-readmes @write-readme/**
```

---

## 🛠️ How it Works
All adapters share the same **inference-first** core:
1. **Scans codebase** (package.json, requirements.txt, etc.)
2. **Infers technical stack** and running commands.
3. **Targeted questions** only for what couldn't be inferred.
4. **Tone adaptation** based on your project type (Academic, Business, Open-source).
