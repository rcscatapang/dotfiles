# Create a directory and cd into it
mkd() {
    mkdir -p "$@" && cd "$_"
}

# Run artisan from any subdirectory of a Laravel project
artisan() {
    local dir="$PWD"
    while [[ "$dir" != "/" && ! -f "$dir/artisan" ]]; do dir="${dir:h}"; done
    [[ -f "$dir/artisan" ]] || { echo "Not inside a Laravel project"; return 1; }
    php "$dir/artisan" "$@"
}

# Fuzzy-select and switch to a local Git branch.
gbf() {
    local branch
    branch="$(git branch --format='%(refname:short)' | fzf --height=40% --reverse --prompt='Git branch> ')" || return
    [[ -n "$branch" ]] && git switch "$branch"
}

# Kill whatever is listening on a port: killport 8000
killport() {
    lsof -ti tcp:"$1" | xargs kill -9
}
