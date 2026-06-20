# dotfiles

## Usage

```sh
curl -sSfL https://raw.githubusercontent.com/ymkz/dotfiles/HEAD/setup.sh | bash
```

## Reset WSL

```sh { name=wsl-uninstall }
wsl.exe --unregister Ubuntu
```

after restarting the terminal

```sh { name=wsl-install }
wsl.exe --install Ubuntu
```
