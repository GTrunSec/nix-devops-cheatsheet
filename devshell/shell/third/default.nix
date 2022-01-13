{ pkgs, lib, budUtils, ... }: {
  bud.cmds = with pkgs; {
    py = {
      writer = budUtils.runner [ python3Packages.isort ];
      synopsis = "py";
      help = "test your python script of third ctl";
      script = ./test.py;
    };
  };
}
