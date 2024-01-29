# ex-nixos-starter-config

This is an example repo for [this blog
post](https://willbush.dev/blog/impermanent-nixos) on how one might configure a
[misterio77/nix-starter-config](https://github.com/Misterio77/nix-starter-configs)
minimal template for impermanence.

The root password is `temp a` and user `will` password is `temp b`.

Replace the `initialHashedPassword` in `configuration.nix` with your own:

```sh
$ nix-shell --run 'mkpasswd -m SHA-512 -s' -p mkpasswd
Password: your password
<hash output>
```
