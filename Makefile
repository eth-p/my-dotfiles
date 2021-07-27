REPO_ROOT := "$(dir "$(mkfile_path)")"

.PHONY: all
all: list

# Use the makefiles inside .install.
install/%: .install/%.make
	@cd "${REPO_ROOT}" && make -f "$<" _install

.PHONY: install/all
install: $(patsubst .install/%.make,install/%,$(wildcard .install/*.make))
	@true

# Help
list:
	@ echo "Available targets:";                            \
	  printf " - list\n";                                   \
	  printf " - install\n";                                \
	  for f in .install/*.make; do                          \
	      printf " - install/%s\n" `basename -- $$f .make`; \
	  done;                                                 \

