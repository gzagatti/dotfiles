dotfiles := $(shell pwd)
workspace := $(HOME)

.PHONY: all

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

# NIX
nixfiles := $(shell find nix -type f -printf "$(workspace)/.config/%P\n")

nix: $(nixfiles)

$(nixfiles): $(workspace)/.config/%: nix/%
	mkdir -p $(dir $@)
	ln -fs $(dotfiles)/$^ $@

# NVIM
nvimfiles := $(shell find nvim -type f -printf "$(workspace)/.config/%p\n")

nvim: $(nvimfiles)

$(nvimfiles): $(workspace)/.config/%: %
	mkdir -p $(dir $@)
	ln -fs $(dotfiles)/$^ $@

# EMACS
emacsfiles := $(shell find emacs -type f -printf "$(workspace)/.emacs.d/%p\n")

emacs: $(emacsfiles)

$(emacsfiles): $(workspace)/.emacs.d/%: %
	mkdir -p $(dir $@)
	ln -fs $(dotfiles)/$^ $@

# KITTY
kittyfiles := $(shell find kitty -type f -printf "$(workspace)/.config/%p\n")

kitty: $(kittyfiles)

$(kittyfiles): $(workspace)/.config/%: %
	mkdir -p $(dir $@)
	ln -fs $(dotfiles)/$^ $@

# ROFI
rofifiles := $(shell find rofi -type f -printf "$(workspace)/.config/%p\n")

rofi: $(rofifiles)

$(rofifiles): $(workspace)/.config/%: %
	mkdir -p $(dir $@)
	ln -fs $(dotfiles)/$^ $@

# NNN
nnnfiles := $(shell find nnn -type f -printf "$(workspace)/.config/%p\n")

nnn: $(nnnfiles)

$(nnnfiles): $(workspace)/.config/%: %
	mkdir -p $(dir $@)
	ln -fs $(dotfiles)/$^ $@

# BINARIES
binfiles := $(shell find bin -type f -printf "$(workspace)/.local/%p\n")

bin: $(binfiles)

$(binfiles): $(workspace)/.local/%: %
	mkdir -p $(dir $@)
	ln -fs $(dotfiles)/$^ $@


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
