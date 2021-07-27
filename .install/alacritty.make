files := \
		 $(wildcard home/.config/alacritty/**/*) \
		 $(wildcard home/.config/alacritty/*)

install//home/%: home/%
	@bash .install/copy.sh "$<" "${HOME}/$*"

_install: $(patsubst %,install//%,$(files))
	@true

