dotfiles := $(shell pwd)
workspace := $(HOME)

.PHONY: all

shells: bash zsh tmux

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

julia/%:
	mkdir -p $(workspace)/.julia/config
	ln -fs $(dotfiles)/$@ $(workspace)/.julia/config/$(@F)

jupyter/%:
	mkdir -p $(workspace)/.jupyter
	ln -fs $(dotfiles)/$@ $(workspace)/.jupyter/$(@F)

nix/%:
	mkdir -p $(workspace)/$(@D:nix/%=%)
	ln -fs $(dotfiles)/$@ $(workspace)/.config/$(@:nix/%=%)

texlive/%:
	mkdir -p $(workspace)/.config/latexmk
	ln -fs $(dotfiles)/$@ $(workspace)/.config/latexmk/$(@F)

ctags/%   \
git/%     \
r/%       \
shells/%  \
vim/%     \
:
	ln -fs $(dotfiles)/$@ $(workspace)/.$(@F)

alacritty/%  \
kitty/%      \
nnn/%        \
nvim/%       \
rofi/%       \
zathura/%    \
:
	mkdir -p $(workspace)/.config/$(@D)
	ln -fs $(dotfiles)/$@ $(workspace)/.config/$@

# CONFIGS
inputrc: shells/inputrc

bash: inputrc $(wildcard shells/bash*)

zsh: inputrc $(wildcard shells/zsh*)

tmux: inputrc $(wildcard shells/tmux*)

jupyter: $(wildcard jupyter/*)
	mkdir -p $(workspace)/.local/share/jupyter/kernels

.SECONDEXPANSION:
alacritty \
bin       \
ctags     \
emacs     \
git       \
gtk       \
julia     \
kitty     \
nix       \
nnn       \
nvim      \
r         \
rofi      \
texlive   \
vim       \
zathura   \
: %: $$(shell find % -type f)
