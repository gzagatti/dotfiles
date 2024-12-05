dotfiles := $(shell pwd)
workspace := $(HOME)

.PHONY: all

shells: bash zsh tmux profile

# SYMLINK CREATION
bin/%:
	mkdir -p $(workspace)/.local/$(@D)
	ln -fs $(dotfiles)/$@ $(workspace)/.local/$@

emacs/%:
	mkdir -p $(workspace)/.emacs.d
	ln -fs $(dotfiles)/$@ $(workspace)/.emacs.d/$(@F)

gtk/%:
	mkdir -p $(workspace)/.config/gtk-3.0
	mkdir -p $(workspace)/.config/gtk-4.0
	ln -fs $(dotfiles)/$@ $(workspace)/.config/gtk-3.0/$(@F)
	ln -fs $(dotfiles)/$@ $(workspace)/.config/gtk-4.0/$(@F)

ipython/%:
	mkdir -p $(workspace)/.ipython/profile_default
	ln -fs $(dotfiles)/$@ $(workspace)/.ipython/profile_default/$(@F)

julia/%:
	mkdir -p $(workspace)/.julia/config
	ln -fs $(dotfiles)/$@ $(workspace)/.julia/config/$(@F)

jupyter/%:
	mkdir -p $(workspace)/.jupyter
	ln -fs $(dotfiles)/$@ $(workspace)/.jupyter/$(@F)

nix/%:
	mkdir -p $(workspace)/.config/$(@D:nix/%=%)
	ln -fs $(dotfiles)/$@ $(workspace)/.config/$(@:nix/%=%)

# symlinks to ~/
ctags/%   \
editorconfig/% \
git/%     \
r/%       \
shells/%  \
vim/%     \
wezterm/% \
:
	ln -fs $(dotfiles)/$@ $(workspace)/.$(@F)

# symlinks to ~/.config/
alacritty/%  \
kitty/%      \
latexmk/%    \
nnn/%        \
nvim/%       \
rofi/%       \
zathura/%    \
direnv/%     \
sc-im/%      \
:
	mkdir -p $(workspace)/.config/$(@D)
	ln -fs $(dotfiles)/$@ $(workspace)/.config/$@

# CONFIGS
inputrc: shells/inputrc

profile: shells/profile

bash: inputrc $(wildcard shells/bash*)

zsh: inputrc $(wildcard shells/zsh*)

tmux: inputrc $(wildcard shells/tmux*)

jupyter: $(wildcard jupyter/*)
	mkdir -p $(workspace)/.local/share/jupyter/kernels

# find files in the listed directories
.SECONDEXPANSION:
alacritty \
bin       \
ctags     \
editorconfig \
emacs     \
git       \
gtk       \
ipython   \
julia     \
kitty     \
nix       \
nnn       \
nvim      \
r         \
rofi      \
latexmk   \
vim       \
zathura   \
direnv    \
sc-im     \
wezterm   \
: %: $$(shell find % -type f)
