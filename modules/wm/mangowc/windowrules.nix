{
  flake.homeModules.mangowc = {
    wayland.windowManager.mango.settings.window_rule = [
      # Utility apps: float the whole window
      "is_floating:1,app_id:pavucontrol" # org.pulseaudio.pavucontrol
      "is_floating:1,app_id:blueman-manager" # .blueman-manager-wrapped
      "is_floating:1,app_id:nm-connection-editor"
      "is_floating:1,app_id:qalculate" # qalculate-gtk
      "is_floating:1,app_id:swappy" # screenshot annotation
      "is_floating:1,app_id:keepassxc" # org.keepassxc.KeePassXC

      # VLC VLSub extension dialog
      "is_floating:1,title:VLSub"

      # Generic dialogs
      "is_floating:1,app_id:xdg-desktop-portal" # portal Open/Save file choosers
      "is_floating:1,title:^(Open File|Open Files|Open Folder|Save File|Save As|Select a File|Select Folder|Choose Files)$"
      "is_floating:1,title:File Operation Progress" # copy/move progress
      "is_floating:1,title:^(Picture-in-Picture|Picture in picture)$" # browser PiP
      "is_floating:1,title:^(Authentication Required|Authenticate)$" # polkit prompt
    ];
  };
}
