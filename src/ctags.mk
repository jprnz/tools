CTAGS_GIT = https://github.com/universal-ctags/ctags
CTAGS_DIR = $(BUILD)/ctags-git
CTAGS_TARGET = $(PREFIX)/bin/ctags

.PHONY: ctags-install
ctags-install: $(CTAGS_TARGET)

$(CTAGS_DIR)/autogen.sh:
	git clone $(CTAGS_GIT) $(CTAGS_DIR)

$(CTAGS_DIR)/configure: $(CTAGS_DIR)/autogen.sh
	cd $(CTAGS_DIR) && ./autogen.sh && touch $@

$(CTAGS_DIR)/Makefile: $(CTAGS_DIR)/configure $(CTAGS_DEPS)
	cd $(CTAGS_DIR) && ./configure --prefix=$(PREFIX) \
		--enable-etags \
		--enable-readlib && \
	touch Makefile

$(CTAGS_TARGET): $(CTAGS_DIR)/Makefile
	cd $(CTAGS_DIR) && $(MAKE) && $(MAKE) install && touch $@

# Git related phony things
.PHONY: ctags-clean
ctags-clean: $(CTAGS_DIR)/autogen.sh
	cd $(CTAGS_DIR) && git clean -xfdq

.PHONY: ctags-update
ctags-update: ctags-clean $(CTAGS_DIR)/autogen.sh
	cd $(CTAGS_DIR) && git fetch origin && \
	cd $(CTAGS_DIR) && git reset --hard origin/master

.PHONY: ctags-reset
ctags-reset: ctags-clean $(CTAGS_DIR)/autogen.sh
	cd $(CTAGS_DIR) && git reset --hard origin/HEAD~

