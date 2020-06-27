dotfiles := $(shell pwd)
workspace := ${HOME}

.PHONY: all

osx:
	sh $(dotfiles)/osx

vim:
	ln -fs $(dotfiles)/vimrc ${workspace}/.vimrc
	mkdir -p ${workspace}/.config/nvim/
	ln -fs $(dotfiles)/init.vim ${workspace}/.config/nvim/init.vim

tmux:
	ln -fs $(dotfiles)/tmux.conf ${workspace}/.tmux.conf

bash:
	ln -fs $(dotfiles)/inputrc ${workspace}/.inputrc
	ln -fs $(dotfiles)/bash_profile ${workspace}/.bash_profile
	ln -fs $(dotfiles)/bashrc ${workspace}/.bashrc

zsh:
	ln -fs $(dotfiles)/zshrc ${workspace}/.zshrc

jupyter:
	mkdir -p ${workspace}/.jupyter/
	ln -fs $(dotfiles)/jupyter_console_config.py ${workspace}/.jupyter/jupyter_console_config.py

python:
	mkdir -p ${workspace}/.config/matplotlib
	ln -fs ${dotfiles}/matplotlibrc ${workspace}/.config/matplotlib/matplotlibrc

eclim:
	ln -fs $(dotfiles)/eclimrc ${workspace}/.eclimrc

git:
	ln -fs $(dotfiles)/gitconfig ${workspace}/.gitconfig

r:
	ln -fs $(dotfiles)/Rprofile ${workspace}/.Rprofile

ctags:
	ln -fs $(dotfiles)/ctags ${workspace}/.ctags

zathura:
	mkdir -p ${workspace}/.config/zathura
	ln -fs $(dotfiles)/zathurarc ${workspace}/.config/zathura/zathurarc

alacritty:
	mkdir -p ${workspace}/.config/alacritty/
	ln -fs $(dotfiles)/alacritty.yml ${workspace}/.config/alacritty/alacritty.yml
