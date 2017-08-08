NCURSES_URL = ftp://ftp.gnu.org/gnu/ncurses/ncurses-6.0.tar.gz
NCURSES_DIR = $(BUILD)/ncurses-src
NCURSES_TARGET = $(PREFIX)/lib/libncurses.a

.PHONY: ncurses-install
ncurses-install: $(NCURSES_TARGET)

$(DOWNLOADS)/ncurses.tar.gz:
	mkdir -p $(DOWNLOADS) && wget $(NCURSES_URL) -O $@

$(NCURSES_DIR)/configure: $(DOWNLOADS)/ncurses.tar.gz
	mkdir -p $(NCURSES_DIR) && tar xf $^ --strip-components 1 -C $(NCURSES_DIR) && touch $@

$(NCURSES_DIR)/Makefile: $(NCURSES_DIR)/configure
	cd $(NCURSES_DIR) && ./configure --prefix=$(PREFIX)

$(NCURSES_TARGET): $(NCURSES_DIR)/Makefile
	cd $(NCURSES_DIR) && $(MAKE) && $(MAKE) install

