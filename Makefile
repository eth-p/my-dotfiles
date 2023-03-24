# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles

REPO_ROOT := "$(dir "$(mkfile_path)")"

.PHONY: all
all: list

# Help
list:
	@ echo "Available targets:";                            \
	  printf " - list\n";                                   \
	  printf " - requirements\n";                           \
	  printf " - install\n";                                \
	  for f in .install/*.make; do                          \
	      printf " - install/%s\n" `basename -- $$f .make`; \
	  done;                                                 \


# -----------------------------------------------------------------------------
# Install:
# -----------------------------------------------------------------------------

install/%: .install/%.make
	@cd "${REPO_ROOT}" && make -f "$<" _install

.PHONY: install
install: $(patsubst .install/%.make,install/%,$(filter-out .install/steamos-%,$(wildcard .install/*.make)))
	@true

# -----------------------------------------------------------------------------
# Install Requirements:
# -----------------------------------------------------------------------------

requirements/%: .install/%.make
	@ cd "${REPO_ROOT}";                                                    \
	  system=`uname -s`;                                                    \
	  if [ -n "$TERMUX_APP_PID" ]; then system="termux"; fi;                \
	  case "$$system" in                                                    \
	      Darwin)      system='mac';;                                       \
	      Linux|linux) case "`sh -c '. /etc/os-release && echo "$$ID"'`" in \
	          arch)    system='arch';;                                      \
			  steamos) system='steamos';;                                   \
	      esac;;                                                            \
	  esac;                                                                 \
	  make -f "$<" _requirements_"$$system";                                \
	  if grep '^_post_requirements:' "$<" &>/dev/null; then                 \
	      make -f "$<" _post_requirements;                                  \
	  fi

.PHONY: requirements
requirements: $(patsubst .install/%.make,requirements/%,$(wildcard .install/*.make))
	@true

