# Laravel / PHP
alias pa="php artisan"
alias mfs="php artisan migrate:fresh --seed"
alias pest="./vendor/bin/pest"
alias pp="./vendor/bin/pest --parallel"
alias ci="composer install"
alias cu="composer update"
alias cr="composer require"
alias cda="composer dump-autoload -o"

# Git (on top of the oh-my-zsh git plugin)
alias uncommit="git reset --soft HEAD~1"
alias nah="git reset --hard && git clean -df"

# Editors
alias phpstorm='open -a PhpStorm "$(pwd)"'

# Misc
alias python=python3
alias o="open ."
alias l="eza -la --group-directories-first --git"
alias tree="eza --tree"
alias c="claude"
alias reload="exec zsh"
alias dotfiles='cd "$DOTFILES"'
alias copykey="pbcopy < ~/.ssh/id_ed25519.pub && echo 'Public key copied'"
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias ip="curl -s ifconfig.me; echo"
