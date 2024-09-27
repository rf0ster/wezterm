-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()
config.color_scheme = 'Cyberdyne'
config.window_background_opacity = 0.6
config.colors = {
    tab_bar = {
        background = "rgba(21, 17, 68, 0.3)",
        active_tab = {
            bg_color = "rgba(21, 17, 68, 0.6)",
            fg_color = "#ffffff",
        },
        inactive_tab = {
            bg_color = "rgba(21, 17, 68, 0.3)",
            fg_color = "#ffffff",
        },
        inactive_tab_hover = {
            bg_color = "rgba(21, 17, 68, 0.3)",
            fg_color = "#ffffff",
        },
        new_tab = {
            bg_color = "rgba(21, 17, 68, 0.3)",
            fg_color = "#ffffff",
        },
        new_tab_hover = {
            bg_color = "rgba(21, 17, 68, 0.3)",
            fg_color = "#ffffff",
        },
    }
}
config.tab_max_width = 20
config.font_size = 14
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

-- Keybindings for moving between split panes
config.keys = {
    -- Split panes
    { key="7", mods="CTRL", action=wezterm.action.SplitPane({ direction = "Left", })},
    { key="8", mods="CTRL", action=wezterm.action.SplitPane({ direction = "Down", size = { Percent = 20 } })},
    { key="9", mods="CTRL", action=wezterm.action.SplitPane({ direction = "Up", size = { Percent = 20 } })},
    { key="0", mods="CTRL", action=wezterm.action.SplitPane({ direction = "Right", })},
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
}

return config
