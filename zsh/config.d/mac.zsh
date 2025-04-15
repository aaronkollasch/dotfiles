alias uti="mdls -name kMDItemContentType -name kMDItemContentTypeTree"
alias ldd='otool -L "$@"'
alias jitouch-gesture-stats="rg -or '\$1' 'Gesture \"(.*?)\"' ~/Library/Logs/com.jitouch.Jitouch.log | sort | uniq -c | sort -nr"
alias brewdeps="brew leaves | xargs brew deps --include-build --tree"  # https://stackoverflow.com/questions/41029842/easy-way-to-have-homebrew-list-all-package-dependencies
alias btmdump="sudo sfltool dumpbtm > ~/Documents/btmdump.text"  # https://eclecticlight.co/2023/02/15/controlling-login-and-background-items-in-ventura
alias ssh="LC_DARKMODE=$(defaults read -g AppleInterfaceStyle &>/dev/null && echo YES || echo NO) ssh"
function tmexclude () {
    sudo tmutil addexclusion "$@"
    sudo tmutil addexclusion -p "$@"
}
export tmexclude
