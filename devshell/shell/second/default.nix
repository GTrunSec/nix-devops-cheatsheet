{ pkgs, lib, budUtils, ... }: {
  bud.cmds = with pkgs; {
    test = {
      writer = budUtils.writeBashWithPaths [ nixUnstable git coreutils ];
      synopsis = "test";
      help = "exec your script of second ctl";
      script = ./test.bash;
      extraScript = ''
        echo "test extraScript part"
        echo ${pkgs.hello}
        echo "---------------"
      '';
    };
  };
}
