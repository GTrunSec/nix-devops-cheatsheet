{ pkgs, lib, budUtils, ... }: {
  bud.cmds = with pkgs; {
    test = {
      writer = budUtils.runner [ nixUnstable git coreutils ];
      synopsis = "test";
      help = "exec your script of second ctl";
      script = ./test.bash;
    };
  };
}
