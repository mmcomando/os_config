self: super:

{
  mm_hello = super.callPackage ./my_hello.nix {};
  mm_printer_hll2350dw = super.callPackage ./mm_printer_hll2350dw.nix {};
  mm_brlaser = super.callPackage ./mm_brlaser.nix {};
  
}