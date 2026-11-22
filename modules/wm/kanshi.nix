{
  flake.homeModules.kanshi = {
    services.kanshi = {
      enable = true;
      settings = [
        {
          profile.name = "undocked";
          profile.outputs = [ { criteria = "eDP-1"; } ];
        }
        {
          profile.name = "semi-docked";
          profile.outputs = [
            {
              criteria = "eDP-1";
              position = "0,0";
            }
            {
              criteria = "HDMI-A-1";
              position = "1920,0";
            }
          ];
        }
        {
          profile.name = "fully-docked";
          profile.outputs = [
            {
              criteria = "HDMI-A-1";
              position = "0,0";
            }
            {
              criteria = "eDP-1";
              position = "1920,0";
            }
            {
              criteria = "DP-1";
              position = "3840,0";
            }
          ];
        }
      ];
    };
  };
}
