set nocompatible              " required
filetype off                  " required

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
 
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

call plug#begin('~/.vim/plugged')

" 目录数
Plug 'preservim/nerdtree'
" 代码块
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

call plug#end()

" Ultisnips
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<c-e>"
let g:UltiSnipsJumpBackwardTrigger="<c-d>"
let g:UltiSnipsSnippetDirectories = [$HOME.'/.config/vim/Ultisnips/', 'UltiSnips']

" vim基本设置
set cursorline "突出显示当前行
set incsearch	"打开实时查找高亮模式
set pastetoggle=<C-s>
set nocompatible "关闭与vi的兼容模式
set number "显示行号
set nowrap    "不自动折行
set showmatch    "显示匹配的括号
set scrolloff=10        "距离顶部和底部10行"
set encoding=utf-8  "编码
set fenc=utf-8      "编码
set mouse=a        "启用鼠标
set hlsearch        "搜索高亮
syntax enable    "语法高亮
set clipboard=unnamed
set foldmethod=indent
set background=light
colorscheme solarized
map <C-m> :%s///gn<CR>	"查看当前模式匹配个数
map <C-c> :IndentGuidesToggle<CR>	" 缩进可视化
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
colorscheme delek
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" 代码折叠
let g:SimpylFold_docstring_preview=1

" markdown设置

autocmd Filetype markdown inoremap ,f <Esc>/<++><CR>:nohlsearch<CR>c4l
autocmd Filetype markdown inoremap ,n ---<Enter><Enter>
autocmd Filetype markdown inoremap ,b **** <++><Esc>F*hi
autocmd Filetype markdown inoremap ,s ~~~~ <++><Esc>F~hi
autocmd Filetype markdown inoremap ,i ** <++><Esc>F*i
autocmd Filetype markdown inoremap ,d `` <++><Esc>F`i
autocmd Filetype markdown inoremap ,c ```<Enter><++><Enter>```<Enter><Enter><++><Esc>4kA
autocmd Filetype markdown inoremap ,h ====<Space><++><Esc>F=hi
autocmd Filetype markdown inoremap ,p ![](<++>) <++><Esc>F[a
autocmd Filetype markdown inoremap ,a [](<++>) <++><Esc>F[a
autocmd Filetype markdown inoremap ,1 #<Space><Enter><++><Esc>kA
autocmd Filetype markdown inoremap ,2 ##<Space><Enter><++><Esc>kA
autocmd Filetype markdown inoremap ,3 ###<Space><Enter><++><Esc>kA
autocmd Filetype markdown inoremap ,4 ####<Space><Enter><++><Esc>kA
autocmd Filetype markdown inoremap ,l --------<Enter>

"为py文件添加下支持pep8风格的配置"
au BufNewFile,BufRead *.py
\ set tabstop=4   "tab宽度
\ set softtabstop=4 
\ set shiftwidth=4  
\ set textwidth=79  "行最大宽度
\ set expandtab       "tab替换为空格键
\ set autoindent      "自动缩进
\ set fileformat=unix   "保存文件格式


"一键执行python代码，按control+p执行"
map <C-p> :call RunPython()<CR>
func! RunPython()
    exec "W"
    if &filetype == 'python'
        exec "!time python3 %"
    endif
endfunc

let python_highlight_all=1


" nerdtree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") && v:this_session == "" | NERDTree | endif
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
map <C-n> :NERDTreeToggle<CR>

let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_stubs_command = "<leader>s"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<leader>r"

" tagbar标签导航
nmap <Leader>t :TagbarToggle<CR>
let g:tagbar_ctags_bin='/usr/bin/ctags'
let g:tagbar_width=30
autocmd BufReadPost *.cpp,*.c,*.h,*.hpp,*.cc,*.cxx call tagbar#autoopen()
let g:jedi#auto_initialization = 1
 
" 主题 solarized
let g:solarized_termtrans=1
let g:solarized_contrast="normal"
let g:solarized_visibility="normal"

" 配色方案
syntax enable
set background=dark
colorscheme solarized

" ctrlp文件搜索
" 打开ctrlp搜索
let g:ctrlp_map = '<leader>f'
let g:ctrlp_cmd = 'CtrlP'

" 相当于mru功能，show recently opened files
map <leader>fp :CtrlPMRU<CR>
" set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux"
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn|rvm)$',
    \ 'file': '\v\.(exe|so|dll|zip|tar|tar.gz)$',
    \ }
"\ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
let g:ctrlp_working_path_mode=0
let g:ctrlp_match_window_bottom=1
let g:ctrlp_max_height=15
let g:ctrlp_match_window_reversed=0
let g:ctrlp_mruf_max=500
let g:ctrlp_follow_symlinks=1
 
" vim-powerline美化状态
" let g:Powerline_symbols = 'fancy'
let g:Powerline_symbols = 'unicode'
 
" 括号匹配高亮
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]
let g:rbpt_max = 40
let g:rbpt_loadcmd_toggle = 0
 
" pythom-mode
let g:pymode = 1
let g:pymode_options = 1
let g:pymode_indent = 1
let g:pymode_folding = 0
let g:pymode_motion = 1
let g:pymode_doc = 1
let g:pymode_doc_bind = 'K'
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_bind = '<leader>b'
