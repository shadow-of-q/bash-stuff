
" Templates 
"
" Templates directory
let g:TEMPLATE_HOME = "~/.vim/templates"
"
" TT c	--> print template TEMPLATE_HOME/c on top of file (template top)
"
command -narg=1 TT :execute "0read ".TEMPLATE_HOME.expand("/<args>")
"
" TH f	--> print template TEMPLATE_HOME/c on current line (template here)
"
command -narg=1 TH :execute ".read ".TEMPLATE_HOME.expand("/<args>")
"
" LST   --> lists the templates directory
"
command -narg=0 TLS :execute "!ls ".TEMPLATE_HOME

