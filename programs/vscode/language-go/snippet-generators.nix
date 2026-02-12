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
let
  inherit (builtins) concatStringsSep;
in
rec {

  # mkPlaceholders generates a list of snippet placeholders.
  #
  # mkPlaceholders :: attrset (int -> string) -> [string]
  mkPlaceholders =
    {
      start ? 1,
      step ? 1,
      iteration ? 1,
    }@options:
    fn: n:
    let
      nextN = (n - 1);
      nextOptions = options // {
        start = start + step;
        iteration = iteration + 1;
      };
    in
    if n == 0 then [ ] else [ (fn iteration start) ] ++ (mkPlaceholders nextOptions fn nextN);

  # mkTableTestSnippet creates a Visual Studio Code snippet defining a test
  # function for a table test of a function.
  #
  # mkTableTestSnippet :: { params: int } -> attrset
  mkTableTestSnippet =
    {
      # The number of parameters the function has.
      paramCount,

      # The number of returns values the function has.
      returnCount ? 1,

      # If the function returns an error.
      returnsError ? false,
    }:
    let
      paramsDesc = if paramCount == 1 then "1 param" else "${toString paramCount} params";
      returnsDesc = if returnCount == 1 then "1 return" else "${toString paramCount} returns";
      returnsErrorDesc = if returnsError then "with error" else "";
      descs = [
        paramsDesc
      ]
      ++ (lib.optional (returnCount > 1) returnsDesc)
      ++ (lib.optional returnsError returnsErrorDesc);

      prefixSuffix = concatStringsSep "" (
        [ (toString paramCount) ]
        ++ (lib.optional (returnCount > 1) (toString returnCount))
        ++ (lib.optional returnsError "E")
      );

      generateStructInputField =
        i: p: "\t\t\${${toString p}:input${toString i}} \${${toString (p + 1)}:type}";
      generateStructExpectField =
        i: p: "\t\texpected\${${toString p}:Value${toString i}} \${${toString (p + 1)}:type}";
      generateReturnAssert =
        i: p: "\t\t\tassert.Equal(t, tc.expected\$${toString p}, actual\$${toString p})";
      generateCallParam = i: p: "tc.\$${toString p}";
      generateCallReturn = i: p: "actual\$${toString p}";

      funcReturnValues =
        (mkPlaceholders expectPOpts generateCallReturn returnCount) ++ (lib.optional returnsError "err");

      inputPOpts = {
        start = 2;
        step = 2;
      };

      expectPOpts = {
        start = inputPOpts.start + (paramCount * 2);
        step = 2;
      };
    in
    {
      "Table test, ${concatStringsSep ", " descs}" = {
        prefix = [
          "func Test${prefixSuffix}"
        ];
        body = [
          "func Test\${1:Name}(t *testing.T) {"
          "\ttestcases := map[string]struct {"
        ]
        ++ (mkPlaceholders inputPOpts generateStructInputField paramCount)
        ++ (mkPlaceholders expectPOpts generateStructExpectField paramCount)
        ++ (lib.optional returnsError "\t\texpectedError error")
        ++ [
          "\t}{"
          "\t\t\$0"
          "\t}"
          ""
          "\tt.Parallel()"
          "\tfor name, tc := range testcases {"
          "\t\tt.Run(name, func(t *testing.T) {"
          "\t\t\tt.Parallel()"
          "\t\t\t${concatStringsSep ", " funcReturnValues} := \$1(${
            concatStringsSep ", " (mkPlaceholders inputPOpts generateCallParam paramCount)
          })"
        ]
        ++ (lib.optional returnsError "\t\t\trequire.ErrorIs(t, err, tc.expectedError)")
        ++ (mkPlaceholders expectPOpts generateReturnAssert paramCount)
        ++ [
          "\t\t})"
          "\t}"
          "}"
        ];
      };
    };

}
