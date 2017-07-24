# Download or update and install various tools

# Global prefix and directories
PREFIX = $(HOME)/local
DOWNLOADS = $(PWD)/downloads

# Required for python neovim client
PIP2 = pip2.7
PIP3 = pip3.6

.PHONY: all
all: nvim-install tmux-install

.PHONY: clean
clean:
	git clean -xdff $(PWD)

include src/tmux.mk
include src/nvim.mk

