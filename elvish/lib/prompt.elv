fn set {
  set edit:prompt = {
    var name = (styled (whoami)@(uname -n) '#dcdc8b');
    var current_dir = (tilde-abbr $pwd);
    var time = (styled (date +"%Y-%m-%d %I:%M:%S") green);
    (constantly "[" $time "]\n" $name (put ": ") $current_dir "\n" "$ ");
  }
  set edit:rprompt = {
    # if (eq (which git) == ) {
    #   # var branch = git branch

    # }
  }
}
