" dein settings {{{
" dein自体の自動インストール
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.vim') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath
" プラグイン読み込み＆キャッシュ作成
let s:toml_file = fnamemodify(expand('<sfile>'), ':h').'/dein.toml'
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir, [$MYVIMRC, s:toml_file])
  call dein#load_toml(s:toml_file)
  call dein#end()
  call dein#save_state()
endif
" 不足プラグインの自動インストール
if has('vim_starting') && dein#check_install()
  call dein#install()
endif
" }}}

" 挙動関連 {{{
"" スマートインデント
set smartindent
"" バックアップファイルを作成しない
set nobackup
"" スワップファイルを作成しない
set noswapfile
"" 折り返さない
set nowrap
"" インクリメンタルサーチ
set incsearch
"" バックスペース auto indentと改行を超える
set backspace=2
"" ビープ音を無効化
set vb t_vb=
""" マーカー文字列を埋め込んで折りたたみ
set foldmethod=marker
""" 折りたたみ状態表示列数
set foldcolumn=3
""" クリップボード設定
set clipboard+=unnamedplus

augroup FileTypeFoldMarker
  autocmd!
  autocmd BufNewFile,BufRead *.py setlocal commentstring=#%s
augroup END
"}}}

" 表示 {{{
"" 現在のモード表示
set showmode
"" 対応するカッコを表示
set showmatch
"" 入力中のコマンドをステータスに表示
set showcmd
"" 行数表示
set number
"" 常にステータスラインを表示
set laststatus=2

"" color scheme
""" 256色表示
set t_Co=256
""" 背景色を暗色時用に
set background=dark
colorscheme lucius
""" 構文ごとに色分け
syntax on
" インデント
"" 自動インデント 空白の数
set shiftwidth=4
"" タブの空白数
set tabstop=4
"" Tabの入力時の空白数
set softtabstop=4
"" tabを半角スペースに
set expandtab
"" 行ハイライト
set cursorline
highlight cursorline cterm=none
"" 不可視文字表示
set listchars=tab:»-,trail:_,eol:↲,extends:»,precedes:«,nbsp:%
"}}}
