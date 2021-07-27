files := \
		 $(wildcard home/.config/bat/**/*) \
		 $(wildcard home/.config/bat/*)

install//home/%: home/%
	@ bash .install/copy.sh "$<" "${HOME}/$*"

_install: $(patsubst %,install//%,$(files))
	@ true

.PHONY: _requirements_mac
_requirements_mac:
	@ echo "Installing bat requirements..."
	@ command -v bat &>/dev/null || {\
	      echo " - bat";\
		  brew install bat;\
	  }

_requirements_%:
	@ echo "No process for installing bat requiements on $*"
	@ exit 1

