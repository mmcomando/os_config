self: super:

{
  mm_hello = super.callPackage ./my_hello.nix {};
  mm_mesa = super.callPackage ./mm_mesa/default.nix {};  
}