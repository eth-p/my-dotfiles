files := home/.tmux.conf \
	$(wildcard home/.local/libexec/tmux-*)

install//home/%: home/%
	@bash .install/copy.sh "$<" "${HOME}/$*"

_install: $(patsubst %,install//%,$(files))
	@true

