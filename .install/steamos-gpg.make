files := \
		 $(wildcard home-steamos/.local/bin/gpg) \
		 $(wildcard home-steamos/.config/systemd/user/vaulted-gpg-agent*)

install//home-steamos/%: home-steamos/%
	@ bash .install/copy.sh "$<" "${HOME}/$*"

_install: $(patsubst %,install//%,$(files))
	systemctl --user enable vaulted-gpg-agent.service

_requirements_%:
	@ echo "No process for installing steamos-gpg requiements on $*"
	@ exit 1

.PHONY: _post_requirements
_post_requirements:
	@ true

