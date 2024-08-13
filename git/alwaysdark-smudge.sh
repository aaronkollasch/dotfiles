#!/bin/bash
if [[ "$(uname -s)" == "Darwin" ]]; then
  val=$(defaults read -g AppleInterfaceStyle 2>/dev/null)
  if [[ $val == "Dark" ]]; then
    cat "$@"
  else
    if command -v gsed &>/dev/null; then
      gsed -e ':a' -e 'N' -e '$!ba' \
        -e 's/#LIGHT\n#\t/#LIGHT\n\t/g' -e 's/#DARK\n\t/#DARK\n#\t/g' \
        -e 's/#LIGHT\n# /#LIGHT\n /g' -e 's/#DARK\n /#DARK\n# /g' \
        -e 's/#LIGHT\n#-/#LIGHT\n-/g' -e 's/#DARK\n-/#DARK\n#-/g' \
        -e 's/"LIGHT\n" /"LIGHT\n /g' -e 's/"DARK\n /"DARK\n" /g' \
        -e 's/"workbench.colorTheme": "Darcula"/"workbench.colorTheme": "Night Owl Light (No Italics)"/g' \
        -e 's/--color=dark /--color=light/g' \
        "$@"
    else
      sed -e ':a' -e 'N' -e '$!ba' \
        -e 's/#LIGHT\n#\t/#LIGHT\n\t/g' -e 's/#DARK\n\t/#DARK\n#\t/g' \
        -e 's/#LIGHT\n# /#LIGHT\n /g' -e 's/#DARK\n /#DARK\n# /g' \
        -e 's/#LIGHT\n#-/#LIGHT\n-/g' -e 's/#DARK\n-/#DARK\n#-/g' \
        -e 's/"LIGHT\n" /"LIGHT\n /g' -e 's/"DARK\n /"DARK\n" /g' \
        -e 's/"workbench.colorTheme": "Darcula"/"workbench.colorTheme": "Night Owl Light (No Italics)"/g' \
        -e 's/--color=dark /--color=light/g' \
        "$@"
    fi
  fi
else
  cat "$@"
fi
