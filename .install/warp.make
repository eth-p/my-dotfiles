files := \
		 $(wildcard home/.warp/**/*)

install//home/%: home/%
	@ bash .install/copy.sh "$<" "${HOME}/$*"

_install: $(patsubst %,install//%,$(files))
	@ true

.PHONY: _post_requirements
_post_requirements:
	@ true

_requirements_%:
	@ echo "No process for installing warp requiements on $*"
	@ exit 1
