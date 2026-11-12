# Grasslands Class Project

A new Roblox software engineering class project: one small, playable grasslands zone where players find creatures, catch them, and track their collection.

## Current state

Repository bootstrap only. The build contains a temporary gray floor, a spawn, and server/client startup messages. The grasslands map, creatures, catching, animations, collection index, and persistence are **not implemented**.

Development starts with this repository. No previous game versions or gameplay scripts are imported. Selected art, creature models, and animation assets from the author's existing game may be reused later, with their origin recorded in [the asset register](docs/assets.md). Reusing an asset does not count as creating it during this project.

## Scope

The proposed MVP is one grasslands map, a small roster (initial target: three creature species), basic creature movement/animations, one catching interaction, an index, and saved collection progress. The team will confirm the roster and sprint dates before implementation. Other zones, trading, monetization, elaborate economies, and stealing mechanics are outside the initial scope. See [scope and acceptance criteria](docs/scope.md).

## Get started on Windows

Install Git and Roblox Studio. Clone this repository and open PowerShell in its folder. Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools/setup.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File tools/check.ps1
```

The setup script downloads pinned official releases of Rojo 7.7.1 and StyLua 2.6.0 into this repository's ignored `.tools` directory. The check script validates Luau formatting/syntax and builds `build/grasslands.rbxlx`.

Open **that generated file** in Studio and press Play. Confirm both startup messages appear in Output. This is a scaffolding check, not a gameplay test. The original game is not needed to build this baseline.

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

CI currently runs **Build and format** on pushes to `main` and on PRs. It checks formatting/Luau parsing with StyLua and builds the place with Rojo. It does not run Roblox gameplay, type checking, or unit/integration tests yet. Those tests are planned in the backlog; no test coverage is claimed for this bootstrap.

CI retains the built place as a review artifact. Reviewers must also check the PR's Studio test evidence, especially for visual and multiplayer changes. No Roblox credentials or deployment keys are required for this workflow.

## Class evidence

Use issues, PRs, reviews, CI runs, real sprint records, and dated playtest evidence to document development. The initial infrastructure commit is the one-time repository bootstrap; later changes go through PRs. Do not backdate commits or mark planned gameplay complete before it works.

This repository has no open-source license grant. Asset permissions must be recorded before imports; public visibility alone does not grant reuse rights.
