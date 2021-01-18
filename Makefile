EXCLUSIONS := .DS_Store .git .gitmodules
CANDIDATES := $(wildcard .??*)
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))
DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

deploy:
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	@sudo cp -r fonts/* /usr/share/fonts/opentype
	@ln -sfnv $(abspath autostart) $(HOME)/.config/

init:
	@sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

ubuntu-setup:
	@./ubuntu-setup.sh

