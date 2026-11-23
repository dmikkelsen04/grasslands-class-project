# Grasslands Class Project

A new Roblox software engineering class project: one small, playable grasslands zone where players find creatures, catch them, and track their collection.

## Current state

Issue #2 map implementation copies the original spawn and grasslands at their original scale and positions: five static plots, the safe-zone stripe, pond, barn, cornfield, trees, five encounter grass patches, and original cliff walls. All five bikes and the Munch Ball display (balls, pedestals, and labels) are removed. A matching wall closes the exit to omitted biomes. Eight original grasslands creatures now spawn, roam, and play their idle/walk animations. Catching, the collection index, and persistence are **not implemented**. See [creature implementation and tests](docs/creature-review.md).

Development starts with this repository. The map geometry and layout are explicitly reused prior work from the owner's Catch a Shiny place, recorded in [the asset register](docs/assets.md). New class work covers extraction, removing legacy interactions/bikes, packaging, closing the biome exit, validation, and future gameplay. Reusing a map does not count as creating it during this project.

## Scope

The proposed MVP is one grasslands map, the eight existing grasslands creature species, basic creature movement/animations, one catching interaction, an index, and saved collection progress. Sprint 1 runs November 23–29 and Sprint 2 runs November 30–December 6, with December 7–8 reserved for delivery preparation before the December 9, 2026 deadline. See the [sprint plan and responsibilities](docs/sprints/sprint-01.md). Other zones, trading, monetization, elaborate economies, and stealing mechanics are outside the initial scope. See [scope and acceptance criteria](docs/scope.md).

## Get started on Windows

Install Git and Roblox Studio. Clone this repository and open PowerShell in its folder. Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools/setup.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File tools/check.ps1
```

The setup script downloads pinned official releases of Rojo 7.7.1 and StyLua 2.6.0 into this repository's ignored `.tools` directory. The check script validates Luau formatting/syntax and builds `build/grasslands.rbxlx`.

Open **that generated file** in Studio and press Play. Walk through the entrance to the meadow, visit the pond and barn, and test the cliff boundaries. Confirm both startup messages appear in Output. See [map validation and review](docs/map-review.md). The original game is not needed to build this version. The reused ground texture is a hosted Roblox asset and needs normal Roblox asset access.

## Development workflow

1. Select an issue with a user story and acceptance criteria.
2. Update local `main`, then create a feature branch such as `feature/12-grasslands-map`.
3. Implement a small change and test it. Commit source files with meaningful messages.
4. Push the branch and open a PR into `main`, linking the issue and recording test results.
5. Get a descriptive review from the other teammate and pass CI before merging.
6. Build from updated `main`, playtest the result, and publish to a separate class-project Roblox experience when ready.

GitHub protection applies to GitHub, not Studio publishing. A merge does not automatically publish the game. See [contributing](CONTRIBUTING.md), [Studio workflow](docs/studio-workflow.md), and [GitHub setup](docs/github-setup.md).

## Repository layout

- `src/server`: server-owned gameplay and validation.
- `src/client`: input, feedback, and client behavior.
- `src/shared`: shared types, configuration, and pure logic.
- `src/ui`: UI instances exported for Rojo.
- `world/grasslands`: the zone's exported models.
- `assets/creatures`: approved reusable visual assets.
- `tests`: test plan; automated gameplay tests will accompany features.
- `docs`: scope, backlog, asset provenance, sprint records, and development evidence.

## Validation and limitations

CI runs **Build and format** on pushes to `main` and on PRs. It checks formatting/Luau parsing with StyLua, builds the place with Rojo, and runs Python map-structure assertions (anchoring, safe spawn, continuous ground, the sealed biome exit, bike removal, and no embedded legacy gameplay), plus rig connectivity and animation-data validation. It does not run Roblox gameplay, type checking, or gameplay unit/integration tests yet. No gameplay coverage percentage is claimed.

CI retains the built place as a review artifact. Reviewers must also check the PR's Studio test evidence, especially for visual and multiplayer changes. No Roblox credentials or deployment keys are required for this workflow.

## Class evidence

Use issues, PRs, reviews, CI runs, real sprint records, and dated playtest evidence to document development. The initial infrastructure commit is the one-time repository bootstrap; later changes go through PRs. Do not backdate commits or mark planned gameplay complete before it works.

This repository has no open-source license grant. Asset permissions must be recorded before imports; public visibility alone does not grant reuse rights.
