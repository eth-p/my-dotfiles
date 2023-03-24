files := \
	home-steamos/.config/plasma-workspace/shutdown/graceful-chrome-shutdown \
	home-steamos/.var/app/com.google.Chrome/config/chrome-flags.conf

install//home-steamos/%: home-steamos/%
	@ bash .install/copy.sh "$<" "${HOME}/$*"

_install: $(patsubst %,install//%,$(files))
	flatpak install com.google.Chrome

_requirements_%:
	@ echo "No process for installing steamos-chrome requiements on $*"
	@ exit 1

.PHONY: _post_requirements
_post_requirements:
	@ true

