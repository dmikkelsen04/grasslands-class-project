# Roblox Studio and Git

The repository is the authoritative source for this class project. Build outputs are disposable and ignored by Git.

## Code changes

Edit `.luau` files in `src`, run `tools/check.ps1`, and open `build/grasslands.rbxlx` in Studio for testing. Save changes to source, not only to the built place.

Optional live editing: install the matching Rojo Studio plugin from the official Rojo distribution and run `.tools/rojo/rojo.exe serve default.project.json`. Connect only a class-project development place. The generated build workflow does not require the plugin.

Do not connect Rojo to the original game. Do not use Script Sync on the same folders that Rojo manages. Rojo synchronization is primarily from disk to Studio: a Studio edit is not automatically a Git commit or a source update.

## Map, creature, and UI changes

1. Work on a separate development copy for your branch.
2. Export the changed zone/model as `.rbxmx` into `world/grasslands`, creature art into `assets/creatures`, or UI into `src/ui`.
3. Record provenance for reused assets, including animation IDs and permissions.
4. Rebuild from the repository and reopen that clean build. Confirm the exported content and behavior survived the round trip.
5. Include before/after screenshots and relevant Studio test results in the PR.

Changes made only to a Studio session or published place are not protected by GitHub. Avoid having two branches modify the same model file at once. XML diffs can be noisy; inspect the actual model in Studio during review.

## Publishing

Publish manually from a fresh build of approved `main` to a new class-project experience. Never publish a feature branch over the original game. Record the source commit and tested place version in release/demo notes. Keep production and development data separate once persistence is introduced.
