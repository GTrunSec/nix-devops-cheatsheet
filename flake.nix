{
  inputs.rust = {
    url = "github:gtrunsec/learn-rust";
    flake = false;
  };
  inputs.julia = {
    url = "github:gtrunsec/learn-julia";
    flake = false;
  };
  # inputs.python.url = "github:gtrunsec/learn-python";

  outputs = {...} @ inputs: {
    templates = {
      rust = {
        description = "Rust Environment";
        path = inputs.rust.outPath;
      };
      std-flakeParts-devenv = {
        description = "Std && flake-parts && devenv Environment";
        path = ./std;
      };
      emacs = {
        description = "Emacs Environment";
        path = ./emacs;
      };
      # python = {
      #   description = "python Environment";
      #   path = inputs.python.outPath;
      # };
      julia = {
        description = "Julia Environment";
        path = inputs.julia.outPath;
      };
      go = {
        description = "Go Environment";
        path = ./go;
      };
    };
  };
}
