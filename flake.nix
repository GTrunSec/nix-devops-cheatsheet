{
  outputs = {...}: {
    templates = {
      rust = {
        description = "Rust Environment";
        path = ./rust;
      };
      std-flakeParts-devenv = {
        description = "Std && flake-parts && devenv Environment";
        path = ./std;
      };
      emacs = {
        description = "Emacs Environment";
        path = ./emacs;
      };
      python = {
        description = "python Environment";
        path = ./python;
      };
      go = {
        description = "Go Environment";
        path = ./go;
      };
    };
  };
}
