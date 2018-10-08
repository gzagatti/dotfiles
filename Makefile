dotfiles := $(shell pwd)
workspace := ${HOME}

all: vim tmux bash jupyter git r python ctags

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

jupyter:
	mkdir -p ${workspace}/.jupyter/
	ln -fs $(dotfiles)/jupyter_console_config.py ${workspace}/.jupyter/jupyter_console_config.py

python:
	mkdir -p ${workspace}/.ipython/profile_default
	ln -fs $(dotfiles)/ipython_config.py ${workspace}/.ipython/profile_default
	mkdir -p ${workspace}/.matplotlib
	ln -fs ${dotfiles}/matplotlibrc ${workspace}/.matplotlib/matplotlibrc

eclim:
	ln -fs $(dotfiles)/eclimrc ${workspace}/.eclimrc

ruby:
	ln -fs $(dotfiles)/irbrc ${workspace}/.irbrc

git:
	ln -fs $(dotfiles)/gitconfig ${workspace}/.gitconfig

r:
	ln -fs $(dotfiles)/Rprofile ${workspace}/.Rprofile

ctags:
	ln -fs $(dotfiles)/ctags ${workspace}/.ctags
