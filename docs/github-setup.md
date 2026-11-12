# GitHub configuration

These are intended settings. Check GitHub to verify their current enforcement; a tracked file cannot activate branch protection.

- Repository: `grasslands-class-project`, public.
- Default branch: `main`.
- Enable Issues and Actions.
- Use squash merges and automatically delete merged feature branches.
- Protect the exact `main` branch after the initial bootstrap push.
- Require a pull request and **one approving review**.
- Dismiss stale approvals when new commits are pushed.
- Require conversation resolution.
- Require the **Build and format** status check and an up-to-date branch.
- Apply rules to administrators; do not bypass protection for routine work.
- Block force pushes and branch deletion.

The teammate needs repository write access and must accept their invitation before their approval can satisfy the rule. Rotate authors/reviewers so contributions and review work are visible. Do not configure a fake reviewer or relax review requirements to merge your own PR.

Create a GitHub Project with Backlog, Ready, In Progress, In Review, and Done states. Add issues from `docs/backlog.md`, assign actual owners, and schedule milestones only after sprint planning. Track estimated and completed work per sprint using real dates and activity.

CI builds the Roblox place but does not publish it. No deployment secret is needed. Automated gameplay tests and their required check can be added through a reviewed PR when the first gameplay module is implemented.
