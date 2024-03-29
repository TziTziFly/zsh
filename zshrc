#!/bin/zsh
# This is meant to be sourced; shebang line is for editors

umask 027

# Let me type a ! in a filename without escaping it
set +o histexpand

# http://www.zsh.org/mla/workers/1996/msg00615.html
HISTSIZE=21000
SAVEHIST=20000
mkdir -p ~/.config/zsh
touch    ~/.config/zsh/history
HISTFILE=~/.config/zsh/history

# LS_COLORS is used by the :completion: setup below
# inlined eval "$(/usr/bin/dircolors -b)"
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:'

# Use modern completion system
autoload -Uz compinit
compinit

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Don't require typing the 'cd ' to change directory
# setopt autocd

# Prevent commands from entering history when preceded by a space
setopt hist_ignore_space

# Append commands to history immediately so that they show up in new shells
setopt inc_append_history

setopt append_history

# Make history instantly available in sibling shells:
setopt share_history

# Ignore "# comments" typed or pasted into an interactive shell
setopt interactivecomments

### Mostly essential stock settings from /etc/zsh/newuser.zshrc.recommended

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Don't exclude dotfiles when tab-completing
_comp_options+=(globdots)


### Terminal title configuration

# precmd is run before the prompt is displayed
precmd() {
	# Set the terminal title to 'hostname# pwd'
	print -Pn '\e]0;%m# %~\a'
}

# preexec is run after you hit Enter, but before the command is run
preexec() {
	# Set the terminal title to 'hostname# the command being run'
	#
	# See http://www.zsh.org/mla/users/2004/msg00948.html
	# "Re: question about quoting % in preexec" to understand
	# the escaping strategy here.
	print -Pn '\e]0;%m# '
	print -rn -- "$1"
	print -Pn '\a'
}


### Helper functions for prompt

fast-cat() {
	echo -E "$(< $1)"
}

print-git-branch() {
	if [[ -f ".git/HEAD" ]]; then
		echo -E ":${$(fast-cat .git/HEAD)#ref: refs/heads/}"
	fi
}


### System-wide environment

setopt promptsubst # needed for \$ evaluation
# PS1=HOST:PWD:GIT_BRANCH
PS1="\
$(print '%{\e[1;31m%}')%(1j.(%j) .)\
$(print '%{\e[0;36m%}')%d\
$(print '%{\e[1;31m%}')\$(print-git-branch)\
$(print '%{\e[0m%}') \
"

# Need to be in a comma locale for sort -n to properly sort numbers with commas
export LANG=en_US.UTF-8

export EDITOR=nvim
export PAGER=less

# -I / --IGNORE-CASE       - Make search ignore case, even if the pattern contains uppercase letters
# -M / --LONG-PROMPT       - Show line position at the bottom
# -x4                      - Set tab stops to multiples of 4
# -R / --RAW-CONTROL-CHARS - Show ANSI color escapes in raw form.  We use this
#                            with `git log` and `paged-with-color`.
export LESS="-IMx4R"
export LESSHISTFILE=-


### System-wide aliases

alias cp='cp -a'
alias mv='mv -i'
# Make du and df report sizes in bytes, with commas, like our ls
alias du="du --block-size=\'1"
alias df="df -T --block-size=\'1"

# LC_COLLATE=C fixes the sort order of .dotfiles (they should appear
# before any non-.dotfiles.)
#
# --block-size=\'1 shows commas at thousands places in file sizes
#
# -A / --almost-all shows hidden files except '.' and '..'
#
# -F / --classify appends indicator (one of */=>@|) to entries
# alias ls="LC_COLLATE=C ls --block-size=\'1 -A --color=auto -F --time-style=long-iso"
alias ls="LC_COLLATE=C ls --block-size=\'1 --color=auto -F --time-style=long-iso"

# List all files, sorted by mtime, most recent last
alias l='ls -lrt'
# List all files, sorted alphabetically
alias ll='ls -l'

disable r
if [ -f /usr/bin/tmux-resume ]; then
	alias r=tmux-resume
fi

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias rgrep='rgrep --color=auto'

if [ -f /usr/bin/pinned-git ]; then
	alias git=pinned-git
fi
alias gpr='git pull --rebase'
alias gb='git branch'
alias aggro='git gc --aggressive'
alias gd='git diff'
alias gbsu='git branch --set-upstream'
alias gs='git status'
alias gc='git commit'
alias gca='git commit -a'
alias gcam='git commit -a -m'

alias aginir='apt-get install --no-install-recommends'

# Typos caused by keyboard matrix circuit not releasing Shift fast enough
alias Grep=grep
alias Sort=sort

typeset -A program_to_color_flag
program_to_color_flag=(
	ls    --color=always
	# Assume `l` and `ll` are ls
	l     --color=always
	ll    --color=always
	grep  --color=always
	fgrep --color=always
	egrep --color=always
	rgrep --color=always
	rustc --color=always
	cargo --color=always
	tree  -C
	rg    --pretty
)

# force-enable coloring and pipe into less -RS
# Sample usage: paged-with-color ls -l
paged-with-color() {
	program=$1
	args=("$@")
	args=("$program" ${program_to_color_flag[$program]} "${args[@]:1}")
	# Use eval so that aliases work
	eval "${(q)args[@]}" | less -RS
}
alias p=paged-with-color


# Get xclip to actually copy to X clipboard:
alias xclip="xclip -selection clipboard"

# Shortcut to run rollout project:
alias rollout="sudo systemctl start docker && cd ~/code/rollout/ && ! mountpoint /mnt/spalvis || sudo docker compose up"

# Media:
alias movies="cd /mnt/spalvis/movies"
alias music="cd /mnt/spalvis/music"
alias tv="cd /mnt/spalvis/tv"


# Echo today/yesterday in YYYY-MM-DD format:
alias today="date -I"
alias yesterday='date --date "yesterday" +%Y-%m-%d'

alias emacs="emacs -nw"

# # Given a command, use info to read Info document if it exists, otherwise
# # use man to read the manpage.  This avoids using info's inferior manpage
# # renderer.
# info-or-man() {
# 	command=$1
# 	if info -w -- "$command" | grep -q "^/"; then
# 		info -- "$command"
# 	else
# 		man -- "$command"
# 	fi
# }
# alias man=info-or-man

# . /etc/zsh/zsh-autosuggestions.zsh
# source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# https://github.com/zsh-users/zsh-autosuggestions#configuration
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=6
# "Chooses the most recent match whose preceding history item matches the most
# recently executed command (more info). Note that this strategy won't work as
# expected with ZSH options that don't preserve the history order such as
# HIST_IGNORE_ALL_DUPS or HIST_EXPIRE_DUPS_FIRST"
# ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd

# FZF:
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh

export FZF_DEFAULT_COMMAND="rg --files"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Python
export PYTHONDONTWRITEBYTECODE=1
PATH=$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games

# Elixir
export ERL_AFLAGS="-kernel shell_history enabled"

# Rust
# source $HOME/.cargo/env

#export PATH="$HOME/.poetry/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
