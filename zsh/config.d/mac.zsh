alias uti="mdls -name kMDItemContentType -name kMDItemContentTypeTree"
alias ldd='otool -L "$@"'
alias jitouch-gesture-stats="rg -or '\$1' 'Gesture \"(.*?)\"' ~/Library/Logs/com.jitouch.Jitouch.log | sort | uniq -c | sort -nr"
alias brewdeps="brew leaves | xargs brew deps --include-build --tree"  # https://stackoverflow.com/questions/41029842/easy-way-to-have-homebrew-list-all-package-dependencies
