files := \
		 $(wildcard home/.config/glow/**/*) \
		 $(wildcard home/.config/glow/*) \
		 home/.local/bin/glow

install//home/%: home/%
	@ bash .install/copy.sh "$<" "${HOME}/$*"

_install: $(patsubst %,install//%,$(files))
	@ true

.PHONY: _requirements_mac
_requirements_mac:
	@ echo "Installing glow requirements..."
	@ command -v glow &>/dev/null || {\
	      echo " - glow";\
		  brew install glow;\
	  }

.PHONY: _requirements_arch
_requirements_arch:
	@ echo "Installing glow requirements..."
	@ command -v glow &>/dev/null || {\
	      echo " - glow";\
		  sudo pacman -S --noconfirm glow;\
	  }

.PHONY: _requirements_termux
_requirements_termux:
	@ echo "Installing glow requirements..."
	@ command -v glow &>/dev/null || {\
	      echo " - glow";\
	      pkg install glow;\
	  }

_requirements_%:
	@ echo "No process for installing glow requiements on $*"
	@ exit 1

.PHONY: _post_requirements
_post_requirements:
	@ true

