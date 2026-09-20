# Shared marketing skills

A focused selection from [coreyhaines31/marketingskills](https://github.com/coreyhaines31/marketingskills), based on release `v2.11.1` at commit `5b2c0007766c6a1cf1d53fd8fc73e979e0821022`.

This collection is disabled by default and is not linked globally. From a project's root, run `~/Workspace/code/dotfiles/bin/link-agent-skills --project-bundle marketing "$PWD"` to link each skill into that project's `.agents/skills/` for Codex and `.claude/skills/` for Claude Code.

## Included skills

- `product-marketing`
- `copywriting`
- `cro`
- `analytics`
- `seo-audit`
- `launch`
- `content-strategy`
- `pricing`
- `cold-email`

## Change the selection

Each immediate directory under `skills/` is one bundled skill. To customize the selection:

1. Copy the complete upstream `skills/<name>/` directory into this bundle's `skills/` directory. Keep its references, scripts, and other supporting files together.
2. Remove an unwanted skill by deleting its complete directory here.
3. Run `bin/link-agent-skills --project-bundle marketing <project-directory>` to refresh both clients in that project.

Local edits to the included `SKILL.md` files customize their behavior for this setup. Review those changes before copying a newer upstream version over them, because an update can overwrite the local instructions.
