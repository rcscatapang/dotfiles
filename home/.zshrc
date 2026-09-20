typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Resolve the dotfiles repo from this file's real location (~/.zshrc is a symlink).
export DOTFILES="${${(%):-%x}:A:h:h}"

# Homebrew first, so everything below can find brew-installed tools.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# Fuzzy file/directory selection, command history (Ctrl-R), and completions.
command -v fzf > /dev/null 2>&1 && source <(fzf --zsh)

# Smarter directory navigation while retaining normal `cd` behavior.
command -v zoxide > /dev/null 2>&1 && eval "$(zoxide init zsh)"

# Prompt (run `p10k configure` to regenerate, then copy back into the repo).
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

source "$DOTFILES/shell/exports.zsh"
source "$DOTFILES/shell/aliases.zsh"
source "$DOTFILES/shell/functions.zsh"

# Herd (PHP, Composer, Node via nvm). Herd appends lines here on PHP installs;
# since ~/.zshrc is a symlink, they show up as a git diff in this repo.
export NVM_DIR="$HOME/Library/Application Support/Herd/config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[[ -f "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh" ]] && builtin source "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh"
export PATH="$HOME/Library/Application Support/Herd/bin/":$PATH
export HERD_PHP_81_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/81/"
export HERD_PHP_82_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/82/"
export HERD_PHP_83_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/83/"
export HERD_PHP_84_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/84/"
export HERD_PHP_85_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/85/"

# Ruby
command -v rbenv &> /dev/null && eval "$(rbenv init - zsh)"

# Google Cloud SDK
[[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]] && source "$HOME/google-cloud-sdk/path.zsh.inc"
[[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]] && source "$HOME/google-cloud-sdk/completion.zsh.inc"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# Machine-specific settings and secrets (not tracked).
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Must be sourced last.
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
