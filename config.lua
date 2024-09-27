-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Cyberdyne'
config.window_background_opacity = 0.6
config.font_size = 14
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
-- and finally, return the configuration to wezterm


-- Keybindings for moving between split panes
config.keys = {
    -- Split panes
    { key="8", mods="CTRL", action=wezterm.action.SplitPane({ direction = "Left", })},
    { key="9", mods="CTRL", action=wezterm.action.SplitPane({ direction = "Down", size = { Percent = 20 } })},
    { key="0", mods="CTRL", action=wezterm.action.SplitPane({ direction = "Up", size = { Percent = 20 } })},
    { key="-", mods="CTRL", action=wezterm.action.SplitPane({ direction = "Right", })},
    { key = "=", mods = "CTRL", action = wezterm.action_callback(function(_, pane)
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

    -- Adjust the size of the pane
    -- Shrink the pane to the left
    {key="h", mods="CTRL|SHIFT", action=wezterm.action({AdjustPaneSize={"Left", 3}})},
    -- Expand the pane to the right
    {key="l", mods="CTRL|SHIFT", action=wezterm.action({AdjustPaneSize={"Right", 3}})},
    -- Shrink the pane upward
    {key="k", mods="CTRL|SHIFT", action=wezterm.action({AdjustPaneSize={"Up", 3}})},
    -- Expand the pane downward
    {key="j", mods="CTRL|SHIFT", action=wezterm.action({AdjustPaneSize={"Down", 3}})},

    -- Move between panes
    {key="h", mods="CTRL", action=wezterm.action({ActivatePaneDirection="Left"})},
    {key="l", mods="CTRL", action=wezterm.action({ActivatePaneDirection="Right"})},
    {key="k", mods="CTRL", action=wezterm.action({ActivatePaneDirection="Up"})},
    {key="j", mods="CTRL", action=wezterm.action({ActivatePaneDirection="Down"})},

    -- Close current pane by pressing control + delete
    {key="Delete", mods="CTRL", action=wezterm.action({CloseCurrentPane={confirm=true}})},
}

return config
