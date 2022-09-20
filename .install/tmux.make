files := home/.tmux.conf \
	$(wildcard home/.config/tmux/**/*) \
	$(wildcard home/.config/tmux/integrations/*/*) \
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

.PHONY: _requirements_arch
_requirements_arch:
	@ echo "Installing tmux requirements..."
	@ command -v tmux &>/dev/null || {\
	      echo " - tmux";\
		  sudo pacman -S --noconfirm tmux;\
	  }

.PHONY: _requirements_termux
_requirements_termux:
	@ echo "Installing tmux requirements..."
	@ command -v tmux &>/dev/null || {\
	      echo " - tmux";\
	      pkg install tmux;\
	  }

_requirements_%:
	@ echo "No process for installing tmux requiements on $*"
	@ exit 1

.PHONY: _post_requirements
_post_requirements:
	@ true

