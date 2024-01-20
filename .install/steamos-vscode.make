files := \
	home-steamos/.local/lib/ethp-flatpak-utils.sh \
	home-steamos/.config/fish/conf.d/2-vscode-path.fish \
	$(wildcard home-steamos/.local/share/vscodebin/*)

install//home-steamos/%: home-steamos/%
	@ bash .install/copy.sh "$<" "${HOME}/$*"

_install: $(patsubst %,install//%,$(files))
	flatpak install com.visualstudio.code

_requirements_%:
	@ echo "No process for installing steamos-flatpak requiements on $*"
	@ exit 1

.PHONY: _post_requirements
_post_requirements:
	@ true

