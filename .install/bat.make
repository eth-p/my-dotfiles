files := \
		 $(wildcard home/.config/bat/**/*) \
		 $(wildcard home/.config/bat/*)

install//home/%: home/%
	@bash .install/copy.sh "$<" "${HOME}/$*"

_install: $(patsubst %,install//%,$(files))
	@true

