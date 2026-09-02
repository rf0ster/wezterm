local wezterm = require 'wezterm'

-- Palette, kept in step with colors.lua
local ACCENT       = "#47FF9C"
local ACTIVE_FG    = "#CBE0F0"
local INACTIVE_FG  = "#3D6180"
local HOVER_FG     = "#8FB8D8"
local TRANSPARENT  = "rgba(0, 0, 0, 0)"

-- A thin vertical bar marks the active tab; everything else is just spacing.
local MARKER = "▎"

-- Shells are noise: for those show the directory instead of the process.
local SHELLS = {
    zsh = true, bash = true, fish = true, sh = true, nu = true, ["-zsh"] = true,
}

local function basename(path)
    return path:gsub("/+$", ""):match("([^/]+)$")
end

local function tab_title(tab)
    -- An explicit title (tab:set_title / OSC 0) always wins.
    if tab.tab_title and #tab.tab_title > 0 then
        return tab.tab_title
    end

    local pane = tab.active_pane
    local proc = pane.foreground_process_name
    proc = proc and basename(proc) or nil

    if proc and not SHELLS[proc] then
        return proc
    end

    local cwd = pane.current_working_dir
    if cwd then
        -- Newer wezterm hands back a Url object, older ones a plain string.
        local path = type(cwd) == "string" and cwd or (cwd.file_path or tostring(cwd))
        path = path:gsub("^file://[^/]*", "")
        local dir = basename(path)
        if dir and #dir > 0 then
            return dir
        end
    end

    return pane.title
end

wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
    local title = tab_title(tab)
    title = wezterm.truncate_right(title, math.max(4, max_width - 6))
    local index = tostring(tab.tab_index + 1)

    if tab.is_active then
        return {
            { Foreground = { Color = ACCENT } },
            { Text = MARKER },
            { Foreground = { Color = ACTIVE_FG } },
            { Attribute = { Intensity = "Bold" } },
            { Text = " " .. index .. " " .. title .. "  " },
        }
    end

    return {
        { Foreground = { Color = INACTIVE_FG } },
        { Text = " " .. index .. " " .. title .. "  " },
    }
end)

-- Nudge the first tab in line with the terminal's 1cell left padding.
wezterm.on("update-status", function(window)
    window:set_left_status(wezterm.format { { Text = " " } })
end)

return {
    configure = function(config)
        config.enable_tab_bar = true
        config.hide_tab_bar_if_only_one_tab = true
        config.use_fancy_tab_bar = false
        config.tab_bar_at_bottom = false

        config.show_new_tab_button_in_tab_bar = false
        config.show_tab_index_in_tab_bar = false
        config.show_close_tab_button_in_tabs = false
        config.tab_max_width = 24

        config.colors = config.colors or {}
        config.colors.tab_bar = {
            background = TRANSPARENT,
            active_tab       = { bg_color = TRANSPARENT, fg_color = ACTIVE_FG },
            inactive_tab     = { bg_color = TRANSPARENT, fg_color = INACTIVE_FG },
            inactive_tab_hover = { bg_color = TRANSPARENT, fg_color = HOVER_FG, italic = false },
            new_tab          = { bg_color = TRANSPARENT, fg_color = INACTIVE_FG },
            new_tab_hover    = { bg_color = TRANSPARENT, fg_color = HOVER_FG, italic = false },
        }
    end
}
