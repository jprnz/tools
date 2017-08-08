PCRE_URL = ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.41.tar.gz
PCRE_DIR = $(BUILD)/pcre-src
PCRE_TARGET = $(PREFIX)/lib/libpcre.so

.PHONY: pcre-install
pcre-install: $(PCRE_TARGET)

$(DOWNLOADS)/pcre.tar.gz:
	mkdir -p $(DOWNLOADS) && wget $(PCRE_URL) -O $@

$(PCRE_DIR)/configure: $(DOWNLOADS)/pcre.tar.gz
	mkdir -p $(PCRE_DIR) && tar xf $^ --strip-components 1 -C $(PCRE_DIR) && touch $@

$(PCRE_DIR)/Makefile: $(PCRE_DIR)/configure
	cd $(PCRE_DIR) && ./configure --prefix=$(PREFIX) && touch Makefile

$(PCRE_TARGET): $(PCRE_DIR)/Makefile
	cd $(PCRE_DIR) && $(MAKE) && $(MAKE) install && touch $@

