files := \
		 $(wildcard home/.config/nvim/**/*) \
		 $(wildcard home/.config/nvim/*)

install//home/%: home/%
	@ bash .install/copy.sh "$<" "${HOME}/$*"

_install: $(patsubst %,install//%,$(files))
	@ [ -d "$$HOME/.config/nvim/autoload" ] || mkdir -p "$$HOME/.config/nvim/autoload"
	@ [ -e "$$HOME/.vimrc" ] || ln -s ".config/nvim/init.vim" "$$HOME/.vimrc"
	@ [ -e "$$HOME/.vim" ]   || {\
	      test -d "$$HOME/.vim" || mkdir "$$HOME/.vim";\
		  test -d "$$HOME/.config/nvim/autoload" || mkdir -p "$$HOME/.config/nvim/autoload";\
		  test -d "$$HOME/.local/share/nvim/plugged" || mkdir -p "$$HOME/.local/share/nvim/plugged";\
		  ln -s "../.config/nvim/autoload" "$$HOME/.vim/";\
		  ln -s "../.local/share/nvim/plugged" "$$HOME/.vim/";\
	  }

.PHONY: _requirements_mac
_requirements_mac:
	@ echo "Installing nvim requirements..."
	@ command -v nvim &>/dev/null || {\
	      echo " - nvim";\
		  brew install nvim;\
	  }

.PHONY: _requirements_arch
_requirements_arch:
	@ echo "Installing nvim requirements..."
	@ command -v nvim &>/dev/null || {\
	      echo " - nvim";\
		  sudo pacman -S --noconfirm neovim;\
	  }

.PHONY: _requirements_termux
_requirements_termux:
	@ echo "Installing nvim requirements..."
	@ command -v nvim &>/dev/null || {\
	      echo " - nvim";\
	      pkg install neovim;\
	  }

.PHONY: _post_requirements
_post_requirements:
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

