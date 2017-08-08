XZ_URL = https://tukaani.org/xz/xz-5.2.3.tar.gz
XZ_DIR = $(BUILD)/xz-src
XZ_TARGET = $(PREFIX)/lib/liblzma.so

.PHONY: xz-install
xz-install: $(XZ_TARGET)

$(DOWNLOADS)/xz.tar.gz:
	mkdir -p $(DOWNLOADS) && wget $(XZ_URL) -O $@

$(XZ_DIR)/configure: $(DOWNLOADS)/xz.tar.gz
	mkdir -p $(XZ_DIR) && tar xf $^ --strip-components 1 -C $(XZ_DIR) && touch $@

$(XZ_DIR)/Makefile: $(XZ_DIR)/configure
	cd $(XZ_DIR) && ./configure --prefix=$(PREFIX) && touch Makefile

$(XZ_TARGET): $(XZ_DIR)/Makefile
	cd $(XZ_DIR) && $(MAKE) && $(MAKE) install && touch $@
	
