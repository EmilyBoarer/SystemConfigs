{ config, pkgs, ... }:
{
  imports = [
    ./waybar
  ];

  #wayland.displayManager.

  # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/
  wayland.windowManager.hyprland = {
    enable = true;
    #xwayland.enable = true;
    settings = {
      # https://wiki.hyprland.org/Configuring/Monitors/
      monitor = [
        "HDMI-A-1, 2560x1440@60, 0x0,        auto"
        "DP-1,     1440x2560@60, -1440x-300, auto, transform, 1"
      ];

      # https://wiki.hyprland.org/Configuring/Variables/#input
      input = {
        kb_layout = "gb";
        follow_mouse = "1";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#general
      general = {
        gaps_in = 0; # "2";
        gaps_out = 0; # "4";
        border_size = 1; # "2";
        # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        #active_border = "rgba(ffffffaa) rgba(5e2d73ee) 45deg";
        #inactive_border = "rgba(000000aa)";
        resize_on_border = true;
        allow_tearing = false;
        layout = "dwindle";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration = {
        rounding = 0;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      # https://wiki.hyprland.org/Configuring/Variables/#animations
      animations = {
        enabled = "yes";
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];
        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      # https://wiki.hyprland.org/Configuring/Workspace-Rules/
      # TODO: do a thing where a fullscreen window doesn't have gaps?

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      "$terminal" = "kitty";
      "$mod" = "SUPER";

      bind =
        [
          "$mod, Q, exec, $terminal"
          "$mod, C, killactive"
          "$mod, M, exit"
          "$mod, E, exec, $fileManager"
          "$mod, V, togglefloating"
          #"$mod, R, exec, $menu"
          "$mod, P, pseudo"
          "$mod, J, togglesplit"
          "$mod, F, fullscreen"
          "$mod, left,  movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up,    movefocus, u"
          "$mod, down,  movefocus, d"
          "$mod, S, exec, rofi -show drun -show-icons"
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up,   workspace, e-1"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (
            builtins.genList (
              i:
              let
                ws = i + 1;
              in
              [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            ) 9
          )
        );

      bindm = [
        # Win+Click&Drag to move and desize windows:
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      exec-once = [
        # TODO, remove all the ampersands ???
        # Wallpapers
        "swww-daemon &"
        "swww img -o HDMI-A-1 ~/IMG_9587.jpg &"
        "swww img -o DP-1 ~/IMG_9587.jpg &"
        # UI things:
        "waybar &"
        "dunst &"
        "blueman-applet"
      ];

    };
  };

}
