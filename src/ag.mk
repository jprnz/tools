AG_GIT = https://github.com/ggreer/the_silver_searcher.git
AG_DIR = $(BUILD)/ag-git
AG_TARGET = $(PREFIX)/bin/ag
AG_DEPS = $(PCRE_TARGET) $(XZ_TARGET)

.PHONY: pcre-install
ag-install: $(PCRE_TARGET)

$(AG_DIR)/autogen.sh:
	git clone $(AG_GIT) $(AG_DIR)

$(AG_DIR)/configure: $(AG_DIR)/autogen.sh
	cd $(AG_DIR) && ./autogen.sh

$(AG_DIR)/Makefile: $(AG_DIR)/configure $(AG_DEPS)
	export PKG_CONFIG_PATH=$(PREFIX)/lib/pkgconfig && \
	export LD_LIBRARY_PATH=$(PREFIX)/lib && \
	export CFLAGS="-I$(PREFIX)/include -I$(PREFIX)/lzma" && \
		cd $(AG_DIR) && ./configure prefix=$(PREFIX) && touch Makefile

$(AG_TARGET): $(AG_DIR)/Makefile
	cd $(AG_DIR) && $(MAKE) && $(MAKE) install && touch $@

# Git related things
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

