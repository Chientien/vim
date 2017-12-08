" =============================================== 判断操作系统是否是 Windows 还是 Linux 
let g:iswindows = 0
let g:islinux = 0
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:iswindows = 1
else
    let g:islinux = 1
endif
" =============================================== 判断是终端还是 Gvim
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif
" =============================================== 以下为插件安装
set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=/home/jt/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/vundle'        " let Vundle manage Vundle, required
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'Yggdroot/indentLine'
Plugin 'majutsushi/tagbar'
Plugin 'Shougo/neocomplcache'
Plugin 'scrooloose/nerdtree'
call vundle#end()                " required
filetype plugin indent on        " required
" =============================================== Windows Gvim 默认配置,做了一点修改
if (g:iswindows && g:isGUI)
    source $VIMRUNTIME/vimrc_example.vim
    let $LANG = 'en'  "set message language
    set langmenu=en   "set menu's language of gvim. no spaces beside '='
    source $VIMRUNTIME/mswin.vim
    behave mswin
    set diffexpr=MyDiff()

    function MyDiff()
        let opt = '-a --binary '
        if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
        if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
        let arg1 = v:fname_in
        if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
        let arg2 = v:fname_new
        if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
        let arg3 = v:fname_out
        if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
        let eq = ''
        if $VIMRUNTIME =~ ' '
            if &sh =~ '\<cmd'
                let cmd = '""' . $VIMRUNTIME . '\diff"'
                let eq = '"'
            else
                let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
            endif
        else
            let cmd = $VIMRUNTIME . '\diff'
        endif
        silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
    endfunction
endif
" =============================================== Linux Gvim/Vim 默认配置,做了一点修改
if g:islinux
    set hlsearch        "高亮搜索
    set incsearch       "在输入要搜索的文字时，实时匹配

    " Uncomment the following to have Vim jump to the last position when
    " reopening a file
    if has("autocmd")
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    endif

    if g:isGUI
        " Source a global configuration file if available
        if filereadable("/etc/vim/gvimrc.local")
            source /etc/vim/gvimrc.local
        endif
    else
        runtime! debian.
        if has("syntax")
            syntax on
        endif

        set mouse=a                    " 在任何模式下启用鼠标
        set t_Co=256                   " 在终端启用256色
        set backspace=2                " 设置退格键可用
        " Source a global configuration file if available
        if filereadable("/etc/vim/vimrc.local")
            source /etc/vim/vimrc.local
        endif
    endif
endif
" =============================================== 以下为用户自定义配置
" 注：使用utf-8格式后，软件与程序源码、文件路径不能有中文，否则报错
set encoding=utf-8                                    "设置gvim内部编码，默认不更改
set fileencoding=utf-8                                "设置当前文件编码，可以更改，如：gbk（同cp936）
set fileencodings=ucs-bom,utf-8,gbk,cp936,latin-1     "设置支持打开的文件的编码

" 文件格式，默认 ffs=dos,unix
set fileformat=unix                                   "设置新（当前）文件的<EOL>格式，可以更改，如：dos（windows系统常用）
set fileformats=unix,dos,mac                          "给出文件的<EOL>格式类型

if (g:iswindows && g:isGUI)
    "解决菜单乱码
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim

    "解决consle输出乱码
    language messages zh_CN.utf-8
endif
" =============================================== 基础配置------>键盘设置
map <C-a> ggVGY                    "映射全选
map! <C-a> <Esc>ggVGY

vmap <C-c> "+y

nnoremap <C-F12> :vert diffsplit   " 按<C-F12>文件对比

map <F3> :tabnew.<CR>              " F3列出文件目录
map <C-F3> \be                     " 打开树状文件目录

inoremap aa <esc>
" =============================================== 编写文件时的配置
set shell=/bin/bash
filetype on                                           " 启用文件类型侦测
set noundofile                                        " 取消文件备份
filetype plugin on                                    " 针对不同的文件类型加载对应的插件
filetype plugin indent on                             " 启用缩进

set smartindent                                       " 启用智能对齐方式
set expandtab                                         " 将Tab键转换为空格

set tabstop=4
set shiftwidth=4
set softtabstop=4                                     "设置 删除 tab 的宽度

set smarttab                                          " 指定按一次backspace就删除shiftwidth宽度
set foldenable                                        " 启用折叠
"set foldmethod=indent                                " indent 折叠方式
set autoread                                         " 设置当文件被更改时自动载入
set completeopt=preview,menu                          " 代码补全
set clipboard+=unnamed                                " 共享剪贴板
set autowrite                                         " 自动保存
set confirm                                           " 在处理未保存或只读文件时弹出确认

