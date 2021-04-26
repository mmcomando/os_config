{ lib, stdenv, fetchFromGitHub, cmake, zlib, cups }:

stdenv.mkDerivation rec {
  pname = "mm_brlaser";
  version = "7";

  src = fetchFromGitHub {
    owner = "QORTEC";
    repo = "brlaser";
    rev = "d3b07f150e3b5e41013e88abe53ee443598f54dc";
    sha256 = "05lpr4ny2p04p0sz3c9ki2zywvynwkimnwrk4in0kybvhk7djq9q";
  };
# {
#     "owner": "QORTEC",
#     "repo": "brlaser",
#     "rev": "d3b07f150e3b5e41013e88abe53ee443598f54dc",
#     "sha256": "05lpr4ny2p04p0sz3c9ki2zywvynwkimnwrk4in0kybvhk7djq9q",
#     "fetchSubmodules": true
# }
  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib cups ];

  cmakeFlags = [ "-DCUPS_SERVER_BIN=lib/cups" "-DCUPS_DATA_DIR=share/cups" ];

  meta = with lib; {
    description = "A CUPS driver for Brother laser printers";
    longDescription =
      ''
       Although most Brother printers support a standard printer language such as PCL or PostScript, not all do. If you have a monochrome Brother laser printer (or multi-function device) and the other open source drivers don't work, this one might help.
      '';
    homepage = "https://github.com/QORTEC/brlaser";
    license = licenses.gpl2;
    platforms = platforms.linux;
    # maintainers = with maintainers; [ StijnDW ];
  };
}