#!/bin/bash
if command -v gsed &>/dev/null; then
  gsed -e ':a' -e 'N' -e '$!ba' \
    -e 's/#DARK\n#\t/#DARK\n\t/g' -e 's/#LIGHT\n\t/#LIGHT\n#\t/g' \
    -e 's/#DARK\n# /#DARK\n /g' -e 's/#LIGHT\n /#LIGHT\n# /g' \
    -e 's/#DARK\n#-/#DARK\n-/g' -e 's/#LIGHT\n-/#LIGHT\n#-/g' \
    -e 's/"DARK\n" /"DARK\n /g' -e 's/"LIGHT\n /"LIGHT\n" /g' \
    -e 's/"workbench.colorTheme": "Night Owl Light (No Italics)"/"workbench.colorTheme": "Darcula"/g' \
    -e 's/--color=light/--color=dark /g' \
    "$@"
else
  sed -e ':a' -e 'N' -e '$!ba' \
    -e 's/#DARK\n#\t/#DARK\n\t/g' -e 's/#LIGHT\n\t/#LIGHT\n#\t/g' \
    -e 's/#DARK\n# /#DARK\n /g' -e 's/#LIGHT\n /#LIGHT\n# /g' \
    -e 's/#DARK\n#-/#DARK\n-/g' -e 's/#LIGHT\n-/#LIGHT\n#-/g' \
    -e 's/"DARK\n" /"DARK\n /g' -e 's/"LIGHT\n /"LIGHT\n" /g' \
    -e 's/"workbench.colorTheme": "Night Owl Light (No Italics)"/"workbench.colorTheme": "Darcula"/g' \
    -e 's/--color=light/--color=dark /g' \
    "$@"
fi
