set nocompatible "不要使用vi的键盘模式，而是vim自己的  
source $VIMRUNTIME/mswin.vim  
:set colorcolumn=80

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""   
" GVIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""  
language messages zh_CN.utf-8   " 解决consle输出乱码  
"colorscheme desert              " 灰褐色主题  
set guioptions-=T       " 隐藏工具栏  
set noerrorbells        " 关闭错误提示音  
set nobackup            " 不要备份文件  
set linespace=0         " 字符间插入的像素行数目  
set shortmess=atI       " 启动的时候不显示那个援助索马里儿童的提示  
set novisualbell        " 不要闪烁   
set scrolloff=3         " 光标移动到buffer的顶部和底部时保持3行距离  
set mouse=a             " 可以在buffer的任何地方 ->  
set selection=exclusive         " 使用鼠标（类似office中 ->  
set selectmode=mouse,key        " 在工作区双击鼠标定位）  
set cursorline                  " 突出显示当前行  
set nu!   " 显示行号  
set whichwrap+=<,>,h,l        " 允许backspace和光标键跨越行边界   
set completeopt=longest,menu    "按Ctrl+N进行代码补全  
set noswapfile                  "设置没有swap文件  
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""   
" 文本格式和排版   
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""   
set list                        " 显示Tab符，->  
set listchars=tab:\|\ ,         " 使用一高亮竖线代替  
"set tabstop=4           " 制表符为4  
set autoindent          " 自动对齐（继承前一行的缩进方式）  
set smartindent         " 智能自动缩进（以c程序的方式）  
"set softtabstop=4   
set shiftwidth=2        " 换行时行间交错使用4个空格  
set expandtab         " 不要用空格代替制表符  
"set cindent         " 使用C样式的缩进  
"set smarttab            " 在行和段开始处使用制表符  
"set nowrap          " 不要换行显示一行   
set ts=2
set autoindent
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""  
" 状态行(命令行)的显示  
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""  
set cmdheight=2          " 命令行（在状态行下）的高度，默认为1，这里是2  
set ruler                " 右下角显示光标位置的状态行  
set laststatus=2         " 开启状态栏信息   
set wildmenu             " 增强模式中的命令行自动完成操作   
  
  
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""  
" 文件相关  
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""  
set fenc=utf-8  
set encoding=utf-8      " 设置vim的工作编码为utf-8，如果源文件不是此编码，vim会进行转换后显示  
set fileencoding=utf-8      " 让vim新建文件和保存文件使用utf-8编码  
set fileencodings=utf-8,gbk,cp936,latin-1  
filetype on                  " 侦测文件类型  
filetype indent on               " 针对不同的文件类型采用不同的缩进格式  
filetype plugin on               " 针对不同的文件类型加载对应的插件  
syntax on                    " 语法高亮  
filetype plugin indent on    " 启用自动补全  
  
  
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""  
" 查找  
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""  
set hlsearch                 " 开启高亮显示结果  
set nowrapscan               " 搜索到文件两端时不重新搜索  
set incsearch                " 开启实时搜索功能  
  
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""  
"--------引号 && 括号自动匹配  
" 插入匹配括号
inoremap ( ()<ESC>i
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap { {}<ESC>i
inoremap } <c-r>=ClosePair('}')<CR>
inoremap [ []<ESC>i
inoremap ] <c-r>=ClosePair(']')<CR>
inoremap < <><ESC>i
inoremap > <c-r>=ClosePair('>')<CR>
inoremap " "<ESC>i
inoremap " <c-r>=ClosePair('"')<CR>

function ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endf
" 按退格键时判断当前光标前一个字符，如果是左括号，则删除对应的右括号以及括号中间的内容
function! RemovePairs()
    let l:line = getline(".")
    let l:previous_char = l:line[col(".")-1] " 取得当前光标前一个字符

    if index(["(", "[", "{"], l:previous_char) != -1
        let l:original_pos = getpos(".")
        execute "normal %"
        let l:new_pos = getpos(".")

        " 如果没有匹配的右括号
        if l:original_pos == l:new_pos
            execute "normal! a\<BS>"
            return
        end

        let l:line2 = getline(".")
        if len(l:line2) == col(".")
            " 如果右括号是当前行最后一个字符
            execute "normal! v%xa"
        else
            " 如果右括号不是当前行最后一个字符
            execute "normal! v%xi"
        end

    else
        execute "normal! a\<BS>"
    end
endfunction
" 用退格键删除一个左括号时同时删除对应的右括号
inoremap <BS> <ESC>:call RemovePairs()<CR>a
"""""""""""""""""""""""""""""""xin tian jia de""""""""""""""""""""""""""""""""""""""""""""""""""""""""'''


"--------启用代码折叠，用空格键来开关折叠   
set foldenable           " 打开代码折叠  
set foldmethod=syntax        " 选择代码折叠类型  
set foldlevel=100            " 禁止自动折叠  
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc':'zo')<CR>   
  
