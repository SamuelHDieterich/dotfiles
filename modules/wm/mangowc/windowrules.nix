{
  flake.homeModules.mangowc = {
    wayland.windowManager.mango.settings.windowrule = [
      # Utility apps: float the whole window
      "isfloating:1,appid:pavucontrol" # org.pulseaudio.pavucontrol
      "isfloating:1,appid:blueman-manager" # .blueman-manager-wrapped
      "isfloating:1,appid:nm-connection-editor"
      "isfloating:1,appid:qalculate" # qalculate-gtk
      "isfloating:1,appid:swappy" # screenshot annotation
      "isfloating:1,appid:keepassxc" # org.keepassxc.KeePassXC

      # VLC VLSub extension dialog
      "isfloating:1,title:VLSub"

      # Generic dialogs
      "isfloating:1,appid:xdg-desktop-portal" # portal Open/Save file choosers
      "isfloating:1,title:^(Open File|Open Files|Open Folder|Save File|Save As|Select a File|Select Folder|Choose Files)$"
      "isfloating:1,title:File Operation Progress" # copy/move progress
      "isfloating:1,title:^(Picture-in-Picture|Picture in picture)$" # browser PiP
      "isfloating:1,title:^(Authentication Required|Authenticate)$" # polkit prompt
    ];
  };
}
