# Editor
export EDITOR="zed --wait"
export VISUAL="$EDITOR"

# Locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# History
export HISTSIZE=50000
export SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS SHARE_HISTORY

# Homebrew
export HOMEBREW_NO_ANALYTICS=1

# Bold blue directories complement the Ghostty palette; type suffixes provide a non-color cue.
export EZA_COLORS="di=1;34"

# PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH="/opt/homebrew/opt/rustup/bin:$PATH"
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
export PATH="$PATH:/Applications/PhpStorm.app/Contents/MacOS"

# Mobile development (Flutter and React Native)
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
export PATH="$ANDROID_HOME/emulator:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
if /usr/libexec/java_home -v 17 >/dev/null 2>&1; then
    export JAVA_HOME
    JAVA_HOME="$(/usr/libexec/java_home -v 17)"
fi
# Keep an existing manual Flutter SDK usable until Homebrew manages it.
[ -d "$HOME/Development/flutter/bin" ] && export PATH="$PATH:$HOME/Development/flutter/bin"
