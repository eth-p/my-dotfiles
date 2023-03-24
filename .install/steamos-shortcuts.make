files := \
		 $(wildcard home-steamos/.local/steam-shortcuts/*)

install//home-steamos/%: home-steamos/%
	@ bash .install/copy.sh "$<" "${HOME}/$*"

_install: $(patsubst %,install//%,$(files))
	@ true

_requirements_%:
	@ echo "No process for installing steamos-shortcuts requiements on $*"
	@ exit 1

.PHONY: _post_requirements
_post_requirements:
	@ true

