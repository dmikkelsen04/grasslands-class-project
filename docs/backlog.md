# Initial backlog

All items below are **planned**, not completed. Story points, assignees, and sprint dates should be set by the team during planning. Create GitHub issues from these descriptions; this document is the bootstrap planning baseline.

## 1. Plan the first sprint and agree the MVP

As a teammate, I want an agreed scope and sprint plan so that we can deliver a demonstrable game on time.

- Confirm the deadline, sprint dates, three-creature roster, and MVP scope.
- Give each selected story an owner, estimate, and reviewer.
- Create/update the project board and record sprint planning decisions.
- Agree how to collect daily progress, review, and retrospective evidence.

## 2. Build a playable grasslands map

As a player, I want a small navigable grasslands area so that I can explore and find creatures.

- Replace the temporary gray bootstrap floor/spawn with the new zone.
- Provide a safe spawn, clear boundaries, and reachable creature areas.
- Export the map to the repository; a clean build reproduces it.
- Record a Studio walkthrough checking collisions and out-of-bounds behavior.

## 3. Import approved grasslands creature art

As a player, I want three recognizable creature species so that I can tell catches apart.

- Agree and import three species using only approved visual assets.
- Record their provenance, prior-work status, and permissions.
- Remove embedded old gameplay scripts and document model pivot/rig requirements.
- Verify the models render correctly in a clean build.

## 4. Implement creature spawning and movement

As a player, I want creatures to appear and move within the grasslands so that the zone feels alive.

- Spawn only registered species within valid zone boundaries.
- Limit population and clean up creatures correctly.
- Keep movement within bounds and avoid invalid spawn positions.
- Demonstrate stable behavior with two players and record tests.

## 5. Integrate creature animations

As a player, I want creatures to animate while idle and moving so that their behavior is readable.

- Integrate idle/movement animation for each agreed species.
- Record reused animation IDs/data and confirm access permissions.
- Transition without stuck tracks and stop animations on cleanup.
- Record visual evidence from a clean Studio build.

## 6. Implement server-validated catching

As a player, I want to attempt a catch and receive clear feedback so that I can collect creatures.

- Implement one input/tool and explicit success/failure feedback.
- Validate distance, valid/live target, cooldown, and player eligibility on the server.
- Prevent duplicate rewards when two players target the same creature.
- Add automated tests for catch rules and a two-player Studio test.

## 7. Build the collection index

As a player, I want an index of discovered creatures so that I can track my progress.

- Show all MVP species with discovered/undiscovered states.
- Update immediately after a successful catch; duplicates do not add duplicate species entries.
- Ensure one player's catch never changes another player's index.
- Verify UI usability at desktop and a smaller/mobile viewport.

## 8. Save and restore collection progress

As a returning player, I want my discoveries to persist so that I keep my progress.

- Save and restore collection records using a versioned data format.
- Handle load/save failures without silently overwriting existing progress.
- Isolate development test data from production data.
- Test failure paths and demonstrate persistence across rejoining.

## 9. Add automated gameplay tests and regression checks

As a developer, I want repeatable tests so that changes do not break catch and collection rules.

- Choose and document a Luau test runner suitable for the pure logic modules.
- Test invalid catches, duplicate awards, collection updates, and persistence serialization/failures.
- Run tests in PR CI and require the test check before merging.
- Record actual coverage/limitations and a manual two-player regression checklist.

## 10. Prepare the class demo and development evidence

As an instructor, I want reproducible setup and an evidence-backed walkthrough so that I can evaluate the product and engineering process.

- Update setup instructions and list implemented versus deferred features.
- Prepare a short demo covering exploration, catching, index, and saved progress.
- Link real issues, PRs, reviews, CI runs, sprint reviews, and retrospectives.
- Document each person's contributions and reused assets accurately.
