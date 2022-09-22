EXCLUSIONS := .DS_Store .git .gitmodules .vscode .config
CANDIDATES := $(wildcard .??*)
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))
DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
DOTCONFIGS := $(wildcard .config/*)

deploy:
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	@$(foreach val, $(DOTCONFIGS), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	@sudo cp -r fonts/* /usr/share/fonts/opentype

init:
	@bash -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

ubuntu-setup:
	@./ubuntu-setup.sh
