{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  dpkg,
  jq,
  dotnetCorePackages,
  xdg-utils,
  pname,
  version,
  url,
  hash,
  ...
}:
stdenv.mkDerivation {
  inherit pname version;
  applicationName = "CODESYS 4";

  src = fetchurl {
    inherit url hash;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    dpkg
    jq
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out $out/etc $out/opt $out/bin
    cp -r etc/CODESYS-4 $out/etc/CODESYS-4
    cp -r opt/codesys-4 $out/opt/codesys-4
    cp -r usr/share $out/share

    for b in c4-cli c4-pkm c4-server; do
      makeWrapper $out/opt/codesys-4/$b $out/bin/$b \
        --set TZ UTC \
        --set DOTNET_ROOT ${dotnetCorePackages.aspnetcore_8_0}/share/dotnet \
        --prefix PATH : ${lib.makeBinPath [ xdg-utils ]}
    done

    runHook postInstall
  '';

  dontAutoPatchelf = true;

  postFixup = ''
    autoPatchelf $out

    base=$out/opt/codesys-4
    $out/bin/c4-pkm install --all $base/extensions

    for f in $(find $base -name inst-info.json); do
      jq -c '.InstallationDate = "1980-01-01T00:00:00+00:00"' "$f" > "$f.tmp"
      mv "$f.tmp" "$f"
    done

    $out/bin/c4-pkm refresh-cache
  '';

  meta = {
    mainProgram = "c4-cli";
    description = "CODESYS 4";
    homepage = "https://www.codesys.com/products/engineering/codesys-4";
    downloadPage = "https://store.codesys.com/en/codesys-4.html";
  };
}
