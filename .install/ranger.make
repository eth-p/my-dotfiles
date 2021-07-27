files := \
		 $(wildcard home/.config/ranger/**/*) \
		 $(wildcard home/.config/ranger/*)

install//home/%: home/%
	@bash .install/copy.sh "$<" "${HOME}/$*"

_install: $(patsubst %,install//%,$(files))
	@true

