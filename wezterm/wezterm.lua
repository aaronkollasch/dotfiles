local wezterm = require("wezterm")
local act = wezterm.action

-- Lua string utilities
-- https://gist.github.com/kgriffs/124aae3ac80eefe57199451b823c24ec
function string:contains(sub)
    return self:find(sub, 1, true) ~= nil
end
function string:startswith(start)
    return self:sub(1, #start) == start
end
function string:endswith(ending)
    return ending == "" or self:sub(-#ending) == ending
end

------------
-- COLORS --
------------
-- local colors_dark = wezterm.color.get_default_colors()
-- colors_dark["background"] = '#181818'
-- local colors_dark = wezterm.color.get_builtin_schemes()['Hacktober']
-- local colors_dark = wezterm.color.get_builtin_schemes()['JetBrains Darcula']
local colors_dark = wezterm.color.get_builtin_schemes()["Edge Dark (base16)"]
colors_dark["background"] = "#1F1F1F"
colors_dark["cursor_fg"] = "black"
colors_dark["scrollbar_thumb"] = "#333333"

-- local nord_light = wezterm.color.get_builtin_schemes()['nord-light']
local edge_light = wezterm.color.get_builtin_schemes()["Edge Light (base16)"]
edge_light["foreground"] = "#171c25"
edge_light.selection_fg = "#171c25"
edge_light.selection_bg = "#c2deff"
edge_light.brights[1] = "#4b505b" -- black
edge_light.brights[2] = "#d05858" -- red
edge_light.brights[3] = "#608e32" -- green
edge_light.ansi[5] = "#5079be" -- blue
edge_light.brights[5] = "#276abc" -- blue
edge_light.ansi[6] = "#b05ccc" -- purple
edge_light.brights[6] = "#a64ac7" -- purple
edge_light.brights[7] = "#3a8b84" -- cyan
edge_light.brights[8] = "#4b505b" -- silver

local colors_light = edge_light
colors_light["background"] = "#FFFFFF"
colors_light["cursor_bg"] = "#333333"
colors_light["cursor_fg"] = "white"
colors_light["scrollbar_thumb"] = "#CCCCCC"
colors_light["tab_bar"] = {
    -- The color of the strip that goes along the top of the window
    -- (does not apply when fancy tab bar is in use)
    background = "#f1f1f1",
    -- The active tab is the one that has focus in the window
    active_tab = {
        -- The color of the background area for the tab
        bg_color = "#c2c7cb",
        -- The color of the text for the tab
        fg_color = "#171c25",
    },
    -- Inactive tabs are the tabs that do not have focus
    inactive_tab = {
        bg_color = "#a7acb0",
        fg_color = "#171c25",
    },
    -- You can configure some alternate styling when the mouse pointer
    -- moves over inactive tabs
    inactive_tab_hover = {
        bg_color = "#8d9195",
        fg_color = "#0b111b",
    },
    -- The new tab button that let you create new tabs
    new_tab = {
        bg_color = "#a7acb0",
        fg_color = "#171c25",
    },
    -- You can configure some alternate styling when the mouse pointer
    -- moves over the new tab button
    new_tab_hover = {
        bg_color = "#8d9195",
        fg_color = "#0b111b",
    },
}

local color_schemes = {
    ["Custom Dark"] = colors_dark,
    ["Custom Light"] = colors_light,
}

-- https://wezfurlong.org/wezterm/config/lua/wezterm.gui/get_appearance.html
local function scheme_for_appearance(appearance)
    if appearance:find("Dark") then
        return "Custom Dark"
    else
        return "Custom Light"
    end
end
local color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

local right_colors_dark, right_colors_light, right_text_fg_dark, right_text_fg_light
-- Color palette for the backgrounds of each cell
-- #52307c is the focus color; use hue 307deg
right_colors_dark = {
    "#361463",
    "#52307c",
    "#603e87",
    "#76559a",
    "#af93cc",
}
-- Foreground color for the text across the fade
right_text_fg_dark = "#c0c0c0"
-- Color palette for the backgrounds of each cell
-- #cda2fa is the focus color; others use same hue, 307deg
right_colors_light = {
    "#efdbff",
    "#cda2fa",
    "#b68ce3",
    "#a37acf",
    "#734d9e",
}
-- Foreground color for the text across the fade
right_text_fg_light = "#171c25"

----------------
-- STATUS BAR --
----------------
-- https://wezfurlong.org/wezterm/config/lua/window/set_right_status.html
wezterm.on("update-right-status", function(window, pane)
    -- Each element holds the text for a cell in a "powerline" style << fade
    local cells = {}

    -- Figure out the cwd and host of the current pane.
    -- This will pick up the hostname for the remote host if your
    -- shell is using OSC 7 on the remote host.
    local cwd_uri = pane:get_current_working_dir()
    if cwd_uri then
        cwd_uri = cwd_uri:sub(8)
        local slash = cwd_uri:find("/")
        local cwd = ""
        local hostname = ""
        if slash then
            hostname = cwd_uri:sub(1, slash - 1)
            -- Remove the domain name portion of the hostname
            local dot = hostname:find("[.]")
            if dot then
                hostname = hostname:sub(1, dot - 1)
            end
            -- and extract the cwd from the uri
            cwd = cwd_uri:sub(slash)

            table.insert(cells, cwd)
            table.insert(cells, hostname)
        end
    end

    -- I like my date/time in this style: "Wed Mar 3 08:14"
    local date = wezterm.strftime("%a %b %-d %H:%M")
    table.insert(cells, date)

    -- An entry for each battery (typically 0 or 1 battery)
    for _, b in ipairs(wezterm.battery_info()) do
        table.insert(cells, string.format("%.0f%%", b.state_of_charge * 100))
    end

    -- -- The powerline < symbol
    -- local LEFT_ARROW = utf8.char(0xe0b3)
    -- The filled in variant of the < symbol
    local LEFT_ARROW = utf8.char(0xe0b2)

    local colors = right_colors_dark
    local text_fg = right_text_fg_dark
    local appearance = wezterm.gui.get_appearance()
    if appearance:find("Light") then
        colors = right_colors_light
        text_fg = right_text_fg_light
    end

    -- The elements to be formatted
    local elements = {}
    -- How many cells have been formatted
    local num_cells = 0

    -- Insert initial left arrow
    table.insert(elements, { Foreground = { Color = colors[1] } })
    table.insert(elements, { Text = LEFT_ARROW })

    -- Translate a cell into elements
    local function push(text, is_last)
        local cell_no = num_cells + 1
        table.insert(elements, { Foreground = { Color = text_fg } })
        table.insert(elements, { Background = { Color = colors[cell_no] } })
        table.insert(elements, { Text = " " .. text .. " " })
        if not is_last then
            table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
            table.insert(elements, { Text = LEFT_ARROW })
        end
        num_cells = num_cells + 1
    end

    while #cells > 0 do
        local cell = table.remove(cells, 1)
        push(cell, #cells == 0)
    end

    window:set_right_status(wezterm.format(elements))
end)

-----------
-- FONTS --
-----------
local additional_fallback = {}
-- A helper function for my fallback fonts
-- https://wezfurlong.org/wezterm/config/lua/config/font_rules.html
local function font_with_fallback(name, params)
    local names = { name, "FiraCode NF", "Hack Nerd Font", table.unpack(additional_fallback) }
    return wezterm.font_with_fallback(names, params)
end

-- some host specific stuff
-- See also https://wezfurlong.org/wezterm/config/lua/wezterm/hostname.html
local font_size, main_font, bold_font, italic_font
if wezterm.target_triple:contains("-apple-darwin") then
    additional_fallback = { "AppleGothic" }
    font_size = 11.0
    main_font = font_with_fallback("SF Mono", { weight = "Medium" })
    italic_font = font_with_fallback("SF Mono", { weight = "Medium", style = "Italic" })
    bold_font = font_with_fallback("SF Mono", { weight = "Bold" })
else
    font_size = 11.0
    main_font = font_with_fallback("JetBrains Mono")
    italic_font = font_with_fallback("JetBrains Mono", { style = "Italic" })
    bold_font = font_with_fallback("JetBrains Mono", { weight = "Bold" })
end

---------
-- SSH --
---------
local ssh_domains = {
    {
        -- This name identifies the domain
        name = "crowley",
        -- The hostname or address to connect to. Will be used to match settings
        -- from your ssh config file
        remote_address = "crowley.nebula.kola.sh",
        -- The username to use on the remote host
        username = "aaron",
    },
    {
        -- This name identifies the domain
        name = "crowley.local",
        -- The hostname or address to connect to. Will be used to match settings
        -- from your ssh config file
        remote_address = "crowley.local",
        -- The username to use on the remote host
        username = "aaron",
    },
}

----------
-- KEYS --
----------
local default_clipboard = "Clipboard"
if wezterm.target_triple:contains("-linux-gnu") then
    default_clipboard = "PrimarySelection"
end
local keys = {
    {
        key = "c",
        mods = "CTRL|ALT",
        action = act.CopyTo(default_clipboard),
    },
    {
        key = "v",
        mods = "CTRL|ALT",
        action = act.PasteFrom(default_clipboard),
    },
    {
        key = "t",
        mods = "CTRL|ALT",
        action = act.SpawnTab("CurrentPaneDomain"),
    },
    {
        key = "n",
        mods = "CTRL|ALT",
        action = act.SpawnWindow,
    },
    {
        key = "w",
        mods = "CTRL|ALT",
        action = act.CloseCurrentTab({ confirm = true }),
    },
    {
        key = "f",
        mods = "CTRL|ALT",
        action = act.Search("CurrentSelectionOrEmptyString"),
    },
    {
        key = "r",
        mods = "CTRL|ALT",
        action = act.ReloadConfiguration,
    },
    {
        key = '"',
        mods = "CTRL|SHIFT",
        action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "|",
        mods = "CTRL|SHIFT",
        action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "J",
        mods = "CTRL|SHIFT",
        action = act.ActivatePaneDirection("Down"),
    },
    {
        key = "K",
        mods = "CTRL|SHIFT",
        action = act.ActivatePaneDirection("Up"),
    },
    {
        key = "L",
        mods = "CTRL|SHIFT",
        action = act.ActivatePaneDirection("Right"),
    },
    {
        key = "H",
        mods = "CTRL|SHIFT",
        action = act.ActivatePaneDirection("Left"),
    },
    {
        key = "O",
        mods = "CTRL|SHIFT",
        action = act.ActivatePaneDirection("Next"),
    },
    {
        key = "D",
        mods = "CTRL|SHIFT",
        action = act.ShowDebugOverlay,
    },
    {
        key = "!",
        mods = "CTRL|SHIFT",
        action = act.ActivateTab(0),
    },
    {
        key = "@",
        mods = "CTRL|SHIFT",
        action = act.ActivateTab(1),
    },
    {
        key = "#",
        mods = "CTRL|SHIFT",
        action = act.ActivateTab(2),
    },
    {
        key = "$",
        mods = "CTRL|SHIFT",
        action = act.ActivateTab(3),
    },
    {
        key = "%",
        mods = "CTRL|SHIFT",
        action = act.ActivateTab(4),
    },
    {
        key = "^",
        mods = "CTRL|SHIFT",
        action = act.ActivateTab(5),
    },
    {
        key = "&",
        mods = "CTRL|SHIFT",
        action = act.ActivateTab(6),
    },
    {
        key = "*",
        mods = "CTRL|SHIFT",
        action = act.ActivateTab(7),
    },
    {
        key = "(",
        mods = "CTRL|SHIFT",
        action = act.ActivateTab(8),
    },
    {
        key = ")",
        mods = "CTRL|SHIFT",
        action = act.ActivateTab(9),
    },
    { key = "UpArrow", mods = "CTRL|SHIFT", action = act.ScrollToPrompt(-1) },
    { key = "DownArrow", mods = "CTRL|SHIFT", action = act.ScrollToPrompt(1) },
    -- Rebind OPT-Left, OPT-Right as ALT-b, ALT-f respectively to match Terminal.app behavior
    {
        key = "LeftArrow",
        mods = "OPT",
        action = act.SendKey({ key = "b", mods = "ALT" }),
    },
    {
        key = "RightArrow",
        mods = "OPT",
        action = act.SendKey({ key = "f", mods = "ALT" }),
    },
    -- passthrough C-- and C-= modifiers
    { key = "=", mods = "CTRL", action = act.DisableDefaultAssignment },
    { key = "-", mods = "CTRL", action = act.DisableDefaultAssignment },
    { key = "0", mods = "CTRL", action = act.DisableDefaultAssignment },
}

if wezterm.target_triple:contains("-apple-darwin") then
    local mac_keys = {
        {
            key = '"',
            mods = "CMD|SHIFT",
            action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
        },
        {
            key = "|",
            mods = "CMD|SHIFT",
            action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
        },
        {
            key = "X",
            mods = "CMD|SHIFT",
            action = act.CloseCurrentPane({ confirm = true }),
        },
        {
            key = "D",
            mods = "CMD|SHIFT",
            action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
        },
        {
            key = "d",
            mods = "CMD",
            action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
        },
        {
            key = "J",
            mods = "CMD|SHIFT",
            action = act.ActivatePaneDirection("Down"),
        },
        {
            key = "K",
            mods = "CMD|SHIFT",
            action = act.ActivatePaneDirection("Up"),
        },
        {
            key = "L",
            mods = "CMD|SHIFT",
            action = act.ActivatePaneDirection("Right"),
        },
        {
            key = "H",
            mods = "CMD|SHIFT",
            action = act.ActivatePaneDirection("Left"),
        },
        {
            key = "O",
            mods = "CMD|SHIFT",
            action = act.ActivatePaneDirection("Next"),
        },
        { key = "UpArrow", mods = "CMD|SHIFT", action = act.ScrollToPrompt(-1) },
        { key = "DownArrow", mods = "CMD|SHIFT", action = act.ScrollToPrompt(1) },
        { key = "UpArrow", mods = "CMD", action = act.ScrollToTop },
        { key = "DownArrow", mods = "CMD", action = act.ScrollToBottom },
        {
            key = "Enter",
            mods = "CMD|SHIFT",
            action = wezterm.action.TogglePaneZoomState,
        },
        {
            key = ",",
            mods = "CMD",
            action = wezterm.action.SpawnCommandInNewTab({
                cwd = wezterm.home_dir .. "/.config/wezterm",
                args = { "vi", "./wezterm.lua" },
            }),
        },
    }
    for _, binding in pairs(mac_keys) do
        table.insert(keys, binding)
    end
elseif wezterm.target_triple:contains("-linux-gnu") then
    local linux_keys = {}
    for _, binding in pairs(linux_keys) do
        table.insert(keys, binding)
    end
end

local key_tables = {
    search_mode = {
        { key = "Enter", mods = "NONE", action = act.CopyMode("PriorMatch") },
        { key = "Enter", mods = "SHIFT", action = act.CopyMode("NextMatch") },
        { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
        { key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
        { key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
        { key = "r", mods = "CTRL", action = act.CopyMode("CycleMatchType") },
        { key = "u", mods = "CTRL", action = act.CopyMode("ClearPattern") },
        { key = "c", mods = "CTRL", action = act.CopyMode("Close") },
        {
            key = "PageUp",
            mods = "NONE",
            action = act.CopyMode("PriorMatchPage"),
        },
        {
            key = "PageDown",
            mods = "NONE",
            action = act.CopyMode("NextMatchPage"),
        },
        { key = "UpArrow", mods = "NONE", action = act.CopyMode("PriorMatch") },
        {
            key = "DownArrow",
            mods = "NONE",
            action = act.CopyMode("NextMatch"),
        },
    },
}

-----------
-- MOUSE --
-----------
local mouse_bindings = {
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "NONE",
        action = act.CompleteSelectionOrOpenLinkAtMouseCursor(default_clipboard),
        -- NOTE: the default action is:
        -- action=wezterm.action{CompleteSelectionOrOpenLinkAtMouseCursor="PrimarySelection"},
    },
    {
        event = { Down = { streak = 1, button = "Middle" } },
        mods = "NONE",
        action = act.PasteFrom(default_clipboard),
    },
    -- use ALT to select and ignore mouse mode
    {
        event = { Down = { streak = 1, button = "Left" } },
        mods = "ALT",
        mouse_reporting = true,
        action = act.SelectTextAtMouseCursor("Cell"),
    },
    {
        event = { Down = { streak = 2, button = "Left" } },
        mods = "ALT",
        action = act.SelectTextAtMouseCursor("Word"),
    },
    {
        event = { Down = { streak = 2, button = "Left" } },
        mods = "ALT",
        mouse_reporting = true,
        action = act.SelectTextAtMouseCursor("Word"),
    },
    {
        event = { Down = { streak = 3, button = "Left" } },
        mods = "ALT",
        action = act.SelectTextAtMouseCursor("Line"),
    },
    {
        event = { Down = { streak = 3, button = "Left" } },
        mods = "ALT",
        mouse_reporting = true,
        action = act.SelectTextAtMouseCursor("Line"),
    },
    {
        event = { Drag = { streak = 1, button = "Left" } },
        mods = "ALT",
        mouse_reporting = true,
        action = act.ExtendSelectionToMouseCursor("Cell"),
    },
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "ALT",
        action = act.CompleteSelection(default_clipboard),
    },
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "ALT",
        mouse_reporting = true,
        action = act.CompleteSelection(default_clipboard),
    },
}
local bypass_mouse_reporting_modifiers = "SHIFT"
if wezterm.target_triple:contains("-apple-darwin") then
    bypass_mouse_reporting_modifiers = "ALT"
end

----------
-- MISC --
----------
local initial_cols = 175
local initial_rows = 56
if wezterm.target_triple:contains("-apple-darwin") then
    initial_cols = 200
    initial_rows = 64
end

------------
-- RETURN --
------------
return {
    ssh_domains = ssh_domains,
    font = main_font,
    font_size = font_size,
    font_rules = {
        {
            italic = true,
            font = italic_font,
        },
        {
            intensity = "Bold",
            font = bold_font,
        },
    },
    keys = keys,
    key_tables = key_tables,
    send_composed_key_when_left_alt_is_pressed = true,
    send_composed_key_when_right_alt_is_pressed = false,
    mouse_bindings = mouse_bindings,
    bypass_mouse_reporting_modifiers = bypass_mouse_reporting_modifiers,
    color_schemes = color_schemes,
    color_scheme = color_scheme,
    scrollback_lines = 10000,
    enable_scroll_bar = true,
    use_fancy_tab_bar = false,
    hide_tab_bar_if_only_one_tab = false,
    initial_cols = initial_cols,
    initial_rows = initial_rows,
    use_resize_increments = true,
    warn_about_missing_glyphs = false,
    -- debug_key_events = true,
}
