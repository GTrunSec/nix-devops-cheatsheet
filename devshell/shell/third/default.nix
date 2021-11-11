{ pkgs, lib, budUtils, ... }: {
  bud.cmds = with pkgs; {
    py = {
      writer = budUtils.writeBashWithPaths [ python39 python39Packages.isort ];
      synopsis = "py";
      help = "test your python script of third ctl";
      script = ./test.py;
    };
  };
}
