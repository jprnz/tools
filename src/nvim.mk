# Autotools 
AUTOCONF_URL = https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz 
AUTOCONF_DIR = $(DOWNLOADS)/autoconf
AUTOCONF_TARGET = $(AUTOCONF_DIR)/bin/autoconf

# Git repository URL for nvim
NVIM_GIT = https://github.com/nvim/nvim.git
NVIM_DEPS = $(AUTOCONF_TARGET)
NVIM_TARGET = $(PREFIX)/bin/nvim

# -- Install
.PHONY: nvim-install
nvim-install: $(NVIM_TARGET)

# -- autoconf
$(DOWNLOADS)/autoconf.tar.gz:
	wget $(AUTOCONF_URL) -O $@

$(AUTOCONF_DIR)/configure $(DOWNLOADS)/autoconf.tar.gz:
	mkdir -p $(AUTOCONF_DIR)
	tar xf $^ --strip-components 1 -c $(AUTOCONF_DIR)
	touch $@

$(AUTOCONF_DIR)/Makefile $(AUTOCONF_DIR)/configure:
	cd $(AUTOCONF_DIR) && ./configure

$(AUTOCONF_TARGET) $(AUTOCONF_DIR)/Makefile:
	cd $(AUTOCONF_DIR) && $(MAKE)

# -- nvim
nvim-git/Makefile:
	git clone $(NVIM_GIT) nvim-git

# -- git related phony things
.PHONY: nvim-clean
nvim-clean: nvim-git/autogen.sh
	cd nvim-git && git clean -xfdq && git reset --hard master

.PHONY: nvim-update
nvim-update: nvim-clean nvim-git/autogen.sh
	cd nvim-git && git fetch origin
	cd nvim-git && git reset --hard origin/master
	$(MAKE) $(NVIM_TARGET)

.PHONY: nvim-reset
nvim-reset: nvim-clean nvim-git/autogen.sh
	cd nvim-git && git reset --hard origin/HEAD~
	$(MAKE) $(NVIM_TARGET)

