# .config

Terminal and editor setup for macOS: [Ghostty](https://ghostty.org) running [Neovim](https://neovim.io), with a custom *Serial Experiments Lain* theme that both programs share.

## What's in here

```zsh
~/.config
├── nvim/        # LazyVim config
├── ghostty/     # Ghostty config and theme symlink
└── README.md
```

The colors live in a separate repo, `divine-machinery`, which generates the Ghostty theme and provides the Neovim colorscheme from one palette file.

## 1. Prerequisites

Install Xcode command line tools (needed by Treesitter to compile parsers) and Homebrew:

```zsh
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 2. Install the tools

```zsh
brew install --cask ghostty
brew install neovim git gh node ripgrep fd lazygit
brew install zsh-autosuggestions zsh-autocomplete
```

- **node** is required. Mason installs most language servers (eslint, jsonls, html, yamlls, vtsls) through npm, and they fail without it.
- **ripgrep** and **fd** power LazyVim's file and text search.
- Ghostty bundles Nerd Font symbols, so no extra font install is needed for icons.

Check that Neovim is 0.10 or newer:

```zsh
nvim --version | head -1
```

## 3. Log in to GitHub

```
gh auth login
```

Choose GitHub.com, HTTPS, authenticate Git with your credentials, and log in with the browser. Verify with `gh auth status`.

## 4. Get the config

If `~/.config` doesn't exist yet:

```
git clone https://github.com/YOUR_USERNAME/config.git ~/.config
```

If it already exists with other things in it, back it up first or clone to a temp folder and copy `nvim/`, `ghostty/` and `README.md` across.

## 5. Get the colorscheme

The Neovim config loads the colorscheme from a local folder, so clone it to the expected path:

```
mkdir -p ~/colorschemes
git clone https://github.com/YOUR_USERNAME/divine-machinery.git ~/colorschemes/divine-machinery
```

Link the Ghostty theme so Ghostty can find it:

```
mkdir -p ~/.config/ghostty/themes
ln -sf ~/colorschemes/divine-machinery/ghostty/divine-machinery ~/.config/ghostty/themes/divine-machinery
cat ~/.config/ghostty/themes/divine-machinery
```

`cat` should print the palette. If it says no such file, the link is dangling: the repo isn't at that path, or the generated file is missing. Regenerate it from the colorscheme repo root with:

```
cd ~/colorschemes/divine-machinery
nvim -l scripts/gen-ghostty.lua
```

## 6. Ghostty config

`~/.config/ghostty/config` should contain at least:

```
theme = divine-machinery

cursor-style = bar
cursor-style-blink = false
adjust-cursor-thickness = 3

background-opacity = 0.9
background-opacity-cells = true
background-blur = 20
```

Don't add manual `background`, `foreground` or `palette` lines, because they override the theme. Reload with `Cmd+Shift+,` or restart Ghostty.

`background-opacity-cells` needs a recent Ghostty. If it's rejected, update with `brew upgrade --cask ghostty`.

## 7. Zsh plugins

Add to `~/.zshrc`, in this order (autocomplete first):

```
source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
```

Then `source ~/.zshrc`. The ghost text uses ANSI color 8, which is the palette's gray. If it looks wrong, check that Ghostty's `minimum-contrast` isn't set high enough to darken it.

## 8. First launch of Neovim

```
nvim
```

LazyVim installs its plugins on first run. When it finishes, quit and reopen. Then:

1. Run `:Lazy sync` to make sure everything is installed.
2. Run `:Mason` and check that servers installed. If any failed, press `i` on each to retry now that Node is available.
3. Run `:checkhealth` and look for errors.
4. Confirm the colorscheme with `:colorscheme`. It should print `divine-machinery`.

`:MasonInstall` isn't available until Mason has loaded. Run `:Lazy load mason.nvim` first, or open `:Mason`.

## 9. Keep secrets out of git

Because `~/.config` is a repo, add a `.gitignore` so tool credentials never get committed:

```
gh/
github-copilot/
```

Review `git status` before the first push.

## Troubleshooting

| Problem | Fix |
| --- | --- |
| `Cannot find color scheme` | The colorscheme repo isn't at `~/colorschemes/divine-machinery`, or `nvim/lua/plugins/colorscheme.lua` still references an old scheme. Run `grep -rn kanagawa ~/.config/nvim`. |
| `Invalid spec module ... a nil was returned` | A file in `nvim/lua/plugins/` is missing its `return`. Every plugin file must return a table. |
| `'wsl.exe' is not executable`
