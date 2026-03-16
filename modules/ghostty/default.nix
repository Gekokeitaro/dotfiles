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
        };

        "Groups/0/Items/0" = {
          Name = "keyboard-es";   
        };
          
        GroupOrder = {
          "0" = "Default";
        };
      };

      globalOptions = {
        Hotkey = {
          EnumerateWithTriggerKeys = "True";
          EnumerateSkipFirst = "False";
          ModifierOnlyKeyTimeout = 250;
          TriggerKeys = "Control+space, Zenkaku_Hankaku, Hangul";
          ActivateKeys = "Hangul_Hanja";
          DeactivateKeys = "Hangul_Romaja";
          AltTriggerKeys = "Shift_L";
          EnumerateGroupForwardKeys = "Super+space";
          EnumerateGroupBackwardKeys = "Shift+Super+space";
          PrevPage = "Up";
          NextPage = "Down";
          PrevCandidate = "Shift+Tab";
          NextCandidate = "Tab";
          TogglePreedit = "Control+Alt+P";
        };

        Behavior = {
          ActiveByDefault = "False";
          resetStateWhenFocusIn = "No";
          ShareInputState = "No";
          PreeditEnabledByDefault = "True";
          ShowInputMethodInformation = "True";
          showInputMethodInformationWhenFocusIn = "False";
          CompactInputMethodInformation = "True";
          ShowFirstInputMethodInformation = "True";
          DefaultPageSize = 5;
          OverrideXkbOption = "False";
          PreloadInputMethod = "True";
          AllowInputMethodForPassword = "False";
          ShowPreeditForPassword = "False";
          AutoSavePeriod = 30;
        };
      };
    }; 
  };
}
