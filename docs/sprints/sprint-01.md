# Sprint 1: Grasslands MVP planning and foundation

Status: Scheduled plan. Responsibilities and roster are confirmed; story estimates and team capacity still need to be recorded. Future milestones below are targets, not completed work.

- Planning issue: [#1 — Plan the first sprint and agree the MVP](https://github.com/dmikkelsen04/grasslands-class-project/issues/1).
- Last updated: November 23, 2026.
- Project deadline: **December 9, 2026**.
- Sprint start / end: **November 23–29, 2026**.
- Team: Danny (`dmikkelsen04`) and `mFrank0707`.
- Sprint goal: Deliver a reviewed grasslands map with the eight existing creature assets, basic spawning/movement, and a collection UI ready for gameplay integration.
- Team capacity and committed points: **To confirm before committing to sprint scope**.

## MVP and planning decisions

The planned player journey is to spawn in the grasslands, find and catch creatures, view discoveries in a collection index, and retain collection progress after rejoining.

Confirmed on November 23, 2026:

- Use the **eight existing grasslands creatures**. Record their species names and asset references during the issue #3 import; this is reuse of the existing roster, not eight newly created species.
- Danny owns the map, creature design/adaptation, spawning/movement, animations, and server-validated catching (issues #2–#6).
- `mFrank0707` owns UI design, collection index behavior, saving/loading, and integration/regression testing (issues #7–#9).
- Both teammates participate in two-player tests, review each other's PRs, and prepare the final demo/evidence for issue #10. Test coordination belongs to mFrank0707; Danny fixes problems in the systems he owns.
- The assignment is due **December 9, 2026**.

Existing models and any reused animation data must be listed as prior work. Record class-specific edits and integration separately.

Confirmed map decisions:

- Use the original spawn and grasslands at their original size and positions.
- Reuse existing visual assets, with their prior-work status recorded in the asset register. Implement class gameplay separately from the old game's scripts.
- Remove bikes and the Munch Ball display, including its pedestals and labels.
- Keep only this zone and close the exit to the omitted biomes.

Remaining planning work:

- Record each teammate's available time and estimates against the schedule below. No work-hour availability is assumed.
- Inventory the eight existing species and their asset references during import. Update GitHub issues #1 and #3 to match the confirmed eight-creature scope.
- Record story estimates and confirm the reviewer rotation: mFrank0707 reviews Danny's PRs; Danny reviews mFrank0707's PRs.
- Update the project board with the dates, ownership, and planned issue stages below.

## Schedule through submission

Use two one-week sprints, followed by two days for release checks and submission preparation. Dates are inclusive. November 26–27 are kept light for holiday flexibility; no integration deadline depends on those days.

| Dates | Goal | Danny | mFrank0707 | Review / exit target |
| --- | --- | --- | --- | --- |
| **Sprint 1: November 23–29** | Map, creature foundation, and UI foundation | Finish map review; import all eight existing creatures; implement spawning/movement; prepare rigs and start animations (#2–#5) | Build index layout and discovered/undiscovered states using sample data; define collection/save data shape; start the test checklist (#7–#9 groundwork) | November 29: demonstrate map traversal, creature spawning/movement, and UI preview; review PRs and record a short retrospective |
| **Sprint 2: November 30–December 6** | Complete and test the catch → index → save loop | Finish animations for all eight species; implement server-validated catching; fix gameplay defects (#5–#6) | Connect catch results to the index; implement saving/loading; run automated and two-player regression checks (#7–#9) | December 6: demonstrate all eight species, catch feedback, isolated player collections, and successful rejoin persistence; record review/retrospective and freeze new features |
| **December 7–8** | Release checks, documentation, and rehearsal | Resolve remaining map/gameplay defects; explain asset reuse and gameplay implementation | Resolve UI/save/test defects; assemble test evidence and demo instructions | Both: verify a clean build and merged/reviewed work, rehearse the demo on December 8, and prepare the submission package (#10) |
| **December 9** | Submit assignment | Final submission check with teammate | Final submission check with Danny | Submit by the course's stated cutoff; verify the exact time in the assignment portal |

Dependency checkpoints:

- **November 24:** agree stable IDs for the eight species, the collection record format, and the catch-result interface. This lets UI/save work proceed using sample data while catching is built.
- **November 29:** map and creature foundation ready; UI can display all eight species from sample data. Sample data is not evidence of functioning catches or saves.
- **December 2:** integrate one complete catch → index → save → rejoin example early enough to expose integration problems.
- **December 4:** extend the working loop and animations to all eight species; complete the first full two-player regression pass.
- **December 6:** finish acceptance checks and review/merge planned features. December 7–8 are reserved for fixes and delivery, not new features.

Write tests alongside each system, not only at the end. If a checkpoint slips, raise it in the daily log and drop optional polish/variants before compromising core catch, collection, or save behavior. Do not silently reduce the agreed eight-creature roster.

## Sprint 1 backlog

The dates and work split are scheduled at Danny's request. Estimates remain unassigned until capacity is discussed; partial issue stages must not be counted as a completed issue.

| Story | Owner | Reviewer | Estimate | Current status |
| --- | --- | --- | --- | --- |
| [#1 — MVP and sprint planning](https://github.com/dmikkelsen04/grasslands-class-project/issues/1) | Danny proposed; both teammates agree decisions | mFrank0707 proposed | To estimate together | Planning draft |
| [#2 — Playable grasslands map](https://github.com/dmikkelsen04/grasslands-class-project/issues/2) | Danny implemented with AI assistance | mFrank0707 requested on PR #11 | No pre-work estimate recorded; do not invent one retroactively | Implemented; awaiting peer review and merge |
| [#3 — Creature art](https://github.com/dmikkelsen04/grasslands-class-project/issues/3) | Danny | mFrank0707 proposed | To estimate for eight existing creatures | Proposed next story; asset inventory/import pending |
| [#4 — Spawning and movement](https://github.com/dmikkelsen04/grasslands-class-project/issues/4) | Danny | mFrank0707 | To estimate | Sprint 1 target after map/asset import |
| [#5 — Animations](https://github.com/dmikkelsen04/grasslands-class-project/issues/5) | Danny | mFrank0707 | To estimate | Prepare/start in Sprint 1; finish all eight in Sprint 2 |
| [#7 — Collection index](https://github.com/dmikkelsen04/grasslands-class-project/issues/7) | mFrank0707 | Danny | To estimate | UI/sample-data stage in Sprint 1; live integration in Sprint 2 |

For #8–#9, Sprint 1 covers the data contract and test plan only; implementation and regression acceptance are Sprint 2 work. Issue #6 is Sprint 2 work. Collect evidence throughout both sprints and finalize #10 on December 7–8.

## Progress log

| Date | Progress and evidence | Remaining work / blockers | Accepted points |
| --- | --- | --- | --- |
| November 23, 2026 | Prepared the original-size spawn/grasslands map, removed bikes and the Munch Ball display, and updated [PR #11](https://github.com/dmikkelsen04/grasslands-class-project/pull/11). Studio navigation/boundary checks and CI passed. See [map review at the tested revision](https://github.com/dmikkelsen04/grasslands-class-project/blob/ea0eeb0/docs/map-review.md) and [CI run](https://github.com/dmikkelsen04/grasslands-class-project/actions/runs/45253238469). | Teammate review and merge remain. Planning dates, roster, and assignments are pending. | Not calculated; estimates and sprint commitment are not yet agreed. |
| November 23, 2026 | Danny confirmed the December 9 deadline, reuse of all eight existing grasslands creatures, his ownership of map/creature design/animations, and mFrank0707's ownership of UI design. | Set sprint dates, inventory creature assets, assign remaining gameplay work, and agree estimates/reviewers. | No points assigned to this planning update. |
| November 23, 2026 | Danny assigned spawning/movement and catching to himself, and index behavior, saving/loading, and integration testing to mFrank0707. At Danny's request, scheduled Sprint 1 for November 23–29 and Sprint 2 for November 30–December 6, with December 7–8 reserved for delivery preparation. | Record capacity/estimates, reconcile GitHub issues, and update the board. | No points assigned to scheduling. |

Append actual daily updates with the date, contributor, work completed, next action, blockers, and issue/PR evidence. Record points only after estimates are agreed and stories meet the definition of done.

## Board and evidence plan

Proposed board columns: Backlog, Ready, In progress, In review, Done. Record each selected issue's owner, reviewer, estimate, and sprint. Put #2 in In review while PR #11 awaits approval; move it to Done only after acceptance and merge. Board setup/updates still need to be confirmed.

Each teammate should add a brief update on working days. Review PRs at the next working session so integration does not wait until sprint end. Hold a demo/review and short retrospective on November 29 and December 6. Keep review feedback on PRs and link Studio screenshots, tests, and CI results. Follow the repository's [definition of done](../../CONTRIBUTING.md): acceptance evidence, passing checks, peer approval, merge, and a board update.

## Sprint review

Not held yet. At sprint end, record the review date and participants, demonstrate accepted work, link merged PRs, and list unfinished stories carried forward. The current map is implemented but is not yet accepted Done work.

## Retrospective

Not held yet. Each teammate should record what helped, what slowed progress, and one improvement with an owner for the next sprint.

## Remaining acceptance work for issue #1

- [x] Confirm the assignment deadline: December 9, 2026.
- [x] Confirm the roster: eight existing grasslands creatures.
- [x] Record ownership of visual work, gameplay, collection, persistence, and testing.
- [x] Set sprint dates and reserve a delivery buffer before December 9.
- [ ] Inventory species names/assets, confirm the remaining MVP scope, and reconcile GitHub issues with the local documents.
- [ ] Agree selected stories, owners, reviewers, and estimates.
- [ ] Create/update the project board and record the planning decision date and participants.
- [x] Schedule working-day updates and sprint reviews/retrospectives for November 29 and December 6.

Keep issue #1 open until these planning decisions are actually agreed and recorded.
