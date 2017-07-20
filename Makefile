# Download or update and install various tools

# Global prefix and directories
PREFIX = $(PWD)/test
DOWNLOADS = $(PWD)/downloads

#include src/tmux.mk
include src/nvim.mk

.PHONY: all
all: nvim-install

.PHONY: clean
clean:
	git clean -xdff $(PWD)

