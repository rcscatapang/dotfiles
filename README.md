# dotfiles

Personal macOS setup for zsh, Git, Homebrew, PHP/Laravel, and other development tools.

## Install

- Clone the repository and run the installer:

  ```sh
  git clone git@github.com:rcscatapang/dotfiles.git ~/Workspace/code/dotfiles
  ~/Workspace/code/dotfiles/bin/install
  ```

- Add the optional Flutter and React Native toolchain with `bin/install --mobile` on a fresh machine or `bin/bootstrap-mobile` later.
- Open a new terminal when installation finishes, or reload the current shell with `exec zsh`.
- Existing dotfiles are moved to `~/.dotfiles-backup/<timestamp>/` before symlinks are created.
- The installer can be run from another clone or location; the most recently run clone replaces the existing symlinks and becomes active.
- Preview optional macOS preferences with `bin/set-defaults --dry-run`, then apply them with `bin/set-defaults`.
- Pass `--disable-hibernation` to `bin/set-defaults` only if traditional sleep without safe-sleep recovery is preferred.

## Included

- **Shell and terminal:** Oh My Zsh, Powerlevel10k, tmux, Ghostty, zsh plugins, fzf, ripgrep, fd, bat, eza, shellcheck, shfmt, jq, and yq.
- **Git and GitHub:** GitHub CLI, Git LFS, Delta, Lazygit, macOS Keychain credentials, sensible global defaults, and shared ignore rules.
- **Developer workflow:** direnv for project-specific environments.
- **Cloud tooling:** AWS CLI and Google Cloud CLI.
- **PHP and Laravel:** Herd, Composer, the Laravel installer, and PHP 8.2–8.5; PHP 8.5 is the default.
- **Other runtimes:** Node.js 22 through Herd's NVM, Go, rbenv, and rustup. Set `NODE_VERSION` to override the Node.js version.
- **Mobile development (optional):** Flutter, Android Studio, JDK 17, CocoaPods, and Android SDK packages shared by Flutter and React Native projects.
- **AI coding:** Codex, Claude Code, and a shared set of personal agent skills.
- **Databases and services:** DBngin, Docker Desktop, TablePlus, MySQL client, Meilisearch, Cloudflare Tunnel, ngrok, and Watchman.
- **Editors and API tools:** PhpStorm, Zed, Postman, 1Password, and the 1Password CLI.
- **Media and documents:** FFmpeg, ImageMagick, OCRmyPDF, whisper.cpp, Ghostscript, Poppler, qpdf, and Tesseract.
- **Dotfile configuration:** zsh, Powerlevel10k, Git, tmux, Ghostty, Zed, and portable PhpStorm settings.
- **Project-local tools:** Pest, Pint, PHPStan, React Native, and similar dependencies stay with each project so it controls its own versions.

## After installation

- Complete Herd's first-run prompts when the installer opens it; PHP and Node.js provisioning will then continue automatically.
- Sign in to 1Password and enable CLI integration if the `op` command should use the desktop session.
- Run `p10k configure` to regenerate the prompt for a different display.
- For mobile development, complete Android Studio's setup and licence prompts, install Xcode from the Mac App Store, and select emulator or simulator images as needed.
- Restore the standard portable-Mac hibernation mode with `sudo pmset -a hibernatemode 3` if hibernation was disabled.

## Machine-specific settings

- Put shell secrets, tokens, and machine-only paths in `~/.zshrc.local`.
- Put a work email or other Git overrides in `~/.gitconfig.local`.
- Keep both files untracked; the shared configuration loads them automatically.

## Shared agent skills

Personal skills live once in `config/agents/skills/`. The installer links each skill into both discovery locations:

- `~/.agents/skills/` for Codex
- `~/.claude/skills/` for Claude Code

`config/agents/skill-lock.json` records where the imported skills came from.

Run `bin/link-agent-skills` after adding or removing a skill. It leaves unrelated and application-managed skills in place, and backs up an existing real directory before replacing it with a link.

### TBD: Draft next skills

- Laravel/Pest development with Boost and project conventions
- Pull-request checks, review feedback, and summaries
- Dependency upgrades across Composer, npm, CocoaPods, and Flutter
- API contract and backward-compatibility reviews
- Releases, changelogs, tags, and release notes

Prefer skills that encode a recurring personal workflow or a non-obvious local constraint. Leave generic knowledge to the coding agent or its bundled skills.
