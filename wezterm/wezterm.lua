local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local config = wezterm.config_builder()

local settings = require("settings")

local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{
		mods = "LEADER",
		key = "_",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "|",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "a",
		mods = "LEADER|CTRL",
		action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
	},
	{
		mods = "LEADER",
		key = "m",
		action = wezterm.action.TogglePaneZoomState,
	},
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "8", mods = "CTRL", action = act.PaneSelect },
	{
		key = "9",
		mods = "CTRL",
		action = act.PaneSelect({
			alphabet = "1234567890",
		}),
	},
	{
		key = "0",
		mods = "CTRL",
		action = act.PaneSelect({
			mode = "SwapWithActive",
		}),
	},
	{
		mods = "LEADER",
		key = "Space",
		action = wezterm.action.RotatePanes("Clockwise"),
	},
	{
		mods = "LEADER",
		key = "0",
		action = wezterm.action.PaneSelect({
			mode = "SwapWithActive",
		}),
	},
	{
		key = "9",
		mods = "ALT",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES",
		}),
	},
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentTab({ confirm = false }),
	},
	{ key = "U", mods = "CTRL|SHIFT", action = act.AttachDomain("devhost") },
	{
		key = "D",
		mods = "CTRL|SHIFT",
		action = act.DetachDomain("CurrentPaneDomain"),
	},
	{
		key = "E",
		mods = "CTRL|SHIFT",
		action = act.DetachDomain({ DomainName = "devhost" }),
	},
	{ key = "n", mods = "LEADER", action = act.SwitchWorkspaceRelative(1) },
	{ key = "p", mods = "LEADER", action = act.SwitchWorkspaceRelative(-1) },
	{ key = "n", mods = "SHIFT|CTRL", action = wezterm.action.SpawnWindow },
	{ key = "F9", mods = "ALT", action = wezterm.action.ShowTabNavigator },
	{
		key = "E",
		mods = "CTRL|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{
		key = "u",
		mods = "SHIFT|CTRL",
		action = wezterm.action.CharSelect({
			copy_on_select = true,
			copy_to = "ClipboardAndPrimarySelection",
		}),
	},
}

config.mouse_bindings = {
	-- Ctrl-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

-- apply smart_splits defaults
smart_splits.apply_to_config(config)
-- COLORS
config.color_scheme = "Gruvbox Material (Gogh)"
-- history
config.scrollback_lines = 10000

config.window_close_confirmation = "NeverPrompt"

-- WORKSPACES
--TODO: Move this into a separate file?
--TODO: Create `create_mobile_workspace` function
wezterm.on("gui-startup", function()
	local project_dir = wezterm.home_dir .. "/projects"

	local function cmd(pane, text)
		pane:send_text(text .. "\n")
	end

	local function fishify_pane(pane)
		cmd(pane, "fish")
		cmd(pane, "cls")
	end

	local function edify_pane(pane)
		fishify_pane(pane)
		cmd(pane, "nvim")
	end

	local function create_editor_workspace(name, dir)
		local tab, editor_pane, window = mux.spawn_window({
			workspace = name,
			cwd = dir,
		})
		edify_pane(editor_pane)
		return tab, editor_pane, window
	end

	local function create_cmd_workspace(name, dir)
		local tab, cmd_pane, window = mux.spawn_window({
			workspace = name,
			cwd = dir,
		})
		local du_tab, du_pane, du_window = window:spawn_tab({
			cwd = dir,
		})
		fishify_pane(cmd_pane)
		cmd(cmd_pane, "btm")
		cmd_pane:activate()

		cmd(du_pane, "dust")
	end

	local function create_workspace(name, dir)
		local tab, editor_pane, window = create_editor_workspace(name, dir)
		local cmd_pane = editor_pane:split({
			direction = "Bottom",
			size = 0.4,
			cwd = dir,
		})
		local git_pane = cmd_pane:split({
			cwd = dir,
		})

		fishify_pane(cmd_pane)
		fishify_pane(git_pane)

		editor_pane:activate()
		return tab, cmd_pane, editor_pane, window
	end

	local function create_fe_workspace(name, dir)
		local tab, cmd_pane, editor_pane, window = create_workspace(name, dir)
		cmd(cmd_pane, "yarn env:" .. settings.env)
		cmd(cmd_pane, "yarn start")
	end

	local function create_patient_workspace(name, dir)
		local tab, cmd_pane, editor_pane, window = create_workspace(name, dir)
		cmd(cmd_pane, "yarn env:" .. settings.client .. ":" .. settings.env)
		-- no autostart here because it shares port with other apps
	end

	local function create_api_workspace(name, dir)
		local tab, cmd_pane, editor_pane, window = create_workspace(name, dir)
		local stack_tab, stack_pane, stack_window = window:spawn_tab({
			cwd = dir,
		})
		local tabs = window:tabs()
		tabs[1]:activate()
		fishify_pane(stack_pane)
		cmd(stack_pane, "ahoy up")
	end

	if settings.comp == "work" then
		-- fe workspaces
		create_fe_workspace("admin", project_dir .. "/keet-admin")
		create_fe_workspace("pt", project_dir .. "/keet-umi")
		create_fe_workspace("embedded", project_dir .. "/keet-embedded")
		-- api workspace
		create_api_workspace("api", project_dir .. "/keet-api")
		create_workspace("auth", project_dir .. "/keet-auth")
		-- patient web
		create_patient_workspace("patient", project_dir .. "/keet-patient")
		--patient mobile
		create_workspace("mobile", project_dir .. "/keet-mobile")
		-- general
		create_workspace("auth client", project_dir .. "/keet-auth-client")
		create_workspace("api client", project_dir .. "/keet-api-client")
		create_workspace("ui components", project_dir .. "/ui-components")
		create_workspace("ops tools", project_dir .. "/ops-tools")
		create_workspace("devdocs", project_dir .. "/devDocs")
		create_workspace("keetman", project_dir .. "/keetman")
		create_editor_workspace("work notes", project_dir .. "/work_notes")
	end

	create_workspace("dotfiles", project_dir .. "/dotfiles")
	create_cmd_workspace("monitoring", project_dir)

	-- We want to startup in the coding workspace
	mux.set_active_workspace("dotfiles")
end)

return config
