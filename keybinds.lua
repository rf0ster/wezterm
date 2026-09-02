return {
    configure = function(config)
        local wezterm = require 'wezterm'
        config.keys = {
            -- Split panes
            { key="h", mods="CTRL|CMD", action=wezterm.action.SplitPane({ direction = "Left", })},
            { key="j", mods="CTRL|CMD", action=wezterm.action.SplitPane({ direction = "Down", size = { Percent = 20 } })},
            { key="k", mods="CTRL|CMD", action=wezterm.action.SplitPane({ direction = "Up", size = { Percent = 20 } })},
            { key="l", mods="CTRL|CMD", action=wezterm.action.SplitPane({ direction = "Right", })},
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
            { key = "1", mods = "CMD", action = wezterm.action{ActivateTab=0} },
            { key = "2", mods = "CMD", action = wezterm.action{ActivateTab=1} },
            { key = "3", mods = "CMD", action = wezterm.action{ActivateTab=2} },
            { key = "4", mods = "CMD", action = wezterm.action{ActivateTab=3} },

            -- Clear all panes in the current window
            { key = "c", mods = "CTRL|SHIFT", action = wezterm.action_callback(function(_, pane)
                local tab = pane:tab()
                local panes = tab:panes_with_info()
                for _, p in ipairs(panes) do
                    p.pane:send_text("clear\n")
                end
            end)},

            -- Change directory of all panes in current tab to the current pane's directory
            { key = "d", mods = "CTRL|SHIFT", action = wezterm.action_callback(function(_, pane)
                local tab = pane:tab()
                local panes = tab:panes_with_info()

                -- Get the current working directory from the active pane
                local cwd_uri = pane:get_current_working_dir()
                if cwd_uri then
                    -- Convert the URI to a file path
                    local cwd = cwd_uri.file_path

                    -- Send cd command to all panes in the tab
                    for _, p in ipairs(panes) do
                        p.pane:send_text("cd " .. wezterm.shell_quote_arg(cwd) .. "\n")
                        p.pane:send_text("clear\n")
                    end
                end
            end)},

            -- Decrease window opacity
            { key = "9", mods = "CTRL", action = wezterm.action_callback(function(window, _)
                local overrides = window:get_config_overrides() or {}
                local current_opacity = overrides.window_background_opacity or 1.0
                print("Current opacity: " .. current_opacity)
                local next_opacity = current_opacity + 0.04
                print("Next opacity: " .. next_opacity)
                overrides.window_background_opacity = math.min(next_opacity, 1.0)
                window:set_config_overrides(overrides)
            end)},

            -- Increase window opacity
            { key = "0", mods = "CTRL", action = wezterm.action_callback(function(window, _)
                local overrides = window:get_config_overrides() or {}
                local current_opacity = overrides.window_background_opacity or 1.0
                print("Current opacity: " .. current_opacity)
                local next_opacity = current_opacity - 0.04
                print("Next opacity: " .. next_opacity)
                overrides.window_background_opacity = math.max(next_opacity, 0.0)
                window:set_config_overrides(overrides)
            end)},

            -- Increase blurr
            { key = "8", mods = "CTRL", action = wezterm.action_callback(function(window, _)
                local overrides = window:get_config_overrides() or {}
                local blur = overrides.macos_window_background_blur or 0
                overrides.macos_window_background_blur = math.min(100, blur + 2)
                window:set_config_overrides(overrides)
            end)},

            -- Decrease blurr
            { key = "7", mods = "CTRL", action = wezterm.action_callback(function(window, _)
                local overrides = window:get_config_overrides() or {}
                local blur = overrides.macos_window_background_blur or 0
                overrides.macos_window_background_blur = math.max(0, blur - 2)
                window:set_config_overrides(overrides)
            end)},
        }

    end
}
