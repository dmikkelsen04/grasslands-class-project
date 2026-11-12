# Reused asset register

No existing-game assets have been imported yet. The only initial scene objects are new primitive scaffolding in `default.project.json`.

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
