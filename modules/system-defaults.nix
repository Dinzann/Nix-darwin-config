# Captured from current macOS preferences (dinzann @ Dinzann).
# Apply: sudo darwin-rebuild switch --flake ~/.config/nix-darwin#Dinzann
{
  system.defaults = {
    dock = {
      autohide = true;
      tilesize = 56;
      magnification = false;
      orientation = "bottom";
      # Bottom-right hot corner → Quick Note
      wvous-br-corner = 14;
    };

    finder = {
      ShowPathbar = true;
      ShowHardDrivesOnDesktop = false;
      ShowExternalHardDrivesOnDesktop = true;
      ShowRemovableMediaOnDesktop = true;
      FXPreferredViewStyle = "Nlsv"; # List view
      NewWindowTarget = "Recents";
      FXRemoveOldTrashItems = true;
    };

    NSGlobalDomain = {
      # Auto light/dark (follows time of day)
      AppleInterfaceStyleSwitchesAutomatically = true;
      _HIHideMenuBar = false;
      KeyRepeat = 5;
      InitialKeyRepeat = 30;
      NSAutomaticCapitalizationEnabled = true;
      NSAutomaticPeriodSubstitutionEnabled = true;
      NSTableViewDefaultSizeMode = 2;
      "com.apple.trackpad.scaling" = 0.875;
      "com.apple.trackpad.forceClick" = true;
    };

    trackpad = {
      Clicking = false; # tap to click off
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = true;
      TrackpadThreeFingerTapGesture = 0;
      FirstClickThreshold = 1;
      SecondClickThreshold = 1;
      ActuateDetents = true;
      ForceSuppressed = false;
      TrackpadFourFingerHorizSwipeGesture = 2;
      TrackpadFourFingerPinchGesture = 2;
      TrackpadFourFingerVertSwipeGesture = 2;
    };

    WindowManager = {
      GloballyEnabled = false; # Stage Manager off
      AutoHide = false;
      AppWindowGroupingBehavior = true; # group app windows
      HideDesktop = true;
      EnableTiledWindowMargins = false;
      StandardHideWidgets = false;
      StageManagerHideWidgets = false;
    };

    menuExtraClock = {
      ShowAMPM = true;
      ShowDate = 0; # when space allows
      ShowDayOfWeek = true;
    };

    # Options without first-class nix-darwin attrs
    CustomUserPreferences = {
      NSGlobalDomain = {
        AppleMenuBarVisibleInFullscreen = false;
        AppleMiniaturizeOnDoubleClick = false;
      };
    };
  };
}
