{
  pkgs,
  system ? pkgs.stdenv.hostPlatform.system,
  ...
}:
let
  pname = "codesys-4";
  version = "1.0.0.0";
  sources = {
    x86_64-linux = {
      arch = "amd64";
      hash = "sha256-j2phQTaZfJoSQtsWx6C3NTWaWDDnUBoU9kBzIsAYQRg=";
    };
    aarch64-linux = {
      arch = "arm64";
      hash = "sha256-jGJ9AlSRRCv2VP3IVvrq7COwMAryDhmXe/U56qJI+rs=";
    };
  };
  source = sources.${system};
  url = "https://store-archive.codesys.com/ftp_download/3S/CODESYS4/2101000024/${version}/${pname}_${version}_${source.arch}.deb";
in
rec {
  codesys-4 = pkgs.callPackage ./codesys-4.nix {
    inherit pname version url;
    inherit (source) hash;
  };
  default = codesys-4;
}
