dotfiles := $(shell pwd)

all: vim tmux bash octave python

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

python:
	mkdir -p ${HOME}/.ipython/profile_default
	ln -fs $(dotfiles)/ipython_config.py ${HOME}/.ipython/profile_default/ipython_config.py

eclim:
	ln -fs $(dotfiles)/eclimrc ${HOME}/.eclimrc

