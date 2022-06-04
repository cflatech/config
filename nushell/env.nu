# Nushell Environment Config File

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
use "~/.config/nushell/prompt.nu"
prompt set_prompt

use "~/.config/nushell/git.nu"

# asdf settings
let ASDF_BIN = "/opt/asdf-vm/bin"
let ASDF_USER_SHIMS = $"($env.HOME)/.asdf/shims"

let-env PATH = (
  if (($ASDF_BIN | path exists) && ($ASDF_USER_SHIMS | path exists)) {
    let-env PATH = ($env.PATH | split row (char esep) | prepend $"($ASDF_BIN)")
    let-env PATH = ($env.PATH | split row (char esep) | prepend $"($ASDF_USER_SHIMS)")
    echo $env.PATH
  } else {
    echo $env.PATH
  }
)