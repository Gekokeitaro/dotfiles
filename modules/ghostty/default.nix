{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.homeModules.ghostty;
in {
  options.homeModules.ghostty = {
    enable = mkEnableOption "enable ghostty module";
  };

  config = mkIf cfg.enable {
    programs.ghostty.enable = true;
    
    i18n.inputMethod.fcitx5.settings = {
      inputMethod = {
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "es";
          DefaultIM = "keyboard-es";

          "Items/0" = {
            Name = "keyboard-es";
            GroupOrder = {
              "0" = "Default";
            };
          };
        };
      };

      globalOptions = {
        Hotkey = {
          EnumerateWithTriggerKeys = True;
          EnumerateSkipFirst = False;
          ModifierOnlyKeyTimeout = 250;
          
          TriggerKeys = {
            "0" = "Control+space";
            "1" = "Zenkaku_Hankaku";
            "2" = "Hangul";
          };

          ActivateKeys."0" = "Hangul_Hanja";
          DeactivateKeys."0" = "Hangul_Romaja";
          AltTriggerKeys."0" = "Shift_L";
          EnumerateGroupForwardKeys."0" = "Super+space";
          EnumerateGroupBackwardKeys."0" = "Shift+Super+space";
          PrevPage."0" = "Up";
          NextPage."0" = "Down";
          PrevCandidate."0" = "Shift+Tab";
          NextCandidate."0" = "Tab";
          TogglePreedit."0" = "Control+Alt+P";
        };

        Behavior = {
          ActiveByDefault = False;
          resetStateWhenFocusIn = No;
          ShareInputState = No;
          PreeditEnabledByDefault = True;
          ShowInputMethodInformation = True;
          showInputMethodInformationWhenFocusIn = False;
          CompactInputMethodInformation = True;
          ShowFirstInputMethodInformation = True;
          DefaultPageSize = 5;
          OverrideXkbOption = False;
          PreloadInputMethod = True;
          AllowInputMethodForPassword = False;
          ShowPreeditForPassword = False;
          AutoSavePeriod = 30;
        };
      };
    }; 
  };
}
