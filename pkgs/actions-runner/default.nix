{ stdenv, fetchurl, autoPatchelfHook, buildEnv, makeWrapper
, coreutils
, curl
, gcc-unwrapped
, git
, glibc
, gnugrep
, gnutar
, gzip
, icu
, iputils
, kerberos
, lttng-ust
, openssl
, zlib
, writeShellScript
}:
let
  archMap = {
    "x86_64-linux" = {
      srcArch = "linux-x64";
      sha256 = "sha256-FiiPwjyyUxRY1/Kd9cFxHmDtEO4FsP+/mRgugau+2lI=";
    };
  };

  # https://github.com/actions/runner/blob/master/docs/start/envlinux.md
  runtime-deps = buildEnv {
    name = "github-actions-runtime-deps";
    paths = [
      coreutils
      glibc.bin # for ldd
      gnugrep
      gnutar
      gzip
      icu
      iputils.out
      openssl.bin
      openssl.dev
      openssl.out
    ];
  };

  withRuntimeDeps = writeShellScript "github-actions-with-runtime-deps.sh" ''
    export PATH=${runtime-deps}/bin
    export LD_LIBRARY_PATH=${runtime-deps}/lib
    exec "$@"
  '';
in
stdenv.mkDerivation rec {
  pname = "actions-runner";
  version = "2.163.1";
  src =
    with archMap.${stdenv.system} or (throw "system not supported");
    fetchurl
    {
      url = "https://githubassets.azureedge.net/runners/${version}/actions-runner-${srcArch}-${version}.tar.gz";
      inherit sha256;
    };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  # these are patched by autoPatchelfHook
  buildInputs = [
    curl
    gcc-unwrapped
    kerberos
    lttng-ust
    zlib
  ];

  # most tarballs contain one top-level folder. Not this one.
  preUnpack = ''
    _defaultUnpack() {
      mkdir src
      tar -C src -xf "$1"
    }
  '';

  postUnpack = ''
    # we don't need the musl version and nixpkgs doesn't package the right
    # musl libs for autoPatchelf
    rm -rf src/externals/node12_alpine
  '';

  installPhase = ''
    cp -r . $out

    ln -s ${withRuntimeDeps} $out/with-deps.sh
  '';
}
