# Required for python neovim client
PIP = pip3.6

# Autotools 
AUTOCONF_URL = https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
AUTOCONF_DIR = $(BUILD)/autoconf
AUTOCONF_TARGET = $(AUTOCONF_DIR)/bin/autoconf

# Nvim python client
PYNVIM_TARGET = $(wildcard $(PREFIX)/lib/python*/site-packages/neovim)

# Git repository URL for nvim
NVIM_GIT = https://github.com/neovim/neovim.git
NVIM_DIR = $(BUILD)/nvim-git
NVIM_TARGET = $(PREFIX)/bin/nvim
NVIM_DEPS = $(AUTOCONF_TARGET) #$(PY2NVIM_TARGET) $(PY3NVIM_TARGET)

# -- Install
.PHONY: nvim-install
nvim-install: $(NVIM_TARGET)

# -- autoconf
$(DOWNLOADS)/autoconf.tar.gz:
	mkdir -p $(DOWNLOADS) && wget $(AUTOCONF_URL) -O $@

$(AUTOCONF_DIR)/configure: $(DOWNLOADS)/autoconf.tar.gz
	mkdir -p $(AUTOCONF_DIR) && \
		cd $(AUTOCONF_DIR) && \
		tar -xf $< --strip-components 1
	touch $@

$(AUTOCONF_DIR)/Makefile: $(AUTOCONF_DIR)/configure
	cd $(AUTOCONF_DIR) && ./configure

$(AUTOCONF_TARGET): $(AUTOCONF_DIR)/Makefile
	cd $(AUTOCONF_DIR) && $(MAKE)

# -- python client
$(PYNVIM_TARGET):
	export PYTHONUSERBASE=$(PREFIX) && \
		export PYTHONPATH=$(PREFIX)/lib:$(PYTHONPATH) && \
		$(PIP) install -U neovim --user

# -- nvim
$(NVIM_DIR)/Makefile:
	git clone $(NVIM_GIT) $(NVIM_DIR)

$(NVIM_DIR)/build/bin/nvim: $(NVIM_DIR)/Makefile $(NVIM_DEPS)
	export PATH="$(AUTOCONF_DIR)/bin:$(PATH)" && \
		cd $(NVIM_DIR) && \
		$(MAKE) \
			MAKE_BUILD_TYPE=Release \
			CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$(PREFIX)"
	  touch $@

$(NVIM_TARGET): $(NVIM_DIR)/build/bin/nvim
	cd $(NVIM_DIR) && $(MAKE) install && touch $@

# -- git related phony things
.PHONY: nvim-clean
nvim-clean: $(NVIM_DIR)/autogen.sh
	cd $(NVIM_DIR) && git clean -xfdq && git reset --hard master

.PHONY: nvim-update
nvim-update: nvim-clean $(NVIM_DIR)/autogen.sh
	cd $(NVIM_DIR) && git fetch origin
	cd $(NVIM_DIR) && git reset --hard origin/master
	$(MAKE) $(NVIM_TARGET)

.PHONY: nvim-reset
nvim-reset: nvim-clean $(NVIM_DIR)/autogen.sh
	cd $(NVIM_DIR) && git reset --hard origin/HEAD~
	$(MAKE) $(NVIM_TARGET)

