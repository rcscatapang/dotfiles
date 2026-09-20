---
name: commit
description: Group changes into logical commits by concern, using descriptive Conventional Commit messages, then create them for the user to review before pushing. Use whenever a commit is being made, when asked to commit work, or when a skill calls for `/commit`. Never run `git commit` directly instead of this.
---

# commit

Shared commit workflow for Codex and Claude Code. The detailed instructions live in `references/commit.md`.

Read `references/commit.md` and follow it in full.

Two notes for both clients:

- `references/commit.md` refers to the current session's conversation as the source of *why* a change was made. For `rcsc-*` runs, prefer the commit draft at `.scratch/<slug>/drafts/commit-NN.md`, which was written while the reasoning was fresh.
- The no-trailer rule at the end is not negotiable on any host. Nothing identifying the model goes in the message.
