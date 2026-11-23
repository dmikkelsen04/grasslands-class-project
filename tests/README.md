# Test plan

CI parses/formats Luau, builds the place, and runs `tests/map_structure.py` and `tests/creature_assets.py`. The map checks cover spawn placement, original floor connections, the closed biome exit, anchoring, and absence of legacy interactions. Creature checks cover all eight rigs, internal joint connectivity, one anchored root, and valid matching idle/walk pose data.

`creatures.studio.server.luau` and `creatures.studio.client.luau` form a separate two-client Studio integration harness. They check the shared population cap, each species moving and changing states, invalid ground/obstacle rejection, client animation, despawn/respawn, duplicate removal rejection, and stop/restart. These runtime checks are not executed by GitHub Actions. See [creature review and test instructions](../docs/creature-review.md). Catching, collection, and persistence tests remain future work.

Each gameplay PR should add tests for its pure rules and record Studio validation for Roblox-dependent behavior. Planned automated coverage includes catch validation/cooldowns, concurrent catch award handling, unique collection entries, and saved-data failure handling.

Manual acceptance evidence should record commit, date, tester, scenario, expected result, actual result, and relevant screenshot/video. Include:

- Safe spawn, traversal, collisions, and boundaries.
- Each species' spawn and animation behavior.
- Successful, failed, invalid, and repeated catch attempts.
- Two players targeting the same creature.
- Collection isolation between players.
- Rejoining after saves and simulated persistence failures.
- UI at desktop and smaller/mobile viewport sizes.
