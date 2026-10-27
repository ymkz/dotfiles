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

## Reset WSL

```sh { name=wsl-uninstall }
wsl.exe --unregister Ubuntu
```

after restarting the terminal

```sh { name=wsl-install }
wsl.exe --install Ubuntu
```
