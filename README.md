# dotfiles

## Usage

```sh
curl -sSfL https://raw.githubusercontent.com/ymkz/dotfiles/HEAD/setup.sh | bash
```

## Skills

`skills/` contains locally maintained skills. `setup.sh` links `commit-ja`,
`pr-writer`, `show-me`, and `code-review` into `~/.agents/skills/` for use across
repositories. Move an existing non-symlink directory out of the destination
before running setup.

Edit the files in this repository to customize them. Each skill's `UPSTREAM.md`
records its source or verified reference commit and local changes; its `LICENSE`
retains the upstream terms. To incorporate upstream updates, compare against the recorded commit,
apply the changes you want, then update `UPSTREAM.md` and any affected notices.
Upstream updates are not applied automatically.

## GitHub Actions

Workflow dependencies are pinned in `.github/workflows/actions.lock`, generated
with [`gh-actions-lock`](https://github.com/github/gh-actions-lock). After
authenticating with `gh auth login`, install the extension:

```sh
gh extension install github/gh-actions-lock --pin v0.4.0
```

After adding a workflow or changing a `uses:` reference, regenerate and verify
the lockfile:

```sh
gh actions-lock
gh actions-lock --verify
gh actions-lock --verify-local
```

Commit the workflow changes and lockfile together. Do not edit the lockfile by
hand. CI verifies it with `gh actions-lock --verify`; Renovate regenerates it
when updating actions. Keep the extension version in CI, Renovate's
`constraints.ghActionsLock`, and these instructions in sync.

## Reset WSL

```sh { name=wsl-uninstall }
wsl.exe --unregister Ubuntu
```

after restarting the terminal

```sh { name=wsl-install }
wsl.exe --install Ubuntu
```
