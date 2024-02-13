local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local config = wezterm.config_builder()

local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
-- you can put the rest of your Wezterm config here

-- KEY BINDINGS
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- splitting
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
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
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
	-- activate pane selection mode with the default alphabet (labels are "a", "s", "d", "f" and so on)
	{ key = "8", mods = "CTRL", action = act.PaneSelect },
	-- activate pane selection mode with numeric labels
	{
		key = "9",
		mods = "CTRL",
		action = act.PaneSelect({
			alphabet = "1234567890",
		}),
	},
	-- show the pane selection mode, but have it swap the active and selected panes
	{
		key = "0",
		mods = "CTRL",
		action = act.PaneSelect({
			mode = "SwapWithActive",
		}),
	},
	-- rotate panes
	{
		mods = "LEADER",
		key = "Space",
		action = wezterm.action.RotatePanes("Clockwise"),
	},
	-- show the pane selection mode, but have it swap the active and selected panes
	{
		mods = "LEADER",
		key = "0",
		action = wezterm.action.PaneSelect({
			mode = "SwapWithActive",
		}),
	},
	-- Show the launcher in fuzzy selection mode and have it list all workspaces
	-- and allow activating one.
	{
		key = "9",
		mods = "ALT",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES",
		}),
	},
  -- have to set this separately from config.window_close_confirmation
  -- https://wezfurlong.org/wezterm/config/lua/config/window_close_confirmation.html
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentTab({ confirm = false }),
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
--TODO: determine how to get default_args to work when starting wezterm by clicking on the application icon
--TODO: Add another cmd window to all workspaces
--TODO: Figure out how to close all workspaces with keybinding
--TODO: Add local:env startup cmds
--TODO: Add yarn start cmds
--TODO: modularize the workspace creation
wezterm.on("gui-startup", function(cmd)
	local args = {}
	if cmd then
		args = cmd.args
	end

	local project_dir = wezterm.home_dir .. "/projects"

	-- dotfiles
	local dotfiles_dir = project_dir .. "/dotfiles"
	local tab, dotfiles_cmd_pane, dotfiles_window = mux.spawn_window({
		workspace = "dotfiles",
		cwd = dotfiles_dir,
		args = args,
	})
	local dotfiles_editor_pane = dotfiles_cmd_pane:split({
		direction = "Top",
		size = 0.6,
		cwd = dotfiles_dir,
		args = args,
	})
  local dotfiles_git_pane = dotfiles_cmd_pane:split({
    cwd = dotfiles_dir,
    args = args,
  })

  dotfiles_cmd_pane:send_text("fish\n")
  dotfiles_cmd_pane:send_text("cls\n")

  dotfiles_editor_pane:send_text("fish\n")
  dotfiles_editor_pane:send_text("cls\n")
	dotfiles_editor_pane:send_text("nvim\n")

	-- admin
	local admin_dir = project_dir .. "/keet-admin"
	local tab, admin_cmd_pane, admin_window = mux.spawn_window({
		workspace = "admin",
		cwd = admin_dir,
		args = args,
	})
	local admin_editor_pane = admin_cmd_pane:split({
		direction = "Top",
		size = 0.6,
		cwd = admin_dir,
		args = args,
	})

  local admin_git_pane = admin_cmd_pane:split({
    cwd = admin_dir,
    args = args,
  })

  admin_cmd_pane:send_text("fish\n")
  admin_cmd_pane:send_text("cls\n")

  admin_editor_pane:send_text("fish\n")
  admin_editor_pane:send_text("cls\n")
	admin_editor_pane:send_text("nvim\n")

	-- pt
	local pt_dir = project_dir .. "/keet-umi"
	local tab, pt_cmd_pane, pt_window = mux.spawn_window({
		workspace = "pt",
		cwd = pt_dir,
		args = args,
	})
	local pt_editor_pane = pt_cmd_pane:split({
		direction = "Top",
		size = 0.6,
		cwd = pt_dir,
		args = args,
	})

  local pt_git_pane = pt_cmd_pane:split({
    cwd = pt_dir,
    args = args,
  })

  pt_cmd_pane:send_text("fish\n")
  pt_cmd_pane:send_text("cls\n")

  pt_editor_pane:send_text("fish\n")
  pt_editor_pane:send_text("cls\n")
	pt_editor_pane:send_text("nvim\n")

  -- embedded
	local embedded_dir = project_dir .. "/keet-embedded"
	local tab, embedded_cmd_pane, embedded_window = mux.spawn_window({
		workspace = "embedded",
		cwd = embedded_dir,
		args = args,
	})
	local embedded_editor_pane = embedded_cmd_pane:split({
		direction = "Top",
		size = 0.6,
		cwd = embedded_dir,
		args = args,
	})

  local embedded_git_pane = embedded_cmd_pane:split({
    cwd = embedded_dir,
    args = args,
  })

  embedded_cmd_pane:send_text("fish\n")
  embedded_cmd_pane:send_text("cls\n")

  embedded_editor_pane:send_text("fish\n")
  embedded_editor_pane:send_text("cls\n")
	embedded_editor_pane:send_text("nvim\n")

  -- api
	local api_dir = project_dir .. "/keet-api"
	local tab, api_cmd_pane, api_window = mux.spawn_window({
		workspace = "api",
		cwd = api_dir,
		args = args,
	})
	local api_editor_pane = api_cmd_pane:split({
		direction = "Top",
		size = 0.6,
		cwd = api_dir,
		args = args,
	})

  local api_git_pane = api_cmd_pane:split({
    cwd = api_dir,
    args = args,
  })

  api_cmd_pane:send_text("fish\n")
  api_cmd_pane:send_text("cls\n")

  api_editor_pane:send_text("fish\n")
  api_editor_pane:send_text("cls\n")
	api_editor_pane:send_text("nvim\n")

  -- auth
	local auth_dir = project_dir .. "/keet-auth"
	local tab, auth_cmd_pane, auth_window = mux.spawn_window({
		workspace = "auth",
		cwd = auth_dir,
		args = args,
	})
	local auth_editor_pane = auth_cmd_pane:split({
		direction = "Top",
		size = 0.6,
		cwd = auth_dir,
		args = args,
	})

  local auth_git_pane = auth_cmd_pane:split({
    cwd = auth_dir,
    args = args,
  })

  auth_cmd_pane:send_text("fish\n")
  auth_cmd_pane:send_text("cls\n")

  auth_editor_pane:send_text("fish\n")
  auth_editor_pane:send_text("cls\n")
	auth_editor_pane:send_text("nvim\n")

  -- patient
	local patient_dir = project_dir .. "/keet-patient"
	local tab, patient_cmd_pane, patient_window = mux.spawn_window({
		workspace = "patient",
		cwd = patient_dir,
		args = args,
	})
	local patient_editor_pane = patient_cmd_pane:split({
		direction = "Top",
		size = 0.6,
		cwd = patient_dir,
		args = args,
	})

  local patient_git_pane = patient_cmd_pane:split({
    cwd = patient_dir,
    args = args,
  })

  patient_cmd_pane:send_text("fish\n")
  patient_cmd_pane:send_text("cls\n")

  patient_editor_pane:send_text("fish\n")
  patient_editor_pane:send_text("cls\n")
	patient_editor_pane:send_text("nvim\n")

  -- mobile
	local mobile_dir = project_dir .. "/keet-mobile"
	local tab, mobile_cmd_pane, mobile_window = mux.spawn_window({
		workspace = "mobile",
		cwd = mobile_dir,
		args = args,
	})
	local mobile_editor_pane = mobile_cmd_pane:split({
		direction = "Top",
		size = 0.6,
		cwd = mobile_dir,
		args = args,
	})

  local mobile_git_pane = mobile_cmd_pane:split({
    cwd = mobile_dir,
    args = args,
  })

  mobile_cmd_pane:send_text("fish\n")
  mobile_cmd_pane:send_text("cls\n")

  mobile_editor_pane:send_text("fish\n")
  mobile_editor_pane:send_text("cls\n")
	mobile_editor_pane:send_text("nvim\n")

  -- auth-client
	local auth_client_dir = project_dir .. "/keet-auth-client"
	local tab, auth_client_cmd_pane, auth_client_window = mux.spawn_window({
		workspace = "auth client",
		cwd = auth_client_dir,
		args = args,
	})
	local auth_client_editor_pane = auth_client_cmd_pane:split({
		direction = "Top",
		size = 0.6,
		cwd = auth_client_dir,
		args = args,
	})

  local auth_client_git_pane = auth_client_cmd_pane:split({
    cwd = auth_client_dir,
    args = args,
  })

  auth_client_cmd_pane:send_text("fish\n")
  auth_client_cmd_pane:send_text("cls\n")

  auth_client_editor_pane:send_text("fish\n")
  auth_client_editor_pane:send_text("cls\n")
	auth_client_editor_pane:send_text("nvim\n")

  -- api-client
	local api_client_dir = project_dir .. "/keet-api-client"
	local tab, api_client_cmd_pane, api_client_window = mux.spawn_window({
		workspace = "api client",
		cwd = api_client_dir,
		args = args,
	})
	local api_client_editor_pane = api_client_cmd_pane:split({
		direction = "Top",
		size = 0.6,
		cwd = api_client_dir,
		args = args,
	})

  local api_client_git_pane = api_client_cmd_pane:split({
    cwd = api_client_dir,
    args = args,
  })

  api_client_cmd_pane:send_text("fish\n")
  api_client_cmd_pane:send_text("cls\n")

  api_client_editor_pane:send_text("fish\n")
  api_client_editor_pane:send_text("cls\n")
	api_client_editor_pane:send_text("nvim\n")

  -- ui-components
	local ui_components_dir = project_dir .. "/ui-components"
	local tab, ui_components_cmd_pane, ui_components_window = mux.spawn_window({
		workspace = "ui components",
		cwd = ui_components_dir,
		args = args,
	})
	local ui_components_editor_pane = ui_components_cmd_pane:split({
		direction = "Top",
		size = 0.6,
		cwd = ui_components_dir,
		args = args,
	})

  local ui_components_git_pane = ui_components_cmd_pane:split({
    cwd = ui_components_dir,
    args = args,
  })

  ui_components_cmd_pane:send_text("fish\n")
  ui_components_cmd_pane:send_text("cls\n")

  ui_components_editor_pane:send_text("fish\n")
  ui_components_editor_pane:send_text("cls\n")
	ui_components_editor_pane:send_text("nvim\n")

  -- ops-tools
	local ops_tools_dir = project_dir .. "/ops-tools"
	local tab, ops_tools_cmd_pane, ops_tools_window = mux.spawn_window({
		workspace = "ops tools",
		cwd = ops_tools_dir,
		args = args,
	})
	local ops_tools_editor_pane = ops_tools_cmd_pane:split({
		direction = "Top",
		size = 0.6,
		cwd = ops_tools_dir,
		args = args,
	})

  local ops_tools_git_pane = ops_tools_cmd_pane:split({
    cwd = ops_tools_dir,
    args = args,
  })

  ops_tools_cmd_pane:send_text("fish\n")
  ops_tools_cmd_pane:send_text("cls\n")

  ops_tools_editor_pane:send_text("fish\n")
  ops_tools_editor_pane:send_text("cls\n")
	ops_tools_editor_pane:send_text("nvim\n")

  -- devdocs
	local devdocs_dir = project_dir .. "/devDocs"
	local tab, devdocs_cmd_pane, devdocs_window = mux.spawn_window({
		workspace = "devdocs",
		cwd = devdocs_dir,
		args = args,
	})
	local devdocs_editor_pane = devdocs_cmd_pane:split({
		direction = "Top",
		size = 0.6,
		cwd = devdocs_dir,
		args = args,
	})

  local devdocs_git_pane = devdocs_cmd_pane:split({
    cwd = devdocs_dir,
    args = args,
  })

  devdocs_cmd_pane:send_text("fish\n")
  devdocs_cmd_pane:send_text("cls\n")

  devdocs_editor_pane:send_text("fish\n")
  devdocs_editor_pane:send_text("cls\n")
	devdocs_editor_pane:send_text("nvim\n")

  -- keetman
	local keetman_dir = project_dir .. "/keetman"
	local tab, keetman_cmd_pane, keetman_window = mux.spawn_window({
		workspace = "keetman",
		cwd = keetman_dir,
		args = args,
	})
	local keetman_editor_pane = keetman_cmd_pane:split({
		direction = "Top",
		size = 0.6,
		cwd = keetman_dir,
		args = args,
	})

  local keetman_git_pane = keetman_cmd_pane:split({
    cwd = keetman_dir,
    args = args,
  })

  keetman_cmd_pane:send_text("fish\n")
  keetman_cmd_pane:send_text("cls\n")

  keetman_editor_pane:send_text("fish\n")
  keetman_editor_pane:send_text("cls\n")
	keetman_editor_pane:send_text("nvim\n")

	-- We want to startup in the coding workspace
	mux.set_active_workspace("dotfiles")
end)

return config
