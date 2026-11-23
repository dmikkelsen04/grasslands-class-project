# Reused asset register

Issue #2 reuses visual assets extracted from the owner's open Catch a Shiny place (place ID 114451084618400) on 2026-11-23. The local snapshot was preserved outside this repository. Source templates are stored in `assets/environment`; the new layout is exported in `world/grasslands/GrasslandsMap.rbxmx`. No previous gameplay scripts are included.

The imported assets are the spawn floor/point and five static plot shells, CloverBarn, LittleCornfield, WoodlandOak, and FarmCrates. The ground texture `rbxassetid://4806196507` matches the original place. See `assets/manifest.json` for individual records. Original third-party authorship/license details have not been independently verified; this repository does not grant a new license to these assets.

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
