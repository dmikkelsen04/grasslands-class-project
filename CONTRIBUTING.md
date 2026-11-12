# Contributing

## Branches and reviews

`main` is the approved source. After the initial bootstrap, use short-lived `feature/<issue>-<name>`, `fix/<issue>-<name>`, or `chore/<issue>-<name>` branches. Do not push directly to `main`.

```sh
git switch main
git pull --ff-only
git switch -c feature/12-grasslands-map
```

Make focused commits such as `feat: add grasslands spawn boundaries`. Push the branch and open a PR with `Closes #12` in its description only when it actually completes the issue. Use `Refs #12` for partial progress.

Every PR needs a review from the other teammate. Review actual code and playtest evidence, give specific feedback, and resolve discussions. New code commits dismiss previous approval. Authors may merge after approval and passing checks; they cannot approve their own PR. Use squash merge for one coherent change per issue.

Required GitHub settings are documented in `docs/github-setup.md`; those settings must be enabled on GitHub and are not enforced by this document itself.

## Definition of ready

- User story states who benefits and why.
- Acceptance criteria are observable and small enough for a sprint.
- Owner, estimate, dependencies, and reviewer are agreed by the team.
- Imported assets have known provenance and permission.

## Definition of done

- Acceptance criteria are met, with evidence recorded on the issue/PR.
- Meaningful automated tests accompany gameplay logic when feasible.
- Studio playtests cover the affected interactions; multiplayer changes receive a multi-client check.
- Build and format CI passes; documentation and the asset register are current.
- Another teammate approves the PR and conversations are resolved.
- PR is merged and the board is updated to Done.

## Working with assets

Export individual models as `.rbxmx` where practical. Do not commit entire old game places. Remove embedded gameplay scripts from reused visual models and review descendants before importing. Track animation asset IDs and permission requirements in the asset register. Do not claim old art or animation production as new class work.

## Evidence and AI assistance

Record development honestly, including tools/AI assistance when required by course policy. Understand and review contributed code. Neither generated code nor automated feedback substitutes for the rubric's peer review.
