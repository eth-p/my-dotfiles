files := \
		 $(wildcard home/.config/fish/**/*) \
		 $(wildcard home/.config/fish/*)

install//home/%: home/%
	@bash .install/copy.sh "$<" "${HOME}/$*"

_install: $(patsubst %,install//%,$(files))
	@true

