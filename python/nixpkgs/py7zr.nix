{
  lib,
  buildPythonPackage,
  fetchPypi,
  build,
  setuptools,
  setuptools-scm,
  brotli,
  brotlicffi,
  importlib-metadata,
  inflate64,
  multivolumefile,
  psutil,
  pybcj,
  pycryptodomex,
  pyppmd,
  pyzstd,
  texttable,
  check-manifest,
  flake8,
  flake8-black,
  flake8-deprecated,
  flake8-isort,
  isort,
  mypy,
  mypy-extensions,
  pygments,
  readme-renderer,
  twine,
  pytest,
  pytest-leaks,
  pytest-profiling,
  docutils,
  sphinx,
  sphinx-a4doc,
  sphinx-py3doc-enhanced-theme,
  coverage,
  coveralls,
  py-cpuinfo,
  pyannotate,
  pytest-benchmark,
  pytest-cov,
  pytest-remotedata,
  pytest-timeout,
  libarchive-c,
}:
buildPythonPackage rec {
  pname = "py7zr";
  version = "0.20.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HQH5jqHh9cSZQDWGkbIHb5pYSAVkJlQeeD3jODT1niE=";
  };

  nativeBuildInputs = [
    build
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    brotli
    brotlicffi
    importlib-metadata
    inflate64
    multivolumefile
    psutil
    pybcj
    pycryptodomex
    pyppmd
    pyzstd
    texttable
  ];

  passthru.optional-dependencies = {
    check = [
      check-manifest
      flake8
      flake8-black
      flake8-deprecated
      flake8-isort
      isort
      mypy
      mypy-extensions
      pygments
      readme-renderer
      twine
    ];
    debug = [
      pytest
      pytest-leaks
      pytest-profiling
    ];
    docs = [
      docutils
      sphinx
      sphinx-a4doc
      sphinx-py3doc-enhanced-theme
    ];
    test = [
      coverage
      coveralls
      py-cpuinfo
      pyannotate
      pytest
      pytest-benchmark
      pytest-cov
      pytest-remotedata
      pytest-timeout
    ];
    test_compat = [
      libarchive-c
    ];
  };

  pythonImportsCheck = ["py7zr"];

  meta = with lib; {
    description = "Pure python 7-zip library";
    homepage = "https://pypi.org/project/py7zr/";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [figsoda];
  };
}
