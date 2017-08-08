# URL for ncurses
NCURSES_URL = ftp://ftp.gnu.org/gnu/ncurses/ncurses-6.0.tar.gz
NCURSES_DIR = $(BUILD)/ncurses-src
NCURSES_TARGET = $(PREFIX)/lib/libncurses.a

# URL of libevent
LIBEVENT_URL = https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
LIBEVENT_DIR = $(BUILD)/libevent-src
LIBEVENT_TARGET = $(PREFIX)/lib/libevent.a

# Git repository URL for tmux
TMUX_GIT = https://github.com/tmux/tmux.git
TMUX_DIR = $(BUILD)/tmux-git
TMUX_DEPS = $(LIBEVENT_TARGET) $(NCURSES_TARGET)
TMUX_TARGET = $(PREFIX)/bin/tmux

# -- Install
.PHONY: tmux-install
tmux-install: $(TMUX_TARGET)

# -- libevent
$(DOWNLOADS)/libevent.tar.gz:
	mkdir -p $(DOWNLOADS) && wget $(LIBEVENT_URL) -O $@

$(LIBEVENT_DIR)/configure: $(DOWNLOADS)/libevent.tar.gz
	mkdir -p $(LIBEVENT_DIR) && tar xf $^ --strip-components 1 -C $(LIBEVENT_DIR) && touch $@

$(LIBEVENT_DIR)/Makefile: $(LIBEVENT_DIR)/configure
	cd $(LIBEVENT_DIR) && ./configure --prefix=$(PREFIX) --disable-shared

$(LIBEVENT_TARGET): $(LIBEVENT_DIR)/Makefile
	cd $(LIBEVENT_DIR) && $(MAKE) && $(MAKE) install

# -- ncurses
$(DOWNLOADS)/ncurses.tar.gz:
	mkdir -p $(DOWNLOADS) && wget $(NCURSES_URL) -O $@

$(NCURSES_DIR)/configure: $(DOWNLOADS)/ncurses.tar.gz
	mkdir -p $(NCURSES_DIR) && tar xf $^ --strip-components 1 -C $(NCURSES_DIR) && touch $@

$(NCURSES_DIR)/Makefile: $(NCURSES_DIR)/configure
	cd $(NCURSES_DIR) && ./configure --prefix=$(PREFIX)

$(NCURSES_TARGET): $(NCURSES_DIR)/Makefile
	cd $(NCURSES_DIR) && $(MAKE) && $(MAKE) install

# -- tmux
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

# -- git related phony things
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

