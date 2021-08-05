files := \
		 $(wildcard home/.config/nvim/**/*) \
		 $(wildcard home/.config/nvim/*)

install//home/%: home/%
	@ bash .install/copy.sh "$<" "${HOME}/$*"

_install: $(patsubst %,install//%,$(files))
	@ [ -e "$$HOME/.vimrc" ] || ln -s ".config/nvim/init.vim" "$$HOME/.vimrc"
	@ [ -e "$$HOME/.vim" ]   || {\
	      mkdir "$$HOME/.vim";\
		  ln -s "../.config/nvim/autoload" "$$HOME/.vim/";\
		  ln -s "../.config/nvim/plugged" "$$HOME/.vim/";\
	  }

.PHONY: _requirements_mac
_requirements_mac:
	@ echo "Installing nvim requirements..."
	@ command -v nvim &>/dev/null || {\
	      echo " - nvim";\
		  brew install nvim;\
	  }
	@ [ -f "$${HOME}/.config/nvim/autoload/plug.vim" ] || {\
		  echo " - nvim plugins";\
		  curl -sfLo ~/.config/nvim/autoload/plug.vim --create-dirs 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim';\
	      restore=false;\
		  if [ -f "$${HOME}/.config/nvim/init.vim" ]; then\
	          restore=true;\
		      mv "$${HOME}/.config/nvim/init.vim" "$${HOME}/.config/nvim/init.vim.OLD_TEMP";\
	      fi;\
	      bash .install/copy.sh home/.config/nvim/init.vim "$${HOME}/.config/nvim/init.vim" >/dev/null;\
	      nvim +'PlugInstall --sync' +qa &>/dev/null;\
		  if $$restore; then\
		      mv "$${HOME}/.config/nvim/init.vim.OLD_TEMP" "$${HOME}/.config/nvim/init.vim";\
		  fi;\
	  }

_requirements_%:
	@ echo "No process for installing nvim requiements on $*"
	@ exit 1

