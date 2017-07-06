dotfiles := $(shell pwd)
workspace := ${HOME}

all: vim tmux bash octave jupyter git

sh:
	sh $(dotfiles)/osx

vim:
	ln -fs $(dotfiles)/vimrc ${workspace}/.vimrc

tmux:
	ln -fs $(dotfiles)/tmux.conf ${workspace}/.tmux.conf

bash:
	ln -fs $(dotfiles)/inputrc ${workspace}/.inputrc
	ln -fs $(dotfiles)/bash_profile ${workspace}/.bash_profile
	ln -fs $(dotfiles)/bashrc ${workspace}/.bashrc

octave:
	ln -fs $(dotfiles)/octaverc ${workspace}/.octaverc

jupyter:
	mkdir -p ${workspace}/.jupyter/
	ln -fs $(dotfiles)/jupyter_console_config.py ${workspace}/.jupyter/jupyter_console_config.py

eclim:
	ln -fs $(dotfiles)/eclimrc ${workspace}/.eclimrc

ruby:
	ln -fs $(dotfiles)/irbrc ${workspace}/.irbrc

git:
	ln -fs $(dotfiles)/gitconfig ${workspace}/.gitconfig
