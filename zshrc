autoload -U colors && colors

PS1="%{$fg[green]%}%n %{$fg[blue]%}%~ %{$fg[red]%}$%{$reset_color%} "

alias ls="ls -G"
alias ll="ls -l"
alias la="ls -la"
alias lt="ls -lhrt"
