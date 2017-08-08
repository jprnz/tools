# PCRE Requirements
PCRE_URL = ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.41.tar.gz
PCRE_DIR = pcre_src
PCRE_TARGET = $(PREFIX)/lib/libpcre.so

# LZMA
XZ_URL = https://tukaani.org/xz/xz-5.2.3.tar.gz
XZ_DIR = lzma_src
XZ_TARGET = $(PREFIX)/lib/liblzma.so

# Git repository URL for ag
AG_GIT = https://github.com/ggreer/the_silver_searcher.git
AG_DIR = ag-git
AG_TARGET = $(PREFIX)/bin/ag
AG_DEPS = $(PCRE_TARGET)

# -- Install
.PHONY: ag-install
ag-install: $(AG_TARGET)

# -- pcre
$(DOWNLOADS)/pcre.tar.gz:
	mkdir -p $(DOWNLOADS) && wget $(PCRE_URL) -O $@

$(PCRE_DIR)/configure: $(DOWNLOADS)/pcre.tar.gz
	mkdir -p $(PCRE_DIR) && tar xf $^ --strip-components 1 -C $(PCRE_DIR) && touch $@

$(PCRE_DIR)/Makefile: $(PCRE_DIR)/configure
	cd $(PCRE_DIR) && ./configure --prefix=$(PREFIX)

$(PCRE_TARGET): $(PCRE_DIR)/Makefile
	cd $(PCRE_DIR) && $(MAKE) && $(MAKE) install

# -- XZ
$(DOWNLOADS)/.tar.gz:
	mkdir -p $(DOWNLOADS) && wget $(XZ_URL) -O $@

$(XZ_DIR)/configure: $(DOWNLOADS)/pcre.tar.gz
	mkdir -p $(XZ_DIR) && tar xf $^ --strip-components 1 -C $(XZ_DIR) && touch $@

$(XZ_DIR)/Makefile: $(XZ_DIR)/configure
	cd $(XZ_DIR) && ./configure --prefix=$(PREFIX)

$(PCRE_TARGET): $(XZ_DIR)/Makefile
	cd $(XZ_DIR) && $(MAKE) && $(MAKE) install
	
# -- ag
$(AG_DIR)/autogen.sh:
	git clone $(AG_GIT) $(AG_DIR)

$(AG_DIR)/configure: $(AG_DIR)/autogen.sh
	cd $(AG_DIR) && ./autogen.sh

$(AG_DIR)/Makefile: $(AG_DIR)/configure $(AG_DEPS)
	export PKG_CONFIG_DIR$(PREFIX)/lib/pkgconfig:$(PKG_CONFIG_DIR) && \
		cd $(AG_DIR) && ./configure prefix=$(PREFIX)

$(AG_TARGET): $(AG_DIR)/Makefile
	cd $(AG_DIR) && $(MAKE)

# -- git related phony things
.PHONY: ag-clean
ag-clean: $(AG_DIR)/autogen.sh
	cd $(AG_DIR) && git clean -xfdq && git reset --hard master

.PHONY: ag-update
ag-update: ag-clean $(AG_DIR)/autogen.sh
	cd $(AG_DIR) && git fetch origin
	cd $(AG_DIR) && git reset --hard origin/master
	$(MAKE) $(NVIM_TARGET)

.PHONY: ag-reset
ag-reset: ag-clean $(AG_DIR)/autogen.sh
	cd $(AG_DIR) && git reset --hard origin/HEAD~
	$(MAKE) $(NVIM_TARGET)

