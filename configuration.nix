{ inputs, pkgs, lib, config, ... }: {
  imports = [ ./hardware-configuration.nix ];

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = [ "/etc/nix/path" ];
  environment.etc =
    lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  networking.hostName = "blitzar";
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/Chicago";

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.mutableUsers = false;

  users.users = {
    # password: temp a
    root.initialHashedPassword = "$6$FRmKgElD/80xQiXn$aF.tKv0VOLj9D3aUJjoYsj3AzSj1rq5fVooE7tgtNuTawt8ZWgaRyUUxsikX5whbna4jrzXrDZmVFqik.kyc2/";

    will = {
      # password: temp b
      initialHashedPassword = "$6$iLmo7C9VoAnJZ6v1$qCSORkbiY44IbcrrF1DcTnJtpOkqeD2tGgUoaDgtzPdFqKWKJ28AhJqmuOf8IWoSNu2DQJM.QlWO1Ok05kFgp0";
      extraGroups = [ "wheel" ];
      isNormalUser = true;
      shell = pkgs.zsh;
    };
  };

  programs.zsh.enable = true;

  fonts.packages = with pkgs; [
    fira-mono
    hack-font
    inconsolata
    iosevka
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
