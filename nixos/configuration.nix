{ inputs
, lib
, config
, pkgs
, ...
}: {
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
    will = {
      # password: temp
      initialHashedPassword = "$6$mVQOWQToV2qqW37n$f5nDwd/Bm3J9DaV5dFINgMgNidhZ.PCjQVnDDzboOcUwAESquZQ08aEJKDgpmjkbXSBEEcjytZNij1qUINbq71";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
