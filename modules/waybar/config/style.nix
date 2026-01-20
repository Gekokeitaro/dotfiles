{ pkgs, ... }:

{
  programs.waybar.style = ''
  
  * {
    border: none;
    border-radius: 0;
  }

  window#waybar {
    background: #16191C;
    color: #AAB2BF;
  }
  '';
}
