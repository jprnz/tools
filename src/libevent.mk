LIBEVENT_URL = https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
LIBEVENT_DIR = $(BUILD)/libevent-src
LIBEVENT_TARGET = $(PREFIX)/lib/libevent.a

.PHONY: libevent-install
libevent-install: $(LIBEVENT_TARGET)

$(DOWNLOADS)/libevent.tar.gz:
	mkdir -p $(DOWNLOADS) && wget $(LIBEVENT_URL) -O $@

$(LIBEVENT_DIR)/configure: $(DOWNLOADS)/libevent.tar.gz
	mkdir -p $(LIBEVENT_DIR) && tar xf $^ --strip-components 1 -C $(LIBEVENT_DIR) && touch $@

$(LIBEVENT_DIR)/Makefile: $(LIBEVENT_DIR)/configure
	cd $(LIBEVENT_DIR) && ./configure --prefix=$(PREFIX) --disable-shared

$(LIBEVENT_TARGET): $(LIBEVENT_DIR)/Makefile
	cd $(LIBEVENT_DIR) && $(MAKE) && $(MAKE) install

