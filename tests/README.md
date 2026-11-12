# Test plan

No gameplay tests exist yet because gameplay has not been implemented. The initial CI check parses/formats Luau and builds the place; that is not unit or integration coverage.

Each gameplay PR should add tests for its pure rules and record Studio validation for Roblox-dependent behavior. Planned automated coverage includes catch validation/cooldowns, concurrent catch award handling, unique collection entries, and saved-data failure handling.

Manual acceptance evidence should record commit, date, tester, scenario, expected result, actual result, and relevant screenshot/video. Include:

- Safe spawn, traversal, collisions, and boundaries.
- Each species' spawn and animation behavior.
- Successful, failed, invalid, and repeated catch attempts.
- Two players targeting the same creature.
- Collection isolation between players.
- Rejoining after saves and simulated persistence failures.
- UI at desktop and smaller/mobile viewport sizes.
