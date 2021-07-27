files := \
		 $(wildcard home/.config/nvim/**/*) \
		 $(wildcard home/.config/nvim/*)

install//home/%: home/%
	@bash .install/copy.sh "$<" "${HOME}/$*"

_install: $(patsubst %,install//%,$(files))
	@ [ -e "$$HOME/.vim" ]   || ln -s ".config/nvim" "$$HOME/.vimrc"
	@ [ -e "$$HOME/.vimrc" ] || ln -s ".config/nvim/init.vim" "$$HOME/.vimrc"

