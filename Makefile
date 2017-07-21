# Download or update and install various tools

# Global prefix and directories
PREFIX = $(PWD)/test
DOWNLOADS = $(PWD)/downloads

# Required for python neovim client
PIP2=pip2.7
PIP3=pip3.6

#include src/tmux.mk
include src/nvim.mk

.PHONY: all
all: nvim-install

.PHONY: clean
clean:
	git clean -xdff $(PWD)

