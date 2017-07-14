# URL for ncurses
NCURSES_URL = ftp://ftp.gnu.org/gnu/ncurses/ncurses-6.0.tar.gz
NCURSES_TARGET = $(PREFIX)/lib/libncurses.a

# URL of libevent
LIBEVENT_URL = https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
LIBEVENT_TARGET = $(PREFIX)/lib/libevent.a

# Git repository URL for tmux
TMUX_GIT = https://github.com/tmux/tmux.git
TMUX_DEPS = $(LIBEVENT_TARGET) $(NCURSES_TARGET)
TMUX_TARGET = $(PREFIX)/bin/tmux

# -- Install
.PHONY: tmux-install
tmux-install: $(TMUX_TARGET)

# -- libevent
$(DOWNLOADS)/libevent.tar.gz:
	mkdir -p $(DOWNLOADS) && wget $(LIBEVENT_URL) -O $@

libevent/configure: $(DOWNLOADS)/libevent.tar.gz
	mkdir -p libevent && tar xf $^ --strip-components 1 -C libevent && touch $@

libevent/Makefile: libevent/configure
	cd libevent && ./configure --prefix=$(PREFIX) --disable-shared

$(LIBEVENT_TARGET): libevent/Makefile
	cd libevent && $(MAKE) && $(MAKE) install

# -- ncurses
$(DOWNLOADS)/ncurses.tar.gz:
	mkdir -p $(DOWNLOADS) && wget $(NCURSES_URL) -O $@

ncurses/configure: $(DOWNLOADS)/ncurses.tar.gz
	mkdir -p ncurses && tar xf $^ --strip-components 1 -C ncurses && touch $@

ncurses/Makefile: ncurses/configure
	cd ncurses && ./configure --prefix=$(PREFIX)

$(NCURSES_TARGET): ncurses/Makefile
	cd ncurses && $(MAKE) && $(MAKE) install

# -- tmux
tmux-git/autogen.sh:
	git clone $(TMUX_GIT) tmux-git

tmux-git/configure: tmux-git/autogen.sh
	cd tmux-git && ./autogen.sh

tmux-git/Makefile: tmux-git/configure $(TMUX_DEPS)
	cd tmux-git && ./configure \
		CFLAGS="-I$(PREFIX)/include -I$(PREFIX)/include/ncurses" \
		LDFLAGS="-L$(PREFIX)/lib -L$(PREFIX)/include/ncurses -L$(PREFIX)/include" \
		CPPFLAGS="-I$(PREFIX)/include -I$(PREFIX)/include/ncurses" \
		LDFLAGS="-L$(PREFIX)/include -L$(PREFIX)/include/ncurses -L$(PREFIX)/lib"

tmux-git/tmux: tmux-git/Makefile
	cd tmux-git && $(MAKE)

$(TMUX_TARGET): tmux-git/tmux
	cp tmux-git/tmux $(TMUX_TARGET)

# -- git related phony things
.PHONY: tmux-clean
tmux-clean: tmux-git/autogen.sh
	cd tmux-git && git clean -xfdq

.PHONY: tmux-update
tmux-update: tmux-clean tmux-git/autogen.sh
	cd tmux-git && git fetch origin
	cd tmux-git && git reset --hard origin/master
	$(MAKE) $(TMUX_TARGET)

.PHONY: tmux-reset
tmux-reset: tmux-clean tmux-git/autogen.sh
	cd tmux-git && git reset --hard origin/HEAD~
	$(MAKE) $(TMUX_TARGET)

