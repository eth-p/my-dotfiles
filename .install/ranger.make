files := \
		 $(wildcard home/.config/ranger/**/*) \
		 $(wildcard home/.config/ranger/*)

install//home/%: home/%
	@ bash .install/copy.sh "$<" "${HOME}/$*"

_install: $(patsubst %,install//%,$(files))
	@ true

.PHONY: _requirements_mac
_requirements_mac:
	@ echo "Installing ranger requirements..."
	@ command -v ranger &>/dev/null || {\
	      echo " - ranger";\
		  brew install ranger;\
	  }

_requirements_%:
	@ echo "No process for installing ranger requiements on $*"
	@ exit 1

