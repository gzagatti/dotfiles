dotfiles := $(shell pwd)

all: vim tmux bash

vim:
	ln -fs $(dotfiles)/vimrc ${HOME}/.vimrc

tmux:
	ln -fs $(dotfiles)/tmux.conf ${HOME}/.tmux.conf

bash:
	ln -fs $(dotfiles)/inputrc ${HOME}/.inputrc
	ln -fs $(dotfiles)/bash_profile ${HOME}/.bash_profile
	ln -fs $(dotfiles)/bashrc ${HOME}/.bashrc