" 常规模式下用空格键来开关光标行所在折叠（注：zR 展开所有折叠，zM 关闭所有折叠）
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
" 常规模式下输入 cS 清除行尾空格
nmap cS :%s/\s\+$//g<CR>:noh<CR>
" 常规模式下输入 cM 清除行尾 ^M 符号
nmap cM :%s/\r$//g<CR>:noh<CR>

set ignorecase                                        "搜索模式里忽略大小写
set smartcase                                         "如果搜索模式包含大写字符，不使用 'ignorecase' 选项，只有在输入搜索模式并且打开 'ignorecase' 选项时才会使用
set noincsearch                                       "在输入要搜索的文字时，取消实时匹配
" =============================================== 界面配置
set guifont=Monospace\ 11                               " 设置字体（字体名称空格用下划线代替）
set number                                            "显示行号
set ruler                                             "显示状态栏标尺
set laststatus=1                                      "启用状态栏信息
set cmdheight=2                                       "设置命令行的高度为2，默认为1
set cursorline                                        "突出显示当前行
set cursorcolumn
syntax enable                                         "启用语法高亮
syntax on
set shortmess=atI                                     "去掉欢迎界面
set showcmd                                           "输入的命令显示出来，看的清楚些
"set whichwrap+=<,>,h,l                               "允许backspace和光标键跨越行边界(不建议)
"set scrolloff=3                                      "光标移动到buffer的顶部和底部时保持3行距离
set novisualbell                                      "不要闪烁(不明白)
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}                                                "状态行显示的内容
set history=1000                                      " 设置历史记录数
set report=0                                          " 通过: commands命令，告诉我们文件的哪一行被更改过
" set fillchars=vert:\ ,stl:\ ,stinc:\                " 在被分割的窗口显示空白，便于阅读
set showmatch                                         " 高亮显示匹配的括号
set matchtime=1                                       " 匹配括号高亮的时间（单位是十分之一秒）
au BufRead,BufNewFile *  setfiletype txt              " 高亮显示普通的txt文件（需要txt.vim脚本）
hi pythonSelf            ctermfg=174 guifg=#6094DB cterm=bold gui=bold

" 设置 gVim 窗口初始位置及大小
if g:isGUI
    " au GUIEnter * simalt ~x                          "窗口启动时自动最大化
    winpos 100 10                                      "指定窗口出现的位置，坐标原点在屏幕左上角
    set lines=26 columns=80                            "指定窗口大小，lines为高度，columns为宽度
endif

" 设置代码配色方案
if g:isGUI
    colorscheme github               "Gvim配色方案
endif

" 显示/隐藏菜单栏、工具栏、滚动条，可用 Ctrl + F11 切换
if g:isGUI
    set guioptions-=m
    set guioptions-=T
    set guioptions-=r
    set guioptions-=L
    nmap <silent> <F11> :if &guioptions =~# 'm' <Bar>
        \set guioptions-=m <Bar>
        \set guioptions-=T <Bar>
        \set guioptions-=r <Bar>
        \set guioptions-=L <Bar>
    \else <Bar>
        \set guioptions+=m <Bar>
        \set guioptions+=T <Bar>
        \set guioptions+=r <Bar>
        \set guioptions+=L <Bar>
    \endif<CR>
endif

" -----------------------------------------------------------------------------
"  < 其它配置 >
" -----------------------------------------------------------------------------
set writebackup                             "保存文件前建立备份，保存成功后删除该备份
set nobackup                                "设置无备份文件
set noswapfile                              "设置无临时文件
au BufRead,BufNewFile,BufEnter * cd %:p:h   " 自动切换目录为当前编辑文件所在目录
" set vb t_vb=                              "关闭提示音

" =============================================================================
"                          << 以下为常用插件配置 >>
" =============================================== air-line 插件配置
set laststatus=2
let g:airline_theme="light"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

"设置切换Buffer快捷键"
nnoremap <C-tab> :bn<CR>
nnoremap <C-s-tab> :bp<CR>
" =============================================== indentLine 插件配置
" 用于显示对齐线，与 indent_guides 在显示方式上不同，根据自己喜好选择了
" 在终端上会有屏幕刷新的问题，这个问题能解决有更好了
nmap <leader>il :IndentLinesToggle<CR>      " 开启/关闭对齐线
let g:indentLine_char = "┊"
let g:indentLine_first_char = "┊"

