# Git repository URL for ag
AG_GIT = https://github.com/neovim/neovim.git
AG_DIR = ag-git
AG_TARGET = $(PREFIX)/bin/ag

PCRE_URL = ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre2-10.23.tar.gz
PCRE_DIR = pcre
PCRE_TARGET = $(PREFIX)/bin/pcre2grep

# -- Install
.PHONY: ag-install
ag-install: $(AG_TARGET)

# -- pcre
$(PCRE_DIR)/
# -- pcre

# -- ag
$(AG_DIR)/autogen.sh
	git clone $(AG_GIT) $(AG_DIR)

$(AG_DIR)/configure: $(AG_DIR)/autogen.sh
	cd $(AG_DIR) && ./autogen.sh

$(AG_DIR)/Makefile: $(AG_DIR)/configure
	cd $(AG_DIR) && ./configure

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

