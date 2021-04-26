{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mm_hello";
  version = "1.0.0";

  src = ./mm_hello;

  configurePhase = ''
    declare -xp
  '';
  buildPhase = ''
    gcc "$src/mm_hello.c" -o ./mm_hello
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    cp ./mm_hello "$out/bin/"
  '';
}
