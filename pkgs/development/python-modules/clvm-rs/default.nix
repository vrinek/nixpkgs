{ lib
, fetchFromGitHub
, buildPythonPackage
, rustPlatform
, pythonOlder
, openssl
, perl
}:

buildPythonPackage rec {
  pname = "clvm_rs";
  version = "0.1.8";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "clvm_rs";
    rev = version;
    sha256 = "sha256:0fmk9bd91nzssx12xn9hzr7m8m9jcf0i1d0s5q94hy5zbxadq1v1";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256:000vkyqlbq35fg6k4c05qh52iw8m4xbzyh94y038zr9p0yjlr019";
  };

  format = "pyproject";

  nativeBuildInputs = [
    perl # used by openssl-sys to configure
  ] ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  buildInputs = [ openssl ];

  pythonImportsCheck = [ "clvm_rs" ];

  meta = with lib; {
    homepage = "https://chialisp.com/";
    description = "Rust implementation of clvm";
    license = licenses.asl20;
    maintainers = teams.chia.members;
  };
}
