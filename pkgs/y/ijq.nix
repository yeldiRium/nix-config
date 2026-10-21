{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  scdoc,
}:
(buildGoModule rec {
  pname = "ijq";
  version = "v1.4.2";

  src = fetchFromGitHub {
    owner = "gpanders";
    repo = "ijq";
    rev = version;
    hash = "sha256-qvT8iREi8bi5T5/Ixli961cSNdymUe4z7xW7evng7sQ=";
  };
  vendorHash = "sha256-aU/0CIbI49OwgY6ioT50uPxld/rHAve3+KoILgPpWSQ=";

  nativeBuildInputs = [
    installShellFiles
    scdoc
  ];

  postBuild = ''
    scdoc < ijq.1.scd > ijq.1
    installManPage ijq.1
  '';
})
