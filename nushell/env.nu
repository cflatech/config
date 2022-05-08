# Nushell Environment Config File

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

  if ($branch_result.exit_code == 0) {
    let branch_name = ($branch_result.stdout | str trim)
    let status = (git status)
    let color = get_branch_color $status

    echo $"[($color + $branch_name)(ansi w)]"
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
let-env PROMPT_COMMAND = { create_left_prompt }
let-env PROMPT_COMMAND_RIGHT = { create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
let-env PROMPT_INDICATOR = { "> " }
let-env PROMPT_INDICATOR_VI_INSERT = { ": " }
let-env PROMPT_INDICATOR_VI_NORMAL = { "> " }
let-env PROMPT_MULTILINE_INDICATOR = { "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
let-env ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | str collect (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | str collect (char esep) }
  }
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
let-env NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
let-env NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# let-env PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
