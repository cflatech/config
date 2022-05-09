def create_left_prompt [] {
  let user_name = (whoami | str trim)
  let host_name = (uname -n | str trim)
  let path_segment = ($env.PWD)
  let branch_state = get_branch_state

  print (
    (ansi y)
    + $"\n($user_name)@($host_name):"
    + (ansi w)
    + $path_segment
    + " "
    + $branch_state
  )
}

def get_branch_state [] {
  let branch_result = (do -i { git rev-parse --abbrev-ref HEAD } | complete)
  let status_result = (do -i { git status } | complete)

  if ($branch_result.exit_code == 0 && $status_result.exit_code == 0) {
    let branch_name = ($branch_result.stdout | str trim)
    let status = ($status_result.stdout | str trim)
    let color = get_branch_color $status

    echo $"[($color + $branch_name)(ansi w)]"
  } else {
    echo ""
  }
}

def get_branch_color [status] {
    if (($status | rg "^nothing to" | complete).exit_code == 0) {
      ansi g
    } else if (($status | rg "^Untracked files" | complete).exit_code == 0) {
      ansi r
    } else if (($status | rg "^Changes not staged for commit" | complete).exit_code == 0) {
      ansi r
    } else if (($status | rg "^Changes to be committed" | complete).exit_code == 0) {
      ansi y
    } else if (($status | rg "^rebase in progress" | complete).exit_code == 0) {
      ansi p
    } else {
      ansi u
    }
}

def create_right_prompt [] {
  let time_segment = ([
      (date now | date format '%Y/%m/%d %r')
  ] | str collect)

  $time_segment
}

# Use nushell functions to define your right and left prompt
export def-env set_prompt [] {
  let-env PROMPT_COMMAND = { create_left_prompt }
  let-env PROMPT_COMMAND_RIGHT = { create_right_prompt }
}
