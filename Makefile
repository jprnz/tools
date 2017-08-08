# Download or update and install various tools

# Global prefix and directories
PREFIX = $(PWD)/test
BUILD = $(PWD)/build
DOWNLOADS = $(BUILD)/downloads

.PHONY: all
all: \
	tmux-install \
	ag-install \
	#nvim-install 

.PHONY: clean
clean:
	git clean -xdff $(PWD)

include src/tmux.mk
include src/ag.mk
#include src/nvim.mk

