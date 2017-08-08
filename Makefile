# Download or update and install various tools

# Global prefix and directories
PREFIX = $(HOME)/local
DOWNLOADS = $(PWD)/downloads

.PHONY: all
all: tmux-install ag-install

.PHONY: clean
clean:
	git clean -xdff $(PWD)

include src/tmux.mk
include src/ag.mk

