{
  flake.modules.generic.keyboard =
    {
      config,
      lib,
      ...
    }:
    with lib;
    let
      cfg = config.keyboard;
      mergeKeyboardOption =
        optionName:
        let
          values = filter (v: v != null && v != "") (map (k: k.${optionName}) cfg);
        in
        if values == [ ] then null else concatStringsSep "," values;
    in
    {
      options = {
        keyboard = mkOption {
          type = types.listOf (
            types.submodule {
              options = {
                layout = mkOption {
                  type = types.str;
                  default = "br";
                  description = "The keyboard layout.";
                };
                model = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  description = "The keyboard model.";
                };
                variant = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  description = "The keyboard variant.";
                };
              };
            }
          );
          default = [
            {
              layout = "br";
              model = "abnt2";
            }
          ];
          description = "A list of keyboard configurations, applied in order. The first item is used for the console keymap.";
        };
        keyboardValue = mkOption {
          type = types.submodule {
            options = {
              layouts = mkOption {
                #internal = true;
                #readonly = true;
                type = types.nullOr types.str;
                default = mergeKeyboardOption "layout";
                description = "Comma-separated list of keyboard layouts.";
              };
              models = mkOption {
                #internal = true;
                #readonly = true;
                type = types.nullOr types.str;
                default = mergeKeyboardOption "model";
                description = "Comma-separated list of keyboard models.";
              };
              variants = mkOption {
                #internal = true;
                #readonly = true;
                type = types.nullOr types.str;
                default = mergeKeyboardOption "variant";
                description = "Comma-separated list of keyboard variants.";
              };
              keyMap = mkOption {
                #internal = true;
                #readonly = true;
                type = types.nullOr types.str;
                default =
                  let
                    k = head cfg;
                  in
                  "${k.layout}${optionalString (k.variant != null) "-${k.variant}"}";
                description = "The keymap for the console, derived from the first keyboard configuration.";
              };
            };
          };
          default = { };
          description = "Derived keyboard configuration values.";
        };
      };
    };
}
