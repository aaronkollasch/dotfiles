#!/usr/bin/env python3
# ~/Library/ApplicationSupport/iTerm2/Scripts/AutoLaunch/switch_automatic.py
# https://gist.github.com/FradSer/de1ca0989a9d615bd15dc6eaf712eb93
# https://gist.github.com/jamesmacfie/2061023e5365e8b6bfbbc20792ac90f8#file-auto_dark_mode-py

import os
import iterm2


async def changeTheme(theme_parts, connection):
    # set bat theme
    with open(os.path.expanduser("~/.config/bat/config"), "r") as f:
        s = f.read()
    with open(os.path.expanduser("~/.config/bat/config"), "w") as f:
        if "dark" in theme_parts:
            s = s.replace("#DARK\n#-", "#DARK\n-")
            s = s.replace("#LIGHT\n-", "#LIGHT\n#-")
        else:
            s = s.replace("#LIGHT\n#-", "#LIGHT\n-")
            s = s.replace("#DARK\n-", "#DARK\n#-")
        f.write(s)

    # set fzf theme
    with open(os.path.expanduser("~/.config/fzf/fzfrc"), "r") as f:
        s = f.read()
    with open(os.path.expanduser("~/.config/fzf/fzfrc"), "w") as f:
        if "dark" in theme_parts:
            s = s.replace("--color=light", "--color=dark ")
        else:
            s = s.replace("--color=dark ", "--color=light")
        f.write(s)

    # set vivid LS_COLORS theme
    with open(os.path.expanduser("~/.config/vivid/theme"), "r") as f:
        s = f.read()
    with open(os.path.expanduser("~/.config/vivid/theme"), "w") as f:
        if "dark" in theme_parts:
            s = s.replace("#DARK\n# ", "#DARK\n ")
            s = s.replace("#LIGHT\n ", "#LIGHT\n# ")
        else:
            s = s.replace("#LIGHT\n# ", "#LIGHT\n ")
            s = s.replace("#DARK\n ", "#DARK\n# ")
        f.write(s)

    # set delta theme
    with open(os.path.expanduser("~/.gitconfig"), "r") as f:
        s = f.read()
    with open(os.path.expanduser("~/.gitconfig"), "w") as f:
        if "dark" in theme_parts:
            s = s.replace("#DARK\n#\t", "#DARK\n\t")
            s = s.replace("#LIGHT\n\t", "#LIGHT\n#\t")
        else:
            s = s.replace("#LIGHT\n#\t", "#LIGHT\n\t")
            s = s.replace("#DARK\n\t", "#DARK\n#\t")
        f.write(s)
    with open(os.path.expanduser("~/.config/git/config"), "r") as f:
        s = f.read()
    with open(os.path.expanduser("~/.config/git/config"), "w") as f:
        if "dark" in theme_parts:
            s = s.replace("#DARK\n#\t", "#DARK\n\t")
            s = s.replace("#LIGHT\n\t", "#LIGHT\n#\t")
        else:
            s = s.replace("#LIGHT\n#\t", "#LIGHT\n\t")
            s = s.replace("#DARK\n\t", "#DARK\n#\t")
        f.write(s)

    # set vim theme
    with open(os.path.expanduser("~/.vimrc"), "r") as f:
        s = f.read()
    with open(os.path.expanduser("~/.vimrc"), "w") as f:
        if "dark" in theme_parts:
            s = s.replace('"DARK\n" ', '"DARK\n ')
            s = s.replace('"LIGHT\n ', '"LIGHT\n" ')
        else:
            s = s.replace('"LIGHT\n" ', '"LIGHT\n ')
            s = s.replace('"DARK\n ', '"DARK\n" ')
        f.write(s)

    # set nvim theme
    with open(os.path.expanduser("~/.config/nvim/lua/ak/colors.lua"), "r") as f:
        s = f.read()
    with open(os.path.expanduser("~/.config/nvim/lua/ak/colors.lua"), "w") as f:
        if "dark" in theme_parts:
            s = s.replace('"DARK\n" ', '"DARK\n ')
            s = s.replace('"LIGHT\n ', '"LIGHT\n" ')
        else:
            s = s.replace('"LIGHT\n" ', '"LIGHT\n ')
            s = s.replace('"DARK\n ', '"DARK\n" ')
        f.write(s)


async def main(connection):
    # Set color scheme correctly at app start
    app = await iterm2.async_get_app(connection)
    parts = await app.async_get_theme()
    await changeTheme(parts, connection)

    async with iterm2.VariableMonitor(
        connection, iterm2.VariableScopes.APP, "effectiveTheme", None
    ) as mon:
        while True:
            # Block until theme changes
            theme = await mon.async_get()
            parts = theme.split(" ")
            await changeTheme(parts, connection)


iterm2.run_forever(main)
