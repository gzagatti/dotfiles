dotfiles := $(shell pwd)
workspace := $(HOME)

.PHONY: all

# NIX
$(workspace)/.config/nixpkgs:
	mkdir -p $@

nix/%: $(workspace)/.config/nixpkgs
	ln -fs $(dotfiles)/$@ $</$*

nix: $(shell find nix -type f)

# SHELLS
inputrc:
	ln -fs $(dotfiles)/shells/inputrc $(workspace)/.inputrc

bash: inputrc
	ln -fs $(dotfiles)/shells/bash_profile $(workspace)/.bash_profile
	ln -fs $(dotfiles)/shells/bashrc $(workspace)/.bashrc

zsh: inputrc
	ln -fs $(dotfiles)/shells/zshrc $(workspace)/.zshrc

tmux:
	ln -fs $(dotfiles)/shells/tmux.conf $(workspace)/.tmux.conf

shells: bash zsh tmux

# NVIM
$(workspace)/.config/nvim:
	mkdir -p $@

$(workspace)/.config/nvim/vsnip: $(workspace)/.config/nvim
	mkdir -p $@

nvim/%: $(workspace)/.config/nvim/vsnip
	ln -fs $(dotfiles)/$@ $(workspace)/.config/$@

nvim: $(shell find nvim -type f)


# EMACS
$(workspace)/.emacs.d:
	mkdir -p $@

emacs/%: $(workspace)/.emacs.d
	ln -fs $(dotfiles)/$@ $</$*

emacs: $(shell find emacs -type f)


# KITTY
$(workspace)/.config/kitty/themes:
	mkdir -p $@

kitty/%: $(workspace)/.config/kitty/themes
	ln -fs $(dotfiles)/$@ $(workspace)/.config/$@

kitty: $(shell find kitty -type f)


# ROFI
$(workspace)/.config/rofi:
	mkdir -p $@

rofi/%: $(workspace)/.config/rofi
	ln -fs $(dotfiles)/$@ $</$*

rofi: $(shell find rofi -type f)

# NNN
$(workspace)/.config/nnn/plugins:
	mkdir -p $@

nnn/%: $(workspace)/.config/nnn/plugins
	ln -fs $(dotfiles)/$@ $(workspace)/.config/$@

nnn: $(shell find nnn -type f)

# BINARIES
$(workspace)/.local/bin:
	mkdir -p $@

bin/%: $(workspace)/.local/bin
	ln -fs $(dotfiles)/$@ $(workspace)/.local/$@

bin: $(wildcard bin/*)

# SINGLE FILE CONFIGS
alacritty:
	mkdir -p $(workspace)/.config/alacritty/
	ln -fs $(dotfiles)/singles/alacritty.yml $(workspace)/.config/alacritty/alacritty.yml

ctags:
	ln -fs $(dotfiles)/singles/ctags $(workspace)/.ctags

git:
	ln -fs $(dotfiles)/singles/gitconfig $(workspace)/.gitconfig

julia:
	mkdir -p $(workspace)/.julia/config/
	ln -fs $(dotfiles)/singles/startup.jl $(workspace)/.julia/config

jupyter:
	mkdir -p $(workspace)/.local/share/jupyter/kernels
	ln -fs $(dotfiles)/singles/jupyter_console_config.py $(workspace)/.jupyter/jupyter_console_config.py

r:
	ln -fs $(dotfiles)/singles/Rprofile $(workspace)/.Rprofile

texlive:
	mkdir -p $(workspace)/.config/latexmk
	ln -fs $(dotfiles)/singles/latexmkrc $(workspace)/.config/latexmk/latexmkrc

vim:
	ln -fs $(dotfiles)/singles/vimrc $(workspace)/.vimrc

zathura:
	mkdir -p $(workspace)/.config/zathura
	ln -fs $(dotfiles)/singles/zathurarc $(workspace)/.config/zathura/zathurarc

gtk:
	mkdir -p $(workspace)/.config/gtk-3.0
	mkdir -p $(workspace)/.config/gtk-4.0
	ln -fs $(dotfiles)/singles/gtk.css $(workspace)/.config/gtk-3.0/gtk.css
	ln -fs $(dotfiles)/singles/gtk.css $(workspace)/.config/gtk-4.0/gtk.css
