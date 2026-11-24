# .config

Terminal and editor setup for macOS: [Ghostty](https://ghostty.org) running [Neovim](https://neovim.io) with a custom *Serial Experiments Lain* theme that both programs share.

## project structure

```zsh
~/.config
├── nvim/        # LazyVim config
├── ghostty/     # Ghostty config and theme symlink
└── README.md
```

The colors live in a separate repo, `divine-machinery`, which generates the Ghostty theme and provides the Neovim colorscheme from one palette file.

## prerequisites

Install Xcode command line tools (needed by Treesitter to compile parsers) and Homebrew:

```zsh
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## install tools

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

## log into github

```zsh
gh auth login
```

Choose GitHub.com, HTTPS, authenticate Git with your credentials, and log in with the browser. Verify with `gh auth status`.

## clone the repo

If `~/.config` doesn't exist yet:

```zsh
git clone https://github.com/YOUR_USERNAME/config.git ~/.config
```

If it already exists with other things in it, back it up first or clone to a temp folder and copy `nvim/`, `ghostty/` and `README.md` across.

## clone the colorscheme

The Neovim config loads the colorscheme from a local folder, so clone it to the expected path:

```zsh
mkdir -p ~/colorschemes
git clone https://github.com/YOUR_USERNAME/divine-machinery.git ~/colorschemes/divine-machinery
```

Link the Ghostty theme so Ghostty can find it:

```zsh
mkdir -p ~/.config/ghostty/themes
ln -sf ~/colorschemes/divine-machinery/ghostty/divine-machinery ~/.config/ghostty/themes/divine-machinery
cd ~/colorschemes/divine-machinery
nvim -l scripts/gen-ghostty.lua
```

## ghostty config

`~/.config/ghostty/config` should contain at least:

```config
theme = divine-machinery

cursor-style = bar
cursor-style-blink = false
adjust-cursor-thickness = 3

background-opacity = 0.9
background-opacity-cells = true
background-blur = 20
```

## zsh plugins

Add to `~/.zshrc`, in this order (autocomplete first):

```zshrc
source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
```

## launch neovim

```zsh
nvim
```

LazyVim installs its plugins on first run. When it finishes, quit and reopen. Then:

1. Run `:Lazy sync` to make sure everything is installed.
2. Run `:Mason` and check that servers installed. If any failed, press `i` on each to retry now that Node is available.
3. Run `:checkhealth` and look for errors.

`:MasonInstall` isn't available until Mason has loaded. Run `:Lazy load mason.nvim` first, or open `:Mason`.
