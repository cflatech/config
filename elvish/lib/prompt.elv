fn set {
  set edit:prompt = {
    var name = (styled (whoami)@(uname -n) '#dcdc8b');
    var current_dir = (tilde-abbr $pwd);
    var time = (styled (date +"%Y-%m-%d %I:%M:%S") green);
    # constagntly 後ろに与えられたvalueを出力する関数を作る関数
    (constantly "[" $time "]\n" $name (put ": ") $current_dir "\n" "$ ");
  }
  set edit:rprompt = {
    if (eq (which git) == ) {
      # var branch = git branch

    }
  }
}
