Group changes into logical commits by concern, using descriptive Conventional Commit messages, then create them for the user to review before pushing.

## Instructions

1. **Gather inputs before writing anything.**
   - `git status`, `git diff --staged`, `git diff` — the source of truth for *what* changed.
   - `git log --oneline -10` — the repo's recent commit style.
   - Repo conventions, if documented (`CLAUDE.md`, `CONTRIBUTING.md`, `.gitmessage`, a `commit-msg` hook). These override the style defaults below — type vocabulary, casing, scope usage, subject length, ticket policy. They do not override the no-trailer rule at the end; if a repo documents a required trailer, surface it and ask rather than adding it silently.
   - This session's conversation — the source of *why*, and of what was actually run. Rationale only; never describe the session itself.

2. **Preflight the branch.**

   ```bash
   git rev-parse --abbrev-ref HEAD
   git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null
   ```

   Protected = the remote default branch (fall back to `main`/`master` when `origin/HEAD` is unset), plus any long-lived integration branch — `develop`, `staging`, `production`, `release/*`. Check `git branch -r` when unsure; many repos branch off `develop`, not the default.

   If changes are about to land on one, raise it **before staging anything** and propose a branch name read off the repo:

   ```bash
   git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads | head -10
   ```

   Copy the shape those branches show — prefix, separator, casing. `feature/cv-1912-holding-modal`, `fix-login-redirect` and `rc/dark-mode` are each correct in the repo that uses them. With no shape to copy, fall back to `<type>/<short-kebab-description>`. Never invent a tracker ID: include one only when the repo's branches use them *and* you have a real one.

   Offer the `git checkout -b` command; do not switch branches yourself unless the user agrees. Uncommitted changes carry over, so branching here loses nothing. If the user says to commit on the protected branch anyway, do it — some repos are trunk-based by design — and treat that as settled for the rest of the session.

   A ticket in the branch name says nothing about whether it belongs in the message; that is decided separately, in step 6.

3. **Reconcile the diff against the session.** If the session claims work the diff does not show, or the diff holds changes never discussed, resolve that before committing rather than writing a message that papers over it.

4. **Group by concern, not by file type.**
   - Backend for a single feature (migration, model, config, service, controller, route, tests) = one commit.
   - Frontend for a single feature (pages, components) = one commit.
   - An unrelated bug fix = its own commit.

   Split further when two distinct concerns share a changeset, when a breaking schema change needs isolating, or when dependency and tooling changes are mixed with application behavior. Merge when frontend and backend are tiny and tightly coupled, or the whole changeset is one small fix with no logical separation.

5. **Stage only the relevant files** — specific paths or patch staging, not `git add -A`. Never stage secrets, credentials, `.env` files, local build artifacts, unrelated user changes, or files whose purpose is unclear.

   Untracked files are the likeliest accidents. If a new file looks like a build artifact, log, dump, lockfile churn, coverage output, editor/OS cruft or a scratch file — or you cannot tell what it is for — name it to the user rather than staging it silently. A file that should have been gitignored is a bug worth surfacing, not one to sweep into the commit.

