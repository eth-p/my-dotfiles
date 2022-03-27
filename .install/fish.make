files := \
		 $(wildcard home/.config/fish/**/*) \
		 $(wildcard home/.config/fish/*) \
		 home/.local/libexec/term-query-bg

install//home/%: home/%
	@ bash .install/copy.sh "$<" "${HOME}/$*"

_install: $(patsubst %,install//%,$(files))
	@ true

.PHONY: _requirements_mac
_requirements_mac:
	@ echo "Installing fish requirements..."
	@ command -v fish &>/dev/null || {\
	      echo " - fish";\
		  brew install fish;\
	  }
	@ [ -f "$${HOME}/.config/fish/functions/fisher.fish" ] || {\
		  echo " - fish plugins";\
	      fish -c 'curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher' 1>/dev/null;\
		  bash .install/copy.sh home/.config/fish/fish_plugins "$${HOME}/.config/fish/fish_plugins";\
	      fish -c 'fisher update' 1>/dev/null;\
	  }
	@ command -v vivid &>/dev/null || {\
	      echo " - vivid";\
		  brew install vivid;\
	  }

_requirements_%:
	@ echo "No process for installing fish requiements on $*"
	@ exit 1

