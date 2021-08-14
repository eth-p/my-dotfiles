files := home/.tmux.conf \
	$(wildcard home/.config/tmux/**/*) \
	$(wildcard home/.local/libexec/tmux-*)

install//home/%: home/%
	@ bash .install/copy.sh "$<" "${HOME}/$*"

_install: $(patsubst %,install//%,$(files))
	@ true

.PHONY: _requirements_mac
_requirements_mac:
	@ echo "Installing tmux requirements..."
	@ command -v tmux &>/dev/null || {\
	      echo " - tmux";\
		  brew install tmux;\
	  }

_requirements_%:
	@ echo "No process for installing tmux requiements on $*"
	@ exit 1

