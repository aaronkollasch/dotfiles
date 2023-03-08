# add perl5
PATH="$HOME/.perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="$HOME/.perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="$HOME/.perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"$HOME/.perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=$HOME/.perl5"; export PERL_MM_OPT;

# rbenv init
if command -v rbenv &>/dev/null; then
    eval "$(rbenv init - zsh)"
fi

# rustup init
if [ -e "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

# add bob-nvim
if [ -d "$HOME/.local/share/bob/nvim-bin" ]; then
    export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
fi
