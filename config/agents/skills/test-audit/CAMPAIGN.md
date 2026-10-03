# Test-pruning campaign

A campaign prunes every test one subsystem owns in a single PR. The subsystem can be a module, a package, or one core area. The value bar, retention bar, candidate evidence, and validation in [SKILL.md](SKILL.md) apply to every lane. This file adds the order of work.

The examples come from a campaign on a Telegram messaging plugin. Each step ends on its completion criterion. Don't start the next step early.

## 1. Baseline

Pin a `main` commit. At that commit, record the subsystem's test and test-support line counts and the pass or fail state of every test file. Keep baseline failures in their own list. In the Telegram campaign, all three baseline failures were real delivery bugs, not stale tests.

Done when every in-scope test file has a recorded baseline result.

## 2. Lanes and inventory

Split the tests into **lanes** along production owner boundaries, not file name prefixes. Telegram's lanes were accounts, commands, context, dispatch, inbound, outbound, persistence, transport, shared, harness, and live scenarios. Include the subsystem's cases in shared core tests and any end-to-end or live test harness it owns.

Done when every test file and scenario the subsystem owns belongs to exactly one lane.

## 3. Read-only ledger per lane

Give each lane to its own read-only agent. The agent reads every assigned test in full, including data providers and parameter tables. It also reads the production owners with their entry points, callers, history, and CI configuration. It writes each test declaration into a **ledger** with one mark. A data-provider or `it.each` test counts as one declaration unless its rows need different marks. In that case, mark each row.

- `R` means retain. Name the contract and the bug it catches. A test that only moves to a better-named file stays `R`, with the move noted.
- `F` means retain the contract but fix the assertion. An example is a negative check that passes when only one of several items is missing.
- `C` means consolidate. Name the owner that absorbs the assertion: a sibling table case, a stronger boundary suite, or a shared owner in another package.
- `D` means delete. Name the proof that remains, or explain why no contract exists.

Judge a test by its assertions, not its name. One Telegram test named for retiring a progress window asserted the window was _not_ cleared.

Done when every declaration in the lane has a mark and an evidence line.

## 4. Layer plan per lane

The ledger is input, not the edit list. A second read-only pass starts from the ledger and looks for whole redundant **layers**. In Telegram, several dispatch suites replayed the same shared compositor through one mocked preview, next to stronger suites that used the real stream and HTTP fixtures. Name the **keeper** suite for each contract. Prefer the real transport boundary with a fake network over a mocked collaborator. Correct any ledger errors this pass finds.

Done when each lane plan names its retired files, its keeper per contract, the assertions to move into keepers, and the test-only hooks it unlocks.

## 5. Cutover

Edit one lane at a time. Route all changes to shared harnesses and support files through one agent, so lanes don't conflict. In each lane, remove the test-only hooks it unlocks: injection parameters, getters, reset exports, and indirection layers. Update any CI routing, test inventories, or line-count baselines that list the moved files. Add test-ownership rules to the subsystem's `AGENTS.md` or `CLAUDE.md`, based on mistakes this campaign actually found.

Done when every lane plan is applied and each lane's keepers pass.

## 6. Preservation review

Before you claim completion, have independent reviewers compare the deleted coverage against the keepers, one reviewer per group of boundaries. They look for contracts that lost their only proof. They also look for new assertions that can't fail, such as a rejection row the production code never reaches. The Telegram review found nine real gaps and one unreachable assertion.

For each restored contract, make one deliberate **mutation** in the production owner and confirm the keeper fails. Then restore the source exactly, and check with `git diff`.

Done when every reported gap is restored or rejected with source evidence, and every restored contract has a mutation that its keeper caught.

## 7. Product defects

A baseline failure that survives into a keeper is a bug report. Fix it at its owner in a separate commit. Prove the fix through the real user flow, with a **control** run that reverts the fix and shows the old behavior. Record unrelated product problems you find as follow-ups instead of fixing them in the campaign.

Done when each repaired defect has a failing control and a passing candidate on the same harness.

## 8. Reconcile and hand off

A campaign branch lives through many `main` commits. Merge `main` into it rather than rebasing a long branch. When `main` changed a file the campaign deleted, keep the deletion. Port the new contract into the keeper instead, and confirm every new regression test from `main` still has a home. Rerun the whole subsystem suite and repeat any live proof on the merged head.

Review tools may show a truncated file list on a diff this large. Record maintainer decisions about compatibility flags in the PR description rather than changing CI gates.

Hand off with the [SKILL.md](SKILL.md) report, plus:

- baseline and final test and test-support line counts, with production counted separately;
- lanes, retired layers, and keepers;
- preservation gaps found and the mutations that proved them;
- product defects with control and candidate proof.
