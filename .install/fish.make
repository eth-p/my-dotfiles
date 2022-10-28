files := \
		 $(wildcard home/.config/fish/**/*) \
		 $(wildcard home/.config/fish/*) \
		 home/.local/libexec/term-query-bg \
		 home/.local/bin/java \
		 home/.local/bin/javac

install//home/%: home/%
	@ bash .install/copy.sh "$<" "${HOME}/$*"

_install: $(patsubst %,install//%,$(files))
	@ fish -c 'fisher update'

.PHONY: _requirements_mac
_requirements_mac:
	@ echo "Installing fish requirements..."
	@ command -v fish &>/dev/null || {\
	      echo " - fish";\
		  brew install fish;\
	  }
	@ command -v vivid &>/dev/null || {\
	      echo " - vivid";\
		  brew install vivid;\
	  }

.PHONY: _requirements_arch
_requirements_arch:
	@ echo "Installing fish requirements..."
	@ command -v fish &>/dev/null || {\
	      echo " - fish";\
		  sudo pacman -S --noconfirm fish;\
	  }
	@ command -v vivid &>/dev/null || {\
	      echo " - vivid";\
		  sudo pacman -S --noconfirm vivid;\
	  }

.PHONY: _requirements_termux
_requirements_termux:
	@ echo "Installing fish requirements..."
	@ command -v fish &>/dev/null || {\
	      echo " - fish";\
	      pkg install fish;\
	  }
	@ command -v vivid &>/dev/null || {\
	      echo " - vivid";\
	      pkg install vivid;\
	  }

.PHONY: _post_requirements
_post_requirements:
	@ [ -f "$${HOME}/.config/fish/functions/fisher.fish" ] || {\
		  echo " - fish plugins";\
	      fish -c 'curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher' 1>/dev/null;\
		  bash .install/copy.sh home/.config/fish/fish_plugins "$${HOME}/.config/fish/fish_plugins";\
	      fish -c 'fisher update' 1>/dev/null;\
	  }


_requirements_%:
	@ echo "No process for installing fish requiements on $*"
	@ exit 1

