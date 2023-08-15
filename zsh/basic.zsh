# promptf
if [[ ! -n "$SSH_CONNECTION" ]]; then
  hostname_color='yellow'
else
  hostname_color='blue'
fi

function rprompt-git-current-branch {
  local branch_name st branch_status
  if git rev-parse 2> /dev/null; then
    branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
    st=`git status 2> /dev/null`
    if [[ -n `grep "^nothing to" <<<$st` ]]; then
      # 全てcommitされてクリーンな状態
      branch_status="[%F{green}"
    elif [[ -n `grep "^Untracked files" <<<$st` ]]; then
      # gitに管理されていないファイルがある状態
      branch_status="?[%F{red}"
    elif [[ -n `grep "^Changes not staged for commit" <<<$st` ]]; then
      # git addされていないファイルがある状態
      branch_status="+[%F{red}"
    elif [[ -n `grep "^Changes to be committed" <<<$st` ]]; then
      # git commitされていないファイルがある状態
      branch_status="![%F{yellow}"
    elif [[ -n `grep "^rebase in progress" <<<$st` ]]; then
      # コンフリクトが起こった状態
      branch_status="!?[%F{magenta}"
      branch_name="NO BRANCH"
    else
      # 上記以外の状態の場合は青色で表示させる
      branch_status="[%F{blue}"
    fi
    echo "${branch_status}$branch_name%f]"
  else
    return
  fi
}

prompt_1stline="[%F{cyan}%D %T%f%f] %B%(?.%F{green}↩%f.%F{red}↩%f)%b"
prompt_2ndline="%B%F{${hostname_color}}%n@%M:%f %~%b"
prompt_3rdline="%F{grey}$%f "
setopt prompt_subst
PROMPT="$prompt_1stline

$prompt_2ndline
$prompt_3rdline" # 平常時のプロンプト
RPROMPT='%B`rprompt-git-current-branch`%b' # 右プロンプト
PROMPT2="  " # コマンドの続き
SPROMPT=" %F{green}%r?%f " # 合ってる？



# change directory and edit file

if [[ -x `which peco 2> /dev/null` ]]; then
  function peco-path() {
    local filepath="$(find . | grep -v '/\.' | peco --layout=bottom-up --initial-filter Fuzzy --prompt 'PATH>')"
    [[ -z "$filepath" ]] && return
    if [[ -n "$LBUFFER" ]]; then
      BUFFER="$LBUFFER$filepath"
    else
      if [[ -d "$filepath" ]]; then
        BUFFER="cd $filepath"
      elif [[ -f "$filepath" ]]; then
        BUFFER="$EDITOR $filepath"
      fi
    fi
    CURSOR=$#BUFFER
  }

  zle -N peco-path
  bindkey '' peco-path
fi

# history

HISTFILE=$XDG_CACHE_HOME/.zsh_history
HISTSIZE=6000000
SAVEHIST=6000000
setopt hist_ignore_dups
setopt hist_ignore_space # 先頭が空白のコマンドを履歴に残さない
setopt share_history

if [[ -x `which peco 2> /dev/null` ]]; then
  function peco-select-history() {
    BUFFER="$(history -nr 1 | awk '!a[$0]++' | peco --layout=bottom-up --query "$LBUFFER" --prompt 'COMMAND>' | sed 's/\\n/\n/')"
    CURSOR=$#BUFFER
    zle -R -c
  }
  zle -N peco-select-history
  bindkey '' peco-select-history
else
  autoload history-search-end
  zle -N history-beginning-search-backward-end history-search-end
  zle -N history-beginning-search-forward-end history-search-end
  bindkey '' history-beginning-search-backward-end
  bindkey '' history-beginning-search-forward-end
fi

if [[ -x `which sk 2> /dev/null` ]]; then
  function sk-select-history() {
    BUFFER="$(history -nr 1 | awk '!a[$0]++' | sk --prompt 'COMMAND> ' --query "$LBUFFER" | sed 's/\\n/\n/')"
    CURSOR=$#BUFFER
    zle -R -c
  }
  zle -N sk-select-history
  bindkey '' sk-select-history
else
  autoload history-search-end
  zle -N history-beginning-search-backward-end history-search-end
  zle -N history-beginning-search-forward-end history-search-end
  bindkey '' history-beginning-search-backward-end
  bindkey '' history-beginning-search-forward-end
fi

# input completion

autoload -U compinit
setopt complete_aliases
setopt list_packed  # 補完候補の詰め詰め
zstyle ':completion:sudo:*' environ PATH="$SUDO_PATH:$PATH"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
compinit


