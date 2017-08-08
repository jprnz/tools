TMUX_GIT = https://github.com/tmux/tmux.git
TMUX_DIR = $(BUILD)/tmux-git
TMUX_DEPS = $(LIBEVENT_TARGET) $(NCURSES_TARGET)
TMUX_TARGET = $(PREFIX)/bin/tmux

.PHONY: tmux-install
tmux-install: $(TMUX_TARGET)

$(TMUX_DIR)/autogen.sh:
	git clone $(TMUX_GIT) $(TMUX_DIR)

$(TMUX_DIR)/configure: $(TMUX_DIR)/autogen.sh
	cd $(TMUX_DIR) && ./autogen.sh

$(TMUX_DIR)/Makefile: $(TMUX_DIR)/configure $(TMUX_DEPS)
	cd $(TMUX_DIR) && ./configure \
		CFLAGS="-I$(PREFIX)/include -I$(PREFIX)/include/ncurses" \
		LDFLAGS="-L$(PREFIX)/lib -L$(PREFIX)/include/ncurses -L$(PREFIX)/include" \
		CPPFLAGS="-I$(PREFIX)/include -I$(PREFIX)/include/ncurses" \
		LDFLAGS="-L$(PREFIX)/include -L$(PREFIX)/include/ncurses -L$(PREFIX)/lib"

$(TMUX_DIR)/tmux: $(TMUX_DIR)/Makefile
	cd $(TMUX_DIR) && $(MAKE)

$(TMUX_TARGET): $(TMUX_DIR)/tmux
	cp $(TMUX_DIR)/tmux $(TMUX_TARGET)

# Git related phony things
.PHONY: tmux-clean
tmux-clean: $(TMUX_DIR)/autogen.sh
	cd $(TMUX_DIR) && git clean -xfdq

.PHONY: tmux-update
tmux-update: tmux-clean $(TMUX_DIR)/autogen.sh
	cd $(TMUX_DIR) && git fetch origin
	cd $(TMUX_DIR) && git reset --hard origin/master
	$(MAKE) $(TMUX_TARGET)

.PHONY: tmux-reset
tmux-reset: tmux-clean $(TMUX_DIR)/autogen.sh
	cd $(TMUX_DIR) && git reset --hard origin/HEAD~
	$(MAKE) $(TMUX_TARGET)

