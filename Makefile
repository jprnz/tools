# Download or update and install various tools

# Global prefix and directories
PREFIX = $(HOME)/local
BUILD = $(PWD)/build
DOWNLOADS = $(BUILD)/downloads

.PHONY: all
all: \
	tmux-install \
	ag-install \
	ctags-install \
	#nvim-install 

.PHONY: clean
clean:
	git clean -xdff $(PWD)

include $(wildcard src/*.mk)

