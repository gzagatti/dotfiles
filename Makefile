dotfiles := $(shell pwd)

all: vim tmux bash octave jupyter git

sh:
	sh $(dotfiles)/osx

vim:
	ln -fs $(dotfiles)/vimrc ${HOME}/.vimrc

tmux:
	ln -fs $(dotfiles)/tmux.conf ${HOME}/.tmux.conf

bash:
	ln -fs $(dotfiles)/inputrc ${HOME}/.inputrc
	ln -fs $(dotfiles)/bash_profile ${HOME}/.bash_profile
	ln -fs $(dotfiles)/bashrc ${HOME}/.bashrc

octave:
	ln -fs $(dotfiles)/octaverc ${HOME}/.octaverc

jupyter:
	mkdir -p ${HOME}/.jupyter/
	ln -fs $(dotfiles)/jupyter_console_config.py ${HOME}/.jupyter/jupyter_console_config.py

eclim:
	ln -fs $(dotfiles)/eclimrc ${HOME}/.eclimrc

ruby:
	ln -fs $(dotfiles)/irbrc ${HOME}/.irbrc

git:
	ln -fs $(dotfiles)/gitconfig ${HOME}/.gitconfig
