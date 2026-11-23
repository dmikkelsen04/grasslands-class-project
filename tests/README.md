# Test plan

No gameplay tests exist yet because gameplay has not been implemented. CI parses/formats Luau, builds the place, and runs `python3 tests/map_structure.py build/grasslands.rbxlx`. The map checks catch unsafe spawn placement, floor gaps, missing/non-colliding perimeter walls, unanchored geometry, and embedded old gameplay scripts/interactions. This is not gameplay unit/integration coverage. Studio walkthrough results are recorded in `docs/map-review.md`.

Each gameplay PR should add tests for its pure rules and record Studio validation for Roblox-dependent behavior. Planned automated coverage includes catch validation/cooldowns, concurrent catch award handling, unique collection entries, and saved-data failure handling.

Manual acceptance evidence should record commit, date, tester, scenario, expected result, actual result, and relevant screenshot/video. Include:

- Safe spawn, traversal, collisions, and boundaries.
- Each species' spawn and animation behavior.
- Successful, failed, invalid, and repeated catch attempts.
- Two players targeting the same creature.
- Collection isolation between players.
- Rejoining after saves and simulated persistence failures.
- UI at desktop and smaller/mobile viewport sizes.
