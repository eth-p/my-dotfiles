files := \
		 $(wildcard home-steamos/.local/bin/gpg) \
		 $(wildcard home-steamos/.local/libexec/vault-tools) \
		 $(wildcard home-steamos/.config/systemd/user/gpg-agent.service/*)

install//home-steamos/%: home-steamos/%
	@ bash .install/copy.sh "$<" "${HOME}/$*"

_install: $(patsubst %,install//%,$(files))
	systemctl --user daemon-reload
	systemctl --user restart gpg-agent.service

_requirements_%:
	@ echo "No process for installing steamos-gpg requiements on $*"
	@ exit 1

.PHONY: _post_requirements
_post_requirements:
	@ true

