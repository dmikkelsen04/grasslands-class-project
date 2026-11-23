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

Use the eight existing grasslands species; rarity tiers and shiny variants are stretch goals after the base loop works. Additional zones, player stealing, trading, monetization, and a full economy are out of scope.

## First planning meeting

Confirm teammate responsibilities, reviewer rotation, deadline, sprint duration/dates, creature roster, and persistence testing approach. Record decisions in the first sprint document before committing to sprint scope. These decisions have not yet been made.
