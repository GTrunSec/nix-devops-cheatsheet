{
  outputs = {...} @ inputs: {
    templates = {
      rust = {
        description = "Rust Environment";
        path = ./rust;
      };
      std = {
        description = "Std Environment";
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
