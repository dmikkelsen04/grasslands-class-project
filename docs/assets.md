# Reused asset register

Issue #2 copies the original spawn and grasslands from the owner's Catch a Shiny place (114451084618400), snapshotted on 2026-11-23. **The geometry and layout are reused prior work.** The original cloud place was not modified. The snapshot is kept outside this repository.

`assets/environment/OriginalSpawnAndGrasslands.rbxm` contains the original floors, spawn point, five plot shells, grasslands decorations, pond, barn/cornfield, trees, crates, grass patches, den scenery, safe-zone stripe, and perimeter cliffs at unchanged positions and sizes. The Munch Ball display, five bikes, and old gameplay scripts/interactions are removed. Distant biome decorations stored under the original Level 1 folder are excluded. Hosted textures/meshes retain their original references. `world/grasslands/GrasslandsMap.rbxm` adds only a matching wall at the removed biome exit.

See `assets/manifest.json`. Original third-party authorship/license details have not been independently verified; this repository does not grant a new license to these assets.

For each import, add an entry to `assets/manifest.json` with:

- `id`: a stable local identifier.
- `name`: the model, animation, image, or audio name.
- `kind`: model / animation / image / audio.
- `path`: repository-relative file path, when stored here.
- `robloxAssetId`: hosted asset ID, when applicable.
- `source`: original game, file/version, or creator source.
- `creator`: actual creator, with tool/AI assistance disclosed as applicable.
- `permission`: ownership or license basis, including hosted asset access.
- `priorWork`: true for material made before this class repository.
- `changesForClass`: modifications made during this project.
- `issue`: issue/PR tracking the import.

For visual models, inspect all descendants and remove existing gameplay scripts. Rebuild gameplay in new reviewed code. For animations, distinguish reusable animation data from the newly written playback/integration code. Do not invent ownership or dates where they are unknown.
