# CODESYS 4 for Nix

Nix flake packaging of [CODESYS 4](https://www.codesys.com/products/engineering/codesys-4), built from the official Debian package.

## Quick Start

```bash
# Run without installing
nix run github:wty-andrew/codesys-flake -- standalone-session

# Install into your profile
nix profile add github:wty-andrew/codesys-flake
```

## Installation

Add the flake to your `flake.nix` inputs:

```nix
codesys = {
  url = "github:wty-andrew/codesys-flake";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

Then add the package to your NixOS configuration:

```nix
{ inputs, pkgs, ... }: {
  environment.systemPackages = [
    inputs.codesys.packages.${pkgs.stdenv.hostPlatform.system}.codesys-4
  ];
}
```

Or to your Home Manager configuration:

```nix
{ inputs, pkgs, ... }: {
  home.packages = [
    inputs.codesys.packages.${pkgs.stdenv.hostPlatform.system}.codesys-4
  ];
}
```

## Usage

Start the local server and open the UI in your browser:

```bash
c4-cli standalone-session
```

## Known Limitations

- **Times are in UTC**: the extension cache is only valid in the timezone it was built in, so the wrappers set `TZ=UTC`.
- **Extensions can't be added or removed**: they're installed into the read-only Nix store at build time.
- **`c4-server` login fail**: it needs util-linux's `su`, but NixOS ships shadow's.

## References

- [Installing CODESYS 4](https://content.helpme-codesys.com/en/CODESYS%204/_c4_install_desktop_linux.html)
