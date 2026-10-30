{ name, my-pkgs, ... }:
''
  function ${name}
    set -gx PREFERRED_COLORSCHEME (${my-pkgs.term-query-bg}/bin/term-query-bg)
  end
''
