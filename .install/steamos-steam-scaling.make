files := \
	home-steamos/.local/bin/steam

install//home-steamos/%: home-steamos/%
	@ bash .install/copy.sh "$<" "${HOME}/$*"

_install: $(patsubst %,install//%,$(files))
	@ true

_requirements_%:
	@ echo "No process for installing steamos-steam-scaling requiements on $*"
	@ exit 1

.PHONY: _post_requirements
_post_requirements:
	@ true

