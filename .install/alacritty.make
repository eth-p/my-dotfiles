files := \
		 $(wildcard home/.config/alacritty/**/*) \
		 $(wildcard home/.config/alacritty/*)

install//home/%: home/%
	@ bash .install/copy.sh "$<" "${HOME}/$*"

_install: $(patsubst %,install//%,$(files))
	@ true

.PHONY: _requirements_mac
_requirements_mac:
	@ echo "Installing alacritty requirements..."
	@ [ -f "$$HOME/Library/Fonts/JetBrainsMonoNL-Regular.ttf" ] || {\
	      echo " - JetBrains Mono font";\
	      brew tap homebrew/cask-fonts;\
	      brew install font-jetbrains-mono;\
	  }

_requirements_%:
	@ echo "No process for installing alacritty requiements on $*"
	@ exit 1

