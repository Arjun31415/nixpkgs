{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  coreutils,
  dpkg,
  qtbase,
  wrapQtAppsHook,
  libsecret,
  nss,
  openssl,
  udev,
  xorg,
  mesa,
  libdrm,
  libappindicator,
  openvpn,
  wstunnel,
  libnl,
  libcap_ng,
  dbus,
  qtwayland,
  nftables,
  c-ares,
  freetype,
  zlib-ng,
}:
stdenv.mkDerivation rec {
  pname = "windscribe";
  version = "2.8.6";

  src = fetchurl {
    url = "https://github.com/Windscribe/Desktop-App/releases/download/v${version}/windscribe_${version}_amd64.deb";
    hash = "sha256-WMhZQ5mRtpqbed0cD1sGAY+/V8zb2ezgHbjClmqjtqQ=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    wrapQtAppsHook
  ];

  buildInputs = [
    openvpn
    wstunnel
    libsecret
    nss
    xorg.libxkbfile
    xorg.libXdamage
    xorg.libXScrnSaver
    xorg.libXtst
    xorg.libxshmfence
    mesa
    libdrm
    qtbase
    libnl
    libcap_ng
    dbus
    nftables
    c-ares.dev
    freetype
  ];

  runtimeDependencies = [
    coreutils
    openssl
    openvpn
    wstunnel
    (lib.getLib udev)
    libappindicator
    libsecret
    qtwayland
    c-ares.out
    c-ares.dev
    zlib-ng
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg -x $src .
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    ls -al

    mkdir -p $out/{bin,lib,opt}
    cp -ar ./usr/share $out
    cp -ar ./opt/ $out

    runHook postInstall
  '';

  # postFixup = /* sh */ ''
  #   substituteInPlace $out/share/applications/Mailspring.desktop \
  #     --replace Exec=mailspring Exec=$out/bin/mailspring
  # '';

  meta = with lib; {
    description = "Windscribe 2.0 desktop client for Windows, Mac and Linux";
    sourceProvenance = with sourceTypes; [binaryNativeCode];
    license = licenses.gpl2;
    # maintainers = with maintainers; [ toschmidt ];
    homepage = "https://getmailspring.com";
    downloadPage = "https://github.com/Foundry376/Mailspring";
    platforms = ["x86_64-linux"];
  };
}
