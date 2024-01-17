{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=2G" "mode=755" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/9B27-AFD6";
      fsType = "vfat";
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-uuid/dc3d5dc9-2edf-40cc-871e-00424aa867fb";
      fsType = "ext4";
    };

  fileSystems."/etc/nixos" =
    {
      device = "/nix/persist/etc/nixos";
      fsType = "none";
      options = [ "bind" ];
    };

  fileSystems."/var/log" =
    {
      device = "/nix/persist/var/log";
      fsType = "none";
      options = [ "bind" ];
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/7d1c7931-7189-4eb0-9a01-fd41875b4b33"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
