# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# ==============================================================================
{
  lib,
  pkgs,
  ...
}:
rec {

  mkTableTestInputPlaceholderDeclarations =
    placeholderNum: n:
    if n == 0 then
      [ ]
    else
      [ "\t\t\${${toString placeholderNum}:input${toString n}} \${${toString (placeholderNum + 1)}:ty}" ]
      ++ (mkTableTestInputPlaceholderDeclarations (placeholderNum + 2) (n - 1));

  mkTableTestInputPlaceholderUsages =
    placeholderNum: n:
    if n == 1 then
      "tc.\$${toString placeholderNum}"
    else
      "${mkTableTestInputPlaceholderUsages (placeholderNum + 2) (n - 1)}, \$${toString placeholderNum}";

  mkTableTestSnippet =
    { params }:
    let
      paramsDesc = if params == 1 then "1 parameter" else "${toString params} parameters";
      name = "Table test, ${paramsDesc}";
    in
    {
      "${name}" = {
        prefix = [
          "func Test${toString params}"
        ];
        description = "Creates a table test function with ${paramsDesc}";
        body = [
          "func Test\${1:Name}(t *testing.T) {"
          "\ttestcases := map[string]struct {"
          "\t\texpected \${2:type}"
        ]
        ++ (mkTableTestInputPlaceholderDeclarations 3 params)
        ++ [
          "\t}{"
          "\t\t\$0"
          "\t}"
          ""
          "\tt.Parallel()"
          "\tfor name, tc := range testcases {"
          "\t\tt.Run(name, func(t *testing.T) {"
          "\t\t\tt.Parallel()"
          "\t\t\tactual := \$1(${mkTableTestInputPlaceholderUsages 3 params})"
          "\t\t\tassert.Equal(t, tc.expected, actual)"
          "\t\t})"
          "\t}"
          "}"
        ];
      };

      "${name} with error" = {
        prefix = [
          "func Test${toString params}E"
        ];
        description = "Creates a table test function with ${paramsDesc}";
        body = [
          "func Test\${1:Name}(t *testing.T) {"
          "\ttestcases := map[string]struct {"
          "\t\texpected \${2:type}"
          "\t\texpectedError error"
        ]
        ++ (mkTableTestInputPlaceholderDeclarations 3 params)
        ++ [
          "\t}{"
          "\t\t\$0"
          "\t}"
          ""
          "\tt.Parallel()"
          "\tfor name, tc := range testcases {"
          "\t\tt.Run(name, func(t *testing.T) {"
          "\t\t\tt.Parallel()"
          "\t\t\tactual, err := \$1(${mkTableTestInputPlaceholderUsages 3 params})"
          "\t\t\trequire.ErrorIs(t, err, tc.expectedError)"
          "\t\t\tassert.Equal(t, tc.expected, actual)"
          "\t\t})"
          "\t}"
          "}"
        ];
      };
    };

}