" 设置终端对齐线颜色，如果不喜欢可以将其注释掉采用默认颜色
let g:indentLine_color_term = 239
" =============================================== neocomplcache 插件配置
" 关键字补全、文件路径补全、tag补全等等，各种，非常好用，速度超快。
let g:neocomplcache_enable_at_startup = 1     "vim 启动时启用插件
let g:neocomplcache_disable_auto_complete = 1 "不自动弹出补全列表
" 在弹出补全列表后用 <c-p> 或 <c-n> 进行上下选择效果比较好
let g:ycm_autoclose_preview_window_after_completion=1
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
" =============================================== Tagbar 插件配置
" 高效地浏览源码, 其功能就像vc中的workpace
" 那里面列出了当前文件中的所有宏,全局变量, 函数名等
nmap <F4> :TagbarToggle<CR>                             "设置快捷键  
let g:tagbar_width = 20                                 "设置宽度，默认为40  
"autocmd VimEnter * nested :call tagbar#autoopen(1)      "打开vim时自动打开  
let g:tagbar_left = 1                                   "在左侧 
" let g:tagbar_right = 1                                "在右侧  
" =============================================== NerdTree 插件配置
map <C-t> :NERDTreeToggle<CR>                           "设置快捷键 
" =============================================== ctags 工具配置
" 对浏览代码非常的方便,可以在函数,变量之间跳转等
set tags=./tags;                            "向上级目录递归查找tags文件（好像只有在Windows下才有用）
set autochdir
let Tlist_Sort_Type = "name"                " 按照名称排序  
let Tlist_Use_Right_Window = 1              " 在右侧显示窗口  
let Tlist_Compart_Format = 1                " 压缩方式  
let Tlist_Exist_OnlyWindow = 1              " 如果只有一个buffer，kill窗口也kill掉buffer  
let Tlist_File_Fold_Auto_Close = 0          " 不要关闭其他文件的tags  
let Tlist_Enable_Fold_Column = 0            " 不要显示折叠树  
"autocmd FileType java set tags+=D:\tools\java\tags   
"let Tlist_Show_One_File=1                  "不同时显示多个文件的tag，只显示当前文件的
" =============================================================================
"                          << 专为Fortran配置 >>
" =============================================================================
"fortran
if &filetype=='fortran'
	let s:extfname= expand("%:e")
	if s:extfname==? "f90"
	    let fortran_free_source=1
	    unlet! fortran_fixed_source
	else
	    let fortran_fixed_source=1
	    unlet! fortran_free_source
	endif
	let fortran_more_precise=1
	let fortran_do_enddo=1
	"去掉固定格式每行开头的红色填充
	let fortran_have_tabs=1
	"允许折叠
	let fortran_fold=1
	let fortran_fold_conditionals=1
	"折叠方式
	setfoldmethod=syntax
endif
" =============================================================================
"       << 代码运行快捷键 >>
" =============================================================================
" -----------------------------------------------------------------------------
"  < 编译、连接、运行配置 (目前只配置了C、C++、Java、python、Fortran、shell语言)>
" -----------------------------------------------------------------------------
map <c-b> :call CompileRunGcc()<CR>
imap <c-b> <Esc>:call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
        exec "!g++ % -o %<"
        exec "! ./%<"
    elseif &filetype == 'cpp'
        exec "!g++ % -o %<"
        exec "! ./%<"
    elseif &filetype == 'm'
        exec "!matlab -sd % -o %<"
        exec "! ./%<"
    elseif &filetype == 'fortran'
        exec "!gfortran % -o %<"
        exec "! ./%<"
    elseif &filetype == 'java'
        exec "!javac %"
        exec "!java .%<"
    elseif &filetype=='go'
        exec "!go build %<"
        exec "!time go run %"
    elseif &filetype == 'html'
        exec "!chrome % &"
    elseif &filetype == 'md' "MarkDown 解决方案为VIM + Chrome浏览器的MarkDown Preview Plus插件，保存后实时预览
        exec ":!open -a /Applications/Google\ Chrome.app/ % &"
    elseif &filetype == 'javascript'
        exec "!time node %"
    elseif &filetype == 'coffee'
        exec "!time coffee %"
    elseif &filetype == 'ruby'
        exec "!time ruby %"
    elseif &filetype == 'python'
        exec "!python3 %"
    elseif &filetype == 'sh'
        :!%
    endif
endfunc
"C,C++ 调试
map <F8> :call Rungdb()<CR>
func! Rungdb()
    exec "w"
    exec "!g++ % -g -o %<"
    exec "!gdb .%<"
endfunc
