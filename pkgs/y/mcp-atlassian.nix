# Taken from https://github.com/joshsymonds/nix-config/blob/9ccffc52028c4df748be5be1804b4b414303ff28/pkgs/mcp-atlassian/default.nix
{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchPypi,
  rustPlatform,
  cargo,
  rustc,
}:
with python3Packages;
let
  # Pinned pydantic-core 2.33.2 — required by pydantic 2.11.10
  pydantic-core-pinned = buildPythonPackage rec {
    pname = "pydantic-core";
    version = "2.33.2";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "pydantic";
      repo = "pydantic-core";
      tag = "v${version}";
      hash = "sha256-2jUkd/Y92Iuq/A31cevqjZK4bCOp+AEC/MAnHSt2HLY=";
    };

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit pname version src;
      hash = "sha256-MY6Gxoz5Q7nCptR+zvdABh2agfbpqOtfTtor4pmkb9c=";
    };

    nativeBuildInputs = [
      cargo
      rustPlatform.cargoSetupHook
      rustPlatform.maturinBuildHook
      rustc
    ];

    dependencies = [ typing-extensions ];

    doCheck = false;
  };

  # Pinned pydantic <2.12.0 to avoid a breaking upstream change
  pydantic-pinned = buildPythonPackage rec {
    pname = "pydantic";
    version = "2.11.10";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-3CgPCYL72mw4+tpOR23ApPOur5xq1MKN9opmbsPGFCM=";
    };

    build-system = [
      hatch-fancy-pypi-readme
      hatchling
    ];

    dependencies = [
      annotated-types
      pydantic-core-pinned
      typing-extensions
      typing-inspection
    ];

    doCheck = false;
  };

  # pydantic-settings and mcp overridden to use pydantic-pinned, avoiding
  # two conflicting pydantic-core versions in the closure
  pydantic-settings-pinned = pydantic-settings.override {
    pydantic = pydantic-pinned;
  };

  mcp-pinned = mcp.override {
    pydantic = pydantic-pinned;
    pydantic-settings = pydantic-settings-pinned;
  };

  # Custom openapi-pydantic package (not in nixpkgs)
  openapi-pydantic = buildPythonPackage rec {
    pname = "openapi-pydantic";
    version = "0.5.1";
    src = fetchPypi {
      pname = "openapi_pydantic";
      inherit version;
      hash = "sha256-/2g1r2veekWfuT65O7krh0m3VPxuUbLxWQoZ3DAF7g0=";
    };
    pyproject = true;
    build-system = [ poetry-core ];
    propagatedBuildInputs = [ pydantic-pinned ];
    doCheck = false;
  };

  # Custom fastmcp package pinned to 2.3.5 for API compatibility
  fastmcp-2_3_5 = buildPythonPackage rec {
    pname = "fastmcp";
    version = "2.3.5";
    src = fetchPypi {
      inherit pname version;
      hash = "sha256-CeEXI8ZYjYwTVi1esE1CsTuR6zL1PO93zIwO4SGy+Qc=";
    };
    pyproject = true;
    build-system = [
      hatchling
      uv-dynamic-versioning
    ];
    propagatedBuildInputs = [
      exceptiongroup
      httpx
      mcp-pinned
      openapi-pydantic
      python-dotenv
      rich
      typer
      websockets
    ];
    pythonRelaxDeps = [
      "mcp" # Allow newer mcp versions
    ];
    doCheck = false;
  };

  # Custom markdown-to-confluence package (not in nixpkgs)
  markdown-to-confluence = buildPythonPackage rec {
    pname = "markdown-to-confluence";
    version = "0.3.0";
    src = fetchPypi {
      pname = "markdown_to_confluence";
      inherit version;
      hash = "sha256-CgnDujEYw9SgLVyZsFdaihQsq11OtI6JjJFcAukE/M4=";
    };
    pyproject = true;
    build-system = [ setuptools ];
    propagatedBuildInputs = [
      markdown
      lxml
      pymdown-extensions
      pyyaml
      requests
      # Type stubs (not needed at runtime but required by package metadata)
      types-pyyaml
      types-requests
      types-markdown
      types-lxml
    ];
    doCheck = false;
  };
in
buildPythonApplication rec {
  pname = "mcp-atlassian";
  version = "0.11.9";

  src = fetchFromGitHub {
    owner = "sooperset";
    repo = "mcp-atlassian";
    rev = "v${version}";
    hash = "sha256-R6edqlPgM63KRZO2rVmVWGjMRSNzIvD8P00A9vpdW9Y=";
  };

  pyproject = true;

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  propagatedBuildInputs = [
    atlassian-python-api
    requests
    beautifulsoup4
    httpx
    mcp-pinned
    fastmcp-2_3_5
    python-dotenv
    markdownify
    markdown
    markdown-to-confluence
    pydantic-pinned
    trio
    click
    uvicorn
    starlette
    thefuzz
    python-dateutil
    keyring
    cachetools
  ];

  pythonRelaxDeps = [
    "fastmcp" # We're using 2.3.5 instead of required 2.3.4
  ];

  # Remove type stub dependencies that are only needed for development
  pythonRemoveDeps = [
    "types-python-dateutil"
    "types-cachetools"
  ];

  # Disable checks for now as they require pytest
  doCheck = false;

  meta = with lib; {
    description = "MCP server for Atlassian products (Jira and Confluence)";
    homepage = "https://github.com/sooperset/mcp-atlassian";
    license = licenses.mit;
    maintainers = [ ];
  };
}
