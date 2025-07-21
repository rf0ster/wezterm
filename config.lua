-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration
local config = wezterm.config_builder()
config.color_scheme = 'Cyberdyne'
config.window_background_opacity = 0.6

local bg_color = "rgba(21, 17, 68, 0.6)"
config.colors = {
    tab_bar = {
        background = bg_color,
        active_tab = {
            bg_color = bg_color,
            fg_color = "#ffffff",
            intensity = "Bold",
            underline = "None",
            italic = false,
            strikethrough = false,
        },
        inactive_tab = {
            bg_color = bg_color,
            fg_color = "#888888",
        },
        inactive_tab_hover = {
            bg_color = bg_color,
            fg_color = "#ffffff",
        },
        new_tab = {
            bg_color = bg_color,
            fg_color = "#888888",
        },
        new_tab_hover = {
            bg_color = bg_color,
            fg_color = "#ffffff",
        },
    }
}
config.font_size = 14
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
-- always show the tab bar
config.enable_tab_bar = true


-- Keybindings for moving between split panes
config.keys = {
    -- Split panes
    { key="h", mods="CTRL|ALT", action=wezterm.action.SplitPane({ direction = "Left", })},
    { key="j", mods="CTRL|ALT", action=wezterm.action.SplitPane({ direction = "Down", size = { Percent = 20 } })},
    { key="k", mods="CTRL|ALT", action=wezterm.action.SplitPane({ direction = "Up", size = { Percent = 20 } })},
    { key="l", mods="CTRL|ALT", action=wezterm.action.SplitPane({ direction = "Right", })},
    { key = "-", mods = "CTRL", action = wezterm.action_callback(function(_, pane)
            local tab = pane:tab()
            local panes = tab:panes_with_info()
            if #panes == 1 then
                pane:split({
                    direction = "Bottom",
                    size = 0.2,
                })
            elseif not panes[1].is_zoomed then
                panes[1].pane:activate()
                tab:set_zoomed(true)
            elseif panes[1].is_zoomed then
                tab:set_zoomed(false)
                panes[2].pane:activate()
            end
        end),
    },
    -- Expand the size of the entire wezterm window to be the full size of the screen
    { key="=", mods="CTRL", action=wezterm.action.ToggleFullScreen},

    -- Adjust the size of the pane
    -- Shrink the pane to the left
    { key="h", mods="CTRL|SHIFT", action=wezterm.action({AdjustPaneSize={"Left", 3}})},
    -- Expand the pane to the right
    { key="l", mods="CTRL|SHIFT", action=wezterm.action({AdjustPaneSize={"Right", 3}})},
    -- Shrink the pane upward
    { key="k", mods="CTRL|SHIFT", action=wezterm.action({AdjustPaneSize={"Up", 3}})},
    -- Expand the pane downward
    { key="j", mods="CTRL|SHIFT", action=wezterm.action({AdjustPaneSize={"Down", 3}})},

    -- Move between panes
    { key="h", mods="CTRL", action=wezterm.action({ActivatePaneDirection="Left"})},
    { key="l", mods="CTRL", action=wezterm.action({ActivatePaneDirection="Right"})},
    { key="k", mods="CTRL", action=wezterm.action({ActivatePaneDirection="Up"})},
    { key="j", mods="CTRL", action=wezterm.action({ActivatePaneDirection="Down"})},

    -- Close current pane by pressing control + delete
    { key="Delete", mods="CTRL", action=wezterm.action({CloseCurrentPane={confirm=true}})},
    { key = "1", mods = "ALT", action = wezterm.action{ActivateTab=0} },
    { key = "2", mods = "ALT", action = wezterm.action{ActivateTab=1} },
    { key = "3", mods = "ALT", action = wezterm.action{ActivateTab=2} },
    { key = "4", mods = "ALT", action = wezterm.action{ActivateTab=3} },
}

local RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
local fg_tab_color = "rgba(21, 17, 75)"

wezterm.on('format-tab-title',
    function(tab, _, _, _, _, max_width)
        local title = wezterm.truncate_right(tab.active_pane.title, max_width)
        if tab.is_active then
            return {
                { Foreground = { Color = "#ffffff" } },
                { Background = { Color = fg_tab_color } },
                { Text = " " .. title .. " " },

                { Foreground = { Color = fg_tab_color } },
                { Background = { Color = bg_color } },
                { Text = RIGHT_ARROW },
            }
        else
            return {
                { Text = " " .. title .. "  " },
            }
        end
    end)

return config