6. **Draft each message** as `<type>[optional scope]: <present-tense description>`, using the standard Conventional Commits types (`feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`).

   These rules apply to the **whole message — subject, body and footer:**
   - Lowercase types, unless recent history strongly uses another convention. Scopes when they add context: `fix(cart): correct cart count on home`.
   - **Present tense**: `fix`, `add`, `update`, `remove`, `rename` — never `fixed`, `added`, `updated`.
   - **Describe the code, never the task.** State what the codebase now does — not the request, prompt, session, agent, plan, ticket or review behind it. Never "as requested", "per feedback", "from the plan", "address review comments", or any mention of an assistant.
   - **Short and descriptive, not exhaustive.** One clear line naming the change; do not enumerate files or functions, or narrate the process.
   - Subject under 72 characters where practical.
   - **Default to a subject line only.** Add a body only per "Commit body" below.
   - Breaking changes take `!` after the type or scope and always warrant a body: `feat(api)!: require signed webhook requests`.

   **Ticket references — default to none, and never invent one.** A `[CV-123]` prefix or a `Closes #88` footer is repo metadata, decided by the repo. Include one only when the user asks, the repo documents it as required, or recent history is near-unanimous:

   ```bash
   git log --format='%s' -10 --no-merges | grep -cE '^\[?[A-Z]{2,10}-[0-9]+\]?'
   ```

   8+ of 10 is a convention; anything less is a mixed history with no rule in force, which means no prefix. Do not widen the window to find a majority — a repo can sit at 60% historically and have dropped the practice entirely. Never derive a prefix from a branch name or from a ticket mentioned in passing; tickets, ticket-named branches *and* deliberately clean subjects is a common combination, not an oversight to correct.

   When warranted, match the repo's exact shape and put it before the type: `[CV-123] fix(cart): correct cart count on home`. A ticket ID is never the description itself. A real security identifier is always fine, because it is part of what the change *is*: `fix(deps): patch CVE-2026-1234 in guzzle`.

   Never let a reference replace the description — `fix(cart): resolve ENG-451`, `feat: implement CV-1912` and `feat: implement step 3 of the plan` are all wrong. `fix: cart fixes` names the area but not the change; `fix(cart): restore add to cart button state` names the change.

7. **Check each message against its index.** Re-read `git diff --staged` beside the message drafted for it. If the staged diff includes files the message does not account for, or the message describes work that is not staged, fix the index or revise the message. Never commit a message that overstates or understates what is staged.

8. **Present the commit plan and wait for confirmation** — which files go into which commit, with what message — before creating anything. If step 2 flagged a protected branch and the user has not resolved it, restate that here rather than committing quietly.

9. After approval, commit in logical order (backend before frontend). Then run `git status`, and show the user the resulting hashes, messages and branch, reminding them to review with `git log` before pushing.

## Commit body

Default to a subject line alone. Write a body only when:

- The change is a feature, breaking change, schema migration, or security fix.
- The *why* is not recoverable from the diff — a non-obvious trade-off, a rejected alternative, a constraint imposed from outside the code.
- The change carries operational risk: a deploy ordering requirement, a backfill, a manual step.

Trivial fixes, copy tweaks, formatting, dependency bumps and small self-evident refactors get a subject line only. Do not manufacture a body to fill the template.

When warranted, wrap body lines at 72 characters (bullet continuations indented two spaces) and use:

```text
<type>(<scope>): <short summary>

Summary:
- <what the codebase now does — behaviour, not a file-by-file changelog>

Rationale:
- <the problem solved, trade-off accepted, or alternative rejected>

Tests:
- <command run and its outcome, or "not run (reason)">
```

Rationale is where "describe the code, never the task" is easiest to violate: "Holds were being created against incomplete paperwork" is rationale; "the user asked for a hold gate" is not. Never claim a test passed that you did not run. Omit a section rather than padding it — a body with only `Rationale:` and `Tests:` is fine when the subject already covers what changed. Every rule in step 6 applies here too.

## Creating the commit

For a subject-only commit, `git commit -m "fix(home): correct cart count display"` is fine. With a body, use `-F` so newlines stay literal — never `-m` with an embedded `\n`, which lands in the message as a literal backslash-n:

```bash
git commit -F - <<'EOF'
feat(hold): gate holds on required documents

Summary:
- Add a required_to_hold flag to document types
- Block hold creation until every flagged document is uploaded

Rationale:
- Holds were being created against incomplete paperwork, which
  forced manual reversal downstream.

Tests:
- php artisan test --compact --filter=Hold
EOF
```

Do NOT push to remote. The user will review and push manually.
Do NOT add Co-Authored-By lines, or any other AI-attribution trailer, to commit messages.
