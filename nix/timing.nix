{
  stdenv,
  lib,
  gnumake,
  verilator,
  binutils,
  zlib,
}: let
  self = stdenv.mkDerivation rec {
    name = "verilator-timing";

    src = with lib.fileset;
      toSource {
        root = ./../src/test/examples;
        fileset = unions [
          ./../src/test/examples/timing
        ];
      };

    nativeBuildInputs = [
      gnumake
      verilator
      binutils
      zlib
    ];

    buildPhase = ''
      verilator --cc -trace-fst --exe -Wall --timing -O1 -sv \
        timing/top.sv timing/tb.sv timing/main.cc \
        --top-module tb --CFLAGS "-DTRACE=1"

      cd obj_dir && make -f Vtb.mk
    '';

    installPhase = ''
      mkdir -p $out/bin $out/include $out/lib $out/obj_dir
      cp *.h $out/include
      cp *.a $out/lib
      cp *.o $out/obj_dir
      cp Vtb $out/bin
    '';

    meta.description = "System Verilog testbench for verilator";
  };
in
  self
