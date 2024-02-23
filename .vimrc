call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-airline/vim-airline'
Plug 'jdhao/better-escape.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'joshdick/onedark.vim'
Plug 'vim-scripts/AutoComplPop'
Plug 'lervag/vimtex'
Plug 'christoomey/vim-tmux-navigator'

call plug#end()

" Tipo de codificación y sintaxis
set encoding=utf-8
syntax on
filetype plugin indent on

" Inserta números de línea relativos al cursor
set number relativenumber

if has('termguicolors')
    " Turns on 24-bit RGB color support
    set termguicolors

    " Defines how many colors should be used. (maximum: 256, minimum: 0)
    set t_Co=256
endif
" Colores del tema
set background=dark
colorscheme onedark

" Más opciones de autocompletado para los comandos
set wildmenu

" Modificaciones de tabulación
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab

" Modificaciones del retroceso
set backspace=indent,eol,start

" Destaca los patrones parciales de búsqueda
set incsearch

" Carga automáticamente los cambios al archivo que se hacen desde fuera de Vim
set autoread

" Muestra los comandos que se están escribiendo en la parte inferior derecha
set showcmd

" Habilita el ratón
set mouse=a

" Mueve la pantalla cuando el cursor se desplaza hasta los bordes
set scrolloff=5
set sidescrolloff=5

" Baja el tiempo de reacción al cambiar de modos
set ttimeout
set ttimeoutlen=1
set ttyfast

set hidden

set completeopt=menuone,preview,longest
set shortmess+=c

" Airline config
" Display all buffers when there's only one tab open
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#branch#enabled = 1

function! AirlineInit()
    let g:airline_section_b = airline#section#create(['branch'])
endfunction
autocmd VimEnter * call AirlineInit()
 
" Fondo con la transparencia de la terminal
autocmd VimEnter * hi Normal guibg=NONE ctermbg=NONE

" Cambiar Leader a la tecla de espacio
let mapleader=" "

" Configurar la combinación de teclas 'jj' para volver al modo normal
let g:better_escape_shortcut = 'jj'
let g:better_escape_interval = 200

" cambia la forma del cursor según modos (block en normal, beam en Insert y
" subrayado en Replace)
augroup cursor_autocmd
	au!
	au VimEnter,InsertLeave * silent execute '!echo -ne "\e[1 q"' | redraw!
	au InsertEnter,InsertChange * {
		if v:insertmode == 'i'
			silent execute '!echo -ne "\e[5 q"' | redraw!
		elseif v:insertmode == 'r'
			silent execute '!echo -ne "\e[3 q"' | redraw!
		endif
		}
	au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
	
augroup END

" Configuración de VimTeX 
let g:vimtex_view_method = 'general'
let g:vimtex_compiler_method = 'latexmk'
let g:tex_flavor = 'latex'
let maplocalleader = '\'
" Comandos a ejecutar si el archivo es .tex
augroup latex_autocmd
	" Enable filetype detection
	filetype plugin indent on

	" Check if editing a .tex file
	au FileType tex set complete-=i
	" Start compilation
	au BufEnter *.tex silent execute ':VimtexCompile' | redraw!
	" Launch evince with the corresponding PDF file
	au BufEnter *.tex silent execute '!evince %:r.pdf >/dev/null 2>&1 &'| redraw!
augroup END

" Function to show an R plot
function! RPlot()
	let l:plotname = 'Rplots.pdf'
	let l:scriptname = expand('%:p')
	let l:plotpath = expand('%:p:h') . '/' . l:plotname

	" Open only if file exists
	if filereadable(l:plotpath)
		let l:plot_modtime = getftime(l:plotpath)
		let l:script_modtime = getftime(l:scriptname)

		" Open only if it has been modified by the current script
		if l:plot_modtime >= l:script_modtime
			silent execute "!open " . l:plotname . " >/dev/null 2>&1 &" | redraw!
		endif
	endif
endfunction

" Función para ejecutar un script de R
function! RunRScript()
    let scriptname = expand('%:p')
    let term_buffer_name = 'Rterm'
	let output_file = '.output'
    
    " Check if the 'Rterm' buffer exists
    let term_buffer_exists = bufwinnr(term_buffer_name)

	silent execute "write"
    " Send the Rscript command to the existing terminal buffer or create a new one
    if term_buffer_exists == -1
        " If no 'Rterm' buffer exists, create a new one and send the command
        belowright vert term
        " Rename the terminal buffer to 'Rterm'
        setlocal nobuflisted buftype=nofile bufhidden=hide noswapfile nowrap
        execute 'file ' . term_buffer_name
	else
		" If the 'Rterm' buffer exists, send a command to quit 'less'
        call term_sendkeys(term_buffer_name, "q\<CR>")
    endif
	" Send the Rscript command to the 'Rterm' buffer
	call term_sendkeys(term_buffer_name, "R --quiet -f " . scriptname . " > " . output_file . " 2>&1 \<CR>")
	call term_sendkeys(term_buffer_name, "less " . output_file . "\<CR>")
	
	sleep 1
	call RPlot()
endfunction

" Write all buffers before navigating from vim to tmux pane
let g:tmux_navigator_save_on_switch = 2

""" Atajos generales
" Búsqueda con Espacio+s
nnoremap <Leader>s :%s//g<Left><Left>
" Guardar el archivo
nnoremap <Leader>w :w<CR>
" Nuevas tabs
nnoremap <Leader>t :tabnew<Space>
" Buffers
nnoremap <Leader>c :bun<CR>
nnoremap <Leader>d :bd<CR>
nnoremap <Leader><Tab> :bn<CR>
" Windows
nnoremap <Leader>v <C-W>v 
nnoremap <Leader>h <C-W>s

" FZF
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>p :GFiles<CR>
nnoremap <Leader>g :GFiles?<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>W :Windows<CR>
" R
nnoremap <Leader>r :call RunRScript()<CR>

" Autocompletar con tabulación
inoremap <expr> <Tab> pumvisible() ? "<C-y>" : "<Tab>"
