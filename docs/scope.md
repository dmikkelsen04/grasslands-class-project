# Proposed MVP and architecture

This is a planning baseline, not a record of completed features.

## Player journey

Join a small grasslands zone, locate a creature, attempt a catch, see the result, and inspect collection progress. Return later and retain previously discovered species.

## MVP acceptance criteria

- A new player spawns safely and can reach all intended grasslands areas.
- The eight existing grasslands creature species can spawn within valid zone boundaries.
- Creatures have basic idle/movement visuals and do not spawn inside obstacles.
- One catching tool/input has clear success and failure feedback.
- The server validates target, distance, cooldown, and ownership/reward eligibility.
- A successful catch updates the owner's collection exactly once.
- The index distinguishes discovered and undiscovered species.
- Saved collection progress survives rejoining; failures do not overwrite existing data with an empty profile.
- Two players can interact without duplicate catch awards or cross-player collection changes.
- A README and demo guide let the instructor run and evaluate the project.

## Proposed boundaries

Server code owns creature lifecycle, catch validation/results, and saved player collections. Client code handles input, presentation, and UI. Shared modules hold types, configuration, and pure calculations that can be tested without a running place. Visual models live in asset folders, not inside gameplay source.

Use the eight existing grasslands creatures; rarity tiers and shiny variants are stretch goals after the base loop works. Additional zones, player stealing, trading, monetization, and a full economy are out of scope.

## First planning meeting

Confirmed November 23, 2026: the assignment is due December 9, 2026. Danny owns the map, creature design/adaptation, animations, spawning/movement, and catching. mFrank0707 owns UI design, the collection index, saving/loading, and integration/regression testing. Both participate in reviews and the final demo. The roster is the eight existing grasslands creatures.

Sprint 1 runs November 23–29; Sprint 2 runs November 30–December 6. December 7–8 are reserved for fixes, documentation, and rehearsal before submission on December 9. See the [sprint plan and dependency checkpoints](sprints/sprint-01.md). Capacity, story estimates, and board updates remain to be recorded.
