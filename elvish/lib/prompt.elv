set edit:prompt = {
  var name = (styled (whoami)@(uname -n) '#dcdc8b');
  var current_dir = (tilde-abbr $pwd);
  var time = (styled (date +"%Y-%m-%d %I:%M:%S") green);
  (constantly "[" $time "]\n\n" $name (put ": ") $current_dir "\n" "$ ");
}

set edit:rprompt = {
  # git branch がエラーを起こす状況(git管理外フォルダ等)なら処理しない
  if (eq ?(git branch 2> /dev/null) $ok) {
    var branch_name = (git rev-parse --abbrev-ref HEAD 2> /dev/null)
    var color;

    if (eq ?(git status | rg "^nothing to") $ok) {
      set color = green
    } elif (eq ?(git status | rg "^Untracked files") $ok) {
      set color = red
    } elif (eq ?(git status | rg "^Changes not staged for commit") $ok) {
      set color = red
    } elif (eq ?(git status | rg "^Changes to be committed") $ok) {
      set color = yellow
    } elif (eq ?(git status | rg "^rebase in progress") $ok) {
      set color = magenta
    } else {
      set color = blue
    }

    (constantly "[" (styled $branch_name $color) "]")
  }
}
