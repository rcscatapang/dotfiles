---
name: test-audit
description: "Audit existing tests for low-value, implementation-coupled, or duplicate tests, and for test-only hooks in production code that exist only to serve them. Use when the user asks to audit, prune, sweep, or clean up tests, or to judge whether a test suite earns its maintenance cost."
---

# Test audit

This skill has two modes with one value bar. Audit mode runs a focused sweep for tests that restate source, duplicate stronger proof, couple to implementation, or keep test-only hooks alive in production code. Campaign mode prunes every test one subsystem owns in a single PR. Before starting a campaign, read [CAMPAIGN.md](CAMPAIGN.md).

Optimize for confidence, not deletion count. Continue a broad audit as separate follow-up PRs, one coherent batch each.

The authoring gate for new tests lives in the global agent instructions under "Testing". This skill calls production code that exists only for tests a **test-only hook**. The `tdd` skill uses "seam" for the public boundary where tests belong, so don't call hooks seams.

## Junk patterns

The global authoring gate rejects a new test that matches one of these. Audits hunt for existing tests that do.

- tests with no assertions that only exercise code for coverage;
- self-comparisons and identity copiers;
- copied fixtures, inventories, manifests, or export lists;
- exact source, import, or string greps;
- tests of private predicates or call shapes that a real-boundary test already covers;
- duplicate invocations of the same contract;
- local replays of a shared helper's tests in each caller;
- tests whose only purpose is to keep a test-only export, global, or wrapper alive;
- dead production code whose only callers are tests;
- expected values produced by the helper or renderer under test;
- mocks that implement the asserted behavior, or one identical mock standing in for different APIs;
- fixtures that supply the result, admission, or callback order the owner should produce, or persistence asserted against a store the code path never writes;
- capability tests that restate declared flags instead of exercising the delivery or acknowledgement the flag promises;
- negative controls that pass for an unrelated reason, such as a denial from a different guard or a rejection the production path never reaches;
- names or fixtures that promise more than the input exercises, such as a test named "retires the window" that asserts the window was not cleared.

## Value bar

A test earns its maintenance cost by protecting behavior, a credible regression, or an independently meaningful contract. An existing test that must change when you reorganize source without changing behavior is suspect, but not automatically deletable.

Before judging a candidate, read the complete test and its production owner. Also read the entry point, callers, callees, sibling implementations, overlapping tests, CI configuration, and git history. Read the root and nearest `AGENTS.md` or `CLAUDE.md` first. When the test claims behavior that depends on a library, read that library's source or types directly.

## Retention bar

Keep a test when it independently enforces a public API, protocol, config, migration, storage, security, platform, default value, package, release, or architecture contract. Also keep:

- call-order assertions when the order is observable behavior;
- regression tests with a credible failure mode;
- a source inspection test when it is the cheapest independent guard, meaning it fails when the contract changes (the user-facing key, byte, or path) and survives a rename of identifiers;
- a test that fails on the baseline. Treat it as a possible product bug. Reproduce it and fix the owner instead of deleting the test.

Static or slow is not a reason to delete. A test that resembles implementation may still be the only independent proof of a contract. Prove otherwise before removing it.

## Discovery

Keep discovery read-only and report evidence before editing anything. For a broad scope, run read-only agents in parallel, one per area. A Laravel app might split into domain and application code, HTTP and API, jobs and console, frontend, and a cross-cutting pattern sweep.

Outside campaign mode, prefer a few high-confidence candidates over a long speculative list.

## Candidate evidence

Record every field below before editing. A candidate with a missing field is not ready for deletion.

- the exact test name and location;
- the failure it can actually detect;
- the non-test callers of the production code or support helper it covers;
- the stronger owner-boundary test that remains, or why no proof is needed;
- the relevant history and the reason the test or hook exists;
- the production or test-support code that deleting it unlocks;
- the risk and the focused command that validates the change.

Show the user this list and wait for approval before editing.

## Edit shape

Pick one coherent batch at one owner boundary. Delete obsolete test-only exports, globals, wrappers, and dead production paths instead of keeping aliases. Move retained regression tests to their canonical owners. Fold repeated package or dependency assertions into one generic contract test.

Prefer a net reduction in production lines. Don't add replacement tests that restate the same implementation. Don't turn uncertain candidates into cleanup to raise the deletion count.

## Validation

Don't edit source or tests while a test watcher is running in the checkout.

1. Run the owner and sibling tests with the project's runner, for example `php artisan test --filter=<name>`, `vendor/bin/pest <path>`, or `npx vitest run <path>`.
2. If you removed a test that grepped source or asserted a plan, run the script or dry run that owns the real contract.
3. Run the project's formatter on changed files, then `git diff --check`.
4. Run the full suite, or the CI gate the repository requires.
5. Read `git diff --numstat`. Report production and tooling lines separately from test and test-support lines.
6. Run the `code-review` skill on the final diff.

## Landing

Commit, push, or open a PR only when the user approves. Land one coherent batch per PR. After it lands, pull `main` and rerun read-only discovery for the next batch.

## Handoff

Report:

- the root cause and the low-value categories removed;
- production code the audit simplified;
- false positives you kept and why they still matter;
- the focused and full test runs you actually ran;
- production lines versus test lines changed;
- PR and merge state;
- named follow-ups.
