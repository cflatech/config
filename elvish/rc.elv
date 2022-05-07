var XDG_CONFIG_HOME = "~/.config/elvish"
set edit:prompt = {
  var name = (styled (whoami)@(uname -n) '#dcdc8b');
  var current_dir = (tilde-abbr $pwd);
  (constantly $name (put ": ") $current_dir);
  printf "\n$ ";
}
set edit:rprompt = {
  var time = (date +"%Y-%m-%d %I:%M:%S");
  (constantly '[' (styled $time green) ']');
}