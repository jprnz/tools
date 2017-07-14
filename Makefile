# Download or update and install various tools

# Global prefix
PREFIX = $(HOME)/local
DOWNLOADS = $(PWD)/downloads

include src/tmux.mk

.PHONY: all
all: tmux-install

.PHONY: clean
clean:
	git clean -xdff $(PWD)

