require("plugins")

require("legendary").setup({
  extensions = {
    lazy_nvim = { auto_register = true },
    which_key = { auto_register = true },
    smart_splits = {},
  },
})

--           ╭───────────────────────────────────────────────────────╮
--           │                         MASON                         │
--           │ https://github.com/williamboman/mason.nvim/issues/130 │
--           ╰───────────────────────────────────────────────────────╯
local mason_options = {
  ensure_installed = {
    "clang-format",
    "jsonlint",
    "stylua",
    "prettier",
    "nxls",
    "shfmt",
    "shellcheck",
    "sqlfmt",
  },
  max_concurrent_installers = 10,
}

require("mason").setup(mason_options)

vim.api.nvim_create_user_command("MasonInstallAll", function()
  vim.cmd("MasonInstall " .. table.concat(mason_options.ensure_installed, " "))
end, {})

require("mason-lspconfig").setup({
  ensure_installed = {
    "bashls",
    "clangd",
    "cssls",
    "cssmodules_ls",
    "cucumber_language_server",
    "docker_compose_language_service",
    "dockerls",
    "emmet_language_server",
    "eslint",
    "html",
    "jsonls",
    "lua_ls",
    "sqlls",
    "marksman",
    "tailwindcss",
    "terraformls",
    "tflint",
    "typos_lsp",
    "vimls",
    "yamlls",
    "ts_ls",
    "prismals",
    "pylsp",
    "denols",
    "volar",
    --TODO: Look into creating a PR to https://github.com/mason-org/mason-registry/ to add support for `nixd` instead
    -- "nil_ls",
    "clojure_lsp",
    -- https://github.com/williamboman/mason-lspconfig.nvim/issues/451
    -- "cljfmt",
    -- linter
    -- https://github.com/williamboman/mason-lspconfig.nvim/issues/450
    -- "clj-kondo",
    "ruff",
    "basedpyright",
    "solargraph",
  },
})

--          ╭─────────────────────────────────────────────────────────╮
--          │                    TRANSPARENT.NVIM                     │
--          │      https://github.com/xiyaowong/transparent.nvim      │
--          ╰─────────────────────────────────────────────────────────╯
require("transparent").setup({})

--          ╭─────────────────────────────────────────────────────────╮
--          │                     NVIM-TREESITTER                     │
--          │   https://github.com/nvim-treesitter/nvim-treesitter    │
--          ╰─────────────────────────────────────────────────────────╯
---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "c",
    "lua",
    "luadoc",
    "vim",
    "vimdoc",
    "query",
    "bash",
    "css",
    "clojure",
    "dockerfile",
    "fish",
    "html",
    "http",
    "javascript",
    "jq",
    "json",
    "jsonc",
    "markdown",
    "markdown_inline",
    "ruby",
    "scheme",
    "scss",
    "sql",
    "terraform",
    "toml",
    "tsx",
    "typescript",
    "yaml",
    "prisma",
    "vue",
    "nix",
    "ssh_config",
    "editorconfig",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "graphql",
    "hurl",
    "nginx",
    "passwd",
    "svelte",
    "swift",
    "tmux",
  },
  -- required by 'nvim-ts-autotag'
  autotag = {
    enable = true,
  },
  -- required by 'nvim-treesitter-endwise'
  endwise = {
    enable = true,
  },
  --       ╭───────────────────────────────────────────────────────────────╮
  --       │                  NVIM-TREESITTER-TEXTOBJECTS                  │
  --       │https://github.com/nvim-treesitter/nvim-treesitter-textobjects │
  --       ╰───────────────────────────────────────────────────────────────╯
  textobjects = {
    lsp_interop = {
      enable = true,
      border = "none",
      floating_preview_opts = {},
      peek_definition_code = {
        ["<leader>vf"] = "@function.outer",
        ["<leader>vc"] = "@class.outer",
      },
    },
    move = {
      --TODO: Figure out why go-tos for conditionals don't work in .rb files?
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = { query = "@function.outer", desc = "Next method (start)" },
        ["]c"] = { query = "@class.outer", desc = "Next class (start)" },
        ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope (start)" },
        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold (start)" },
        ["]d"] = { query = "@conditional.outer", desc = "Next Conditional (start)" },
      },
      goto_next_end = {
        ["]M"] = { query = "@function.outer", desc = "Next method (end)" },
        ["]C"] = { query = "@class.outer", desc = "Next class (end)" },
        ["]S"] = { query = "@scope", query_group = "locals", desc = "Next scope (end)" },
        ["]Z"] = { query = "@fold", query_group = "folds", desc = "Next fold (end)" },
        ["]D"] = { query = "@conditional.outer", desc = "Next Conditional (end)" },
      },
      goto_previous_start = {
        ["[m"] = { query = "@function.outer", desc = "Previous method (start)" },
        ["[c"] = { query = "@class.outer", desc = "Previous class (start)" },
        ["[s"] = { query = "@scope", query_group = "locals", desc = "Previous scope (start)" },
        ["[z"] = { query = "@fold", query_group = "folds", desc = "Previous fold (start)" },
        ["[d"] = { query = "@conditional.outer", desc = "Previous Conditional (start)" },
      },
      goto_previous_end = {
        ["[M"] = { query = "@function.outer", desc = "Previous method (end)" },
        ["[C"] = { query = "@class.outer", desc = "Previous class (end)" },
        ["[S"] = { query = "@scope", query_group = "locals", desc = "Previous scope (end)" },
        ["[Z"] = { query = "@fold", query_group = "folds", desc = "Previous fold (end)" },
        ["[D"] = { query = "@conditional.outer", desc = "Previous Conditional (end)" },
      },
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = { query = "@function.outer", desc = "Select outer function" },
        ["if"] = { query = "@function.inner", desc = "Select inner function" },
        ["ac"] = { query = "@class.outer", desc = "Select outer class" },
        ["ic"] = { query = "@class.inner", desc = "Select inner class" },
        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
        ["is"] = { query = "@scope.inner", query_group = "locals", desc = "Select inner language scope" },
        ["al"] = { query = "@loop.outer", desc = "Select outer loop" },
        ["il"] = { query = "@loop.inner", desc = "Select inner loop" },
        ["ab"] = { query = "@block.outer", desc = "Select outer block" },
        --TODO: Figure out how to select blocks without the curly braces
        ["ib"] = { query = "@block.inner", desc = "Select inner block", kind = "exclusive" },
        ["ad"] = { query = "@conditional.outer", desc = "Select outer conditional" },
        ["id"] = { query = "@conditional.inner", desc = "Select inner conditional" },
        ["ap"] = { query = "@parameter.outer", desc = "Select outer parameter" },
        ["ip"] = { query = "@parameter.inner", desc = "Select inner parameter" },
        ["aP"] = { query = "@parameter.outer", mode = "a", desc = "Select outer parameter (inclusive)" },
        ["iP"] = { query = "@parameter.inner", mode = "a", desc = "Select inner parameter (inclusive)" },
        ["a,"] = { query = "@parameter.outer", mode = "i", desc = "Select outer parameter (exclusive)" },
        ["i,"] = { query = "@parameter.inner", mode = "i", desc = "Select inner parameter (exclusive)" },
        ["a;"] = {
          query = "@parameter.outer",
          mode = "a",
          kind = "inclusive",
          desc = "Select outer parameter (inclusive)",
        },
        ["i;"] = {
          query = "@parameter.inner",
          mode = "a",
          kind = "inclusive",
          desc = "Select inner parameter (inclusive)",
        },
        ["a:"] = {
          query = "@parameter.outer",
          mode = "i",
          kind = "exclusive",
          desc = "Select outer parameter (exclusive)",
        },
        ["i:"] = {
          query = "@parameter.inner",
          mode = "i",
          kind = "exclusive",
          desc = "Select inner parameter (exclusive)",
        },
        ["a/"] = { query = "@comment.outer", desc = "Select outer comment" },
        ["i/"] = { query = "@comment.inner", desc = "Select inner comment" },
        ["a#"] = {
          query = "@comment.outer",
          mode = "i",
          kind = "inclusive",
          desc = "Select outer comment (inclusive)",
        },
        ["i#"] = {
          query = "@comment.inner",
          mode = "i",
          kind = "inclusive",
          desc = "Select inner comment (inclusive)",
        },
      },
      selection_modes = {
        ["@parameter.outer"] = "v", -- charwise
        ["@function.outer"] = "V", -- linewise
        ["@class.outer"] = "V", -- blockwise
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>a"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>A"] = "@parameter.inner",
        },
      },
    },
  },
  -- my config
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      --TODO: how to inform whichkey that <leader>s should be used for this?
      init_selection = "<Leader>si", -- select start
      node_incremental = "<Leader>sn", -- select node (incremental)
      scope_incremental = "<Leader>ss", -- select scope
      node_decremental = "<Leader>sd", -- select node (decremental)
    },
  },
  indent = {
    enable = true,
  },
})

local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

-- Repeat movement with ; and ,
-- ensure ; goes forward and , goes backward regardless of the last direction
-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next, { desc = "Repeat last move next" })
-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous, { desc = "Repeat last move previous" })

-- This repeats the last query with always previous direction and to the start of the range.
vim.keymap.set({ "n", "x", "o" }, "<home>", function()
  ts_repeat_move.repeat_last_move({ forward = false, start = true, desc = "Repeat last move" })
end)

-- This repeats the last query with always next direction and to the end of the range.
vim.keymap.set({ "n", "x", "o" }, "<end>", function()
  ts_repeat_move.repeat_last_move({ forward = true, start = false, desc = "Repeat last move" })
end)

-- custom file associations
require("vim.treesitter.language").register("http", "hurl")

--          ╭─────────────────────────────────────────────────────────╮
--          │                     NEOSCROLL.NVIM                      │
--          │        https://github.com/karb94/neoscroll.nvim         │
--          ╰─────────────────────────────────────────────────────────╯
require("neoscroll").setup({
  easing_function = "quadratic",
  mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>" },
})

--          ╭─────────────────────────────────────────────────────────╮
--          │                     WEB-TOOLS.NVIM                      │
--          │         https://github.com/ray-x/web-tools.nvim         │
--          ╰─────────────────────────────────────────────────────────╯
require("web-tools").setup({
  keymaps = {
    rename = nil, -- by default use same setup of lspconfig
  },
  hurl = { -- hurl default
    show_headers = false, -- do not show http headers
    floating = false, -- use floating windows (need guihua.lua)
    formatters = { -- format the result by filetype
      json = { "jq" },
      html = { "prettier", "--parser", "html" },
    },
  },
})

--          ╭─────────────────────────────────────────────────────────╮
--          │                       NEODEV.NVIM                       │
--          │          https://github.com/folke/neodev.nvim           │
--          ╰─────────────────────────────────────────────────────────╯
-- NOTE: must be done before any lspconfig
require("neodev").setup({})

--TODO: Figure out where this configuration was recommended?
-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

--          ╭─────────────────────────────────────────────────────────╮
--          │                     NVIM-LSPCONFIG                      │
--          │        https://github.com/neovim/nvim-lspconfig         │
--          ╰─────────────────────────────────────────────────────────╯
local lspconfig = require("lspconfig")

local servers = {
  "emmet_language_server",
  "jsonls",
  "html",
  "bashls",
  "clangd",
  "cssmodules_ls",
  "docker_compose_language_service",
  "dockerls",
  "emmet_language_server",
  "yamlls",
  "marksman",
  "cucumber_language_server",
  "tailwindcss",
  "terraformls",
  -- Do not install 'solargraph' with Mason, since the version used depends on Ruby version
  -- "solargraph",
  "sqlls",
  "vimls",
  "prismals",
  "volar",
  "nil_ls",
  "clojure_lsp",
  -- turning off for now: https://github.com/nrwl/nx-console/issues/2019
  -- "nxls",
  "ruff",
  "basedpyright",
  "tflint",
}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    capabilities = capabilities,
  })
end

-- lspconfig.vuels.setup({
-- 	capabilities = capabilities,
-- 	cmd = { "vue-language-server", "--stdio" },
-- })

-- if vim.fn.hostname() == "drews-mbp-1" then
lspconfig.solargraph.setup({
  capabilities = capabilities,
  filetypes = { "ruby", "eruby" },
})
-- end

lspconfig.basedpyright.setup({
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off",
      },
    },
  },
})

lspconfig.eslint.setup({
  capabilities = capabilities,
  settings = {
    workingDirectories = { mode = "auto" },
    experimental = {
      useFlatConfig = false,
    },
  },
})

lspconfig.cssls.setup({
  capabilities = capabilities,
  settings = {
    css = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
      },
    },
    scss = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
      },
    },
    less = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
      },
    },
  },
})

lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

lspconfig.typos_lsp.setup({
  capabilities = capabilities,
  filetypes = { "markdown", "norg" },
  init_options = {
    config = "~/projects/dotfiles/typos/typos.toml",
  },
})

-- https://www.npbee.me/posts/deno-and-typescript-in-a-monorepo-neovim-lsp
---Specialized root pattern that allows for an exclusion
---@param opt { root: string[], exclude: string[] }
---@return fun(file_name: string): string | nil
local function root_pattern_exclude(opt)
  local lsputil = require("lspconfig.util")

  return function(fname)
    local excluded_root = lsputil.root_pattern(opt.exclude)(fname)
    local included_root = lsputil.root_pattern(opt.root)(fname)

    if excluded_root then
      return nil
    else
      return included_root
    end
  end
end

-- Commenting out since 'typescript-tools.nvim' handles this configuration
-- https://github.com/pmizio/typescript-tools.nvim?tab=readme-ov-file#-installation
-- lspconfig.ts_ls.setup({
-- 	capabilities = capabilities,
-- 	root_dir = root_pattern_exclude({
-- 		root = { "package.json" },
-- 		exclude = { "deno.json", "deno.jsonc" },
-- 	}),
-- 	single_file_support = false,
-- })

require("typescript-tools").setup({
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
  },
  settings = {
    capabilities = capabilities,
    root_dir = root_pattern_exclude({
      root = { "package.json" },
      exclude = { "deno.json", "deno.jsonc" },
    }),
    single_file_support = false,
    tsserver_plugins = {
      "@vue/typescript-plugin",
    },
    completions = {
      completeFunctionCalls = false,
    },
  },
})

lspconfig.denols.setup({
  capabilities = capabilities,
  root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deno.lock"),
  init_options = {
    lint = true,
    suggest = {
      imports = {
        hosts = {
          ["https://deno.land"] = true,
        },
      },
    },
  },
})

-- RECOMMENDED 'nvim-lspconfig' SETUP
--          ╭─────────────────────────────────────────────────────────╮
--          │                         LUASNIP                         │
--          │           https://github.com/L3MON4D3/LuaSnip           │
--          ╰─────────────────────────────────────────────────────────╯
local ls = require("luasnip")

--          ╭─────────────────────────────────────────────────────────╮
--          │                     NVIM-AUTOPAIRS                      │
--          │        https://github.com/windwp/nvim-autopairs         │
--          ╰─────────────────────────────────────────────────────────╯
local npairs = require("nvim-autopairs")
npairs.setup({
  check_ts = true,
})
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

--          ╭─────────────────────────────────────────────────────────╮
--          │                        NVIM-CMP                         │
--          │           https://github.com/hrsh7th/nvim-cmp           │
--          ╰─────────────────────────────────────────────────────────╯
local cmp = require("cmp")
local ts_utils = require("nvim-treesitter.ts_utils")

---@diagnostic disable-next-line: missing-fields
cmp.setup({
  snippet = {
    expand = function(args)
      ls.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-n>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-p>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
  }),
  sources = {
    { name = "luasnip" },
    { name = "nvim_lsp" },
  },
})

-- RECOMMENDED 'nvim-lspconfig' SETUP END

-- luasnip specific configuration
-- specify luasnippets directory to save a few ms of startup time
require("luasnip.loaders.from_lua").load({ paths = { "./luasnippets/" } })

ls.config.set_config({
  -- Enable autotriggered snippets
  enable_autosnippets = false,
  -- Use Tab to trigger visual selection
  store_selection_keys = "<Tab>",
  -- show repeated node text as it's typed
  update_events = "TextChanged,TextChangedI",
})

vim.keymap.set({ "i", "s" }, "<C-j>", function()
  ls.jump(1)
end, { silent = true, desc = "Next Snippet" })

vim.keymap.set({ "i", "s" }, "<C-h>", function()
  ls.jump(-1)
end, { silent = true, desc = "Previous Snippet" })

vim.keymap.set({ "i" }, "<C-e>", function()
  ls.expand()
end, { silent = true, desc = "Expand Snippet" })

vim.keymap.set({ "i", "s" }, "<C-c>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true, desc = "Choose Snippet" })

ls.filetype_extend("javascriptreact", { "javascript" })
ls.filetype_extend("typescript", { "javascript" })
ls.filetype_extend("typescriptreact", { "javascriptreact", "javascript", "typescript" })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { unpack(opts), desc = "declaration" })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { unpack(opts), desc = "definition" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { unpack(opts), desc = "hover" })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { unpack(opts), desc = "implementation" })
    vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { unpack(opts), desc = "signature help" })
    vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { unpack(opts), desc = "type definition" })
    vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, { unpack(opts), desc = "code ACTIONS" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { unpack(opts), desc = "references" })
    vim.keymap.set("n", "gR", vim.lsp.buf.rename, { unpack(opts), desc = "rename" })
    -- conform.nvim should handle formatting
    -- vim.keymap.set("n", "<space>f", function()
    -- 	vim.lsp.buf.format({ async = true })
    -- end, { unpack(opts), desc = "format" })
  end,
  desc = "Initialize LSP on LspAttach event",
})
-- Language Server Configuration END

--          ╭─────────────────────────────────────────────────────────╮
--          │                         LUALINE                         │
--          │      https://github.com/nvim-lualine/lualine.nvim       │
--          ╰─────────────────────────────────────────────────────────╯
local function getCodeiumStatus()
  return "codeium: " .. vim.fn["codeium#GetStatusString"]()
end

require("lualine").setup({
  options = { theme = "gruvbox-material" },
  sections = {
    lualine_x = {
      -- "grapple",
      getCodeiumStatus,
    },
  },
  --TODO: Figure out how to show codeium status string in lualine
  -- winbar = {
  --   lualine_a = {
  --     "codeium#GetStatusString()"
  --   },
  -- }
})

--          ╭─────────────────────────────────────────────────────────╮
--          │                      CONFORM.NVIM                       │
--          │        https://github.com/stevearc/conform.nvim         │
--          ╰─────────────────────────────────────────────────────────╯
require("conform").setup({
  format_after_save = function(bufnr)
    local ignore_filetypes = { "norg" }
    if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
      return
    end
    return { timeout_ms = 500, lsp_format = "fallback" }
  end,
  formatters_by_ft = {
    c = { "clang-format" },
    lua = { "stylua" },
    html = { "htmlbeautifier" },
    -- ruby = { "project_rubocop" },
    eruby = { "htmlbeaufifier" },
    fish = { "fish_indent" },
    json = { "jq" },
    sh = { "shfmt" },
    sql = { "sqlfmt" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    vue = { "prettier" },
    css = { "prettier" },
    less = { "prettier" },
    scss = { "prettier" },
    zsh = { "shfmt" },
    markdown = { "prettier" },
    norg = { "typos-lsp" },
    clojure = { "cljfmt" },
    python = { "ruff" },
  },
  -- formatters = {
  --   project_rubocop = {
  --     command = "bundle",
  --     args = { "exec", "rubocop", "-a", "-f", "quiet", "--stderr", "--stdin", "$FILENAME" },
  --   },
  -- },
})

vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_fallback = true, range = range })
end, { range = true })

--          ╭─────────────────────────────────────────────────────────╮
--          │                      GRUVBOX-NVIM                       │
--          │       https://github.com/ellisonleao/gruvbox.nvim       │
--          ╰─────────────────────────────────────────────────────────╯
vim.o.background = "dark"
vim.cmd("colorscheme gruvbox")

--          ╭─────────────────────────────────────────────────────────╮
--          │                  CLIPBOARD-IMAGE.NVIM                   │
--          │     https://github.com/ekickx/clipboard-image.nvim      │
--          ╰─────────────────────────────────────────────────────────╯
--TODO: Figure out how to update the image path used in markdown links. Images are getting copied to /images/<image-name> correctly, but the markdown links reference /img/<image-name>.
require("clipboard-image").setup({
  default = {
    img_dir = "images",
  },
})

--          ╭─────────────────────────────────────────────────────────╮
--          │                         NEOGEN                          │
--          │            https://github.com/danymat/neogen            │
--          ╰─────────────────────────────────────────────────────────╯
require("neogen").setup({ snippet_engine = "luasnip" })

--          ╭─────────────────────────────────────────────────────────╮
--          │                           OIL                           │
--          │          https://github.com/stevearc/oil.nvim           │
--          ╰─────────────────────────────────────────────────────────╯
require("oil").setup()

--       ╭───────────────────────────────────────────────────────────────╮
--       │                     NVIM-TS-COMMENTSTRING                     │
--       │https://github.com/JoosepAlviste/nvim-ts-context-commentstring │
--       ╰───────────────────────────────────────────────────────────────╯
---@diagnostic disable-next-line: missing-parameter
require("ts_context_commentstring").setup()

--          ╭─────────────────────────────────────────────────────────╮
--          │                      COMMENT.NVIM                       │
--          │        https://github.com/numToStr/Comment.nvim         │
--          ╰─────────────────────────────────────────────────────────╯
require("Comment").setup()

--          ╭─────────────────────────────────────────────────────────╮
--          │                       NVIM-NOTIFY                       │
--          │         https://github.com/rcarriga/nvim-notify         │
--          ╰─────────────────────────────────────────────────────────╯
---@diagnostic disable-next-line: missing-fields
require("notify").setup({
  background_colour = "#000000",
  render = "compact",
})

local telescope = require("telescope")
telescope.load_extension("notify")

--          ╭─────────────────────────────────────────────────────────╮
--          │                    TELESCOPE-IMPORT                     │
--          │  https://github.com/piersolenski/telescope-import.nvim  │
--          ╰─────────────────────────────────────────────────────────╯
telescope.load_extension("import")

--          ╭─────────────────────────────────────────────────────────╮
--          │                     TELESCOPE-TABS                      │
--          │   https://github.com/LukasPietzschmann/telescope-tabs   │
--          ╰─────────────────────────────────────────────────────────╯
telescope.load_extension("telescope-tabs")
require("telescope-tabs").setup()

--        ╭─────────────────────────────────────────────────────────────╮
--        │                    TELESCOPE-MEDIA-FILES                    │
--        │https://github.com/nvim-telescope/telescope-media-files.nvim │
--        ╰─────────────────────────────────────────────────────────────╯
telescope.load_extension("media_files")
telescope.setup({
  extensions = { media_files = { file_types = { "png", "jpg", "jpeg", "mp4", "webm", "pdf" }, find_cmd = "rg" } },
})

--          ╭─────────────────────────────────────────────────────────╮
--          │                      OVERSEER.NVIM                      │
--          │        https://github.com/stevearc/overseer.nvim        │
--          ╰─────────────────────────────────────────────────────────╯
require("overseer").setup({
  templates = { "builtin" },
})

--          ╭─────────────────────────────────────────────────────────╮
--          │                     WHICH-KEY.NVIM                      │
--          │         https://github.com/folke/which-key.nvim         │
--          ╰─────────────────────────────────────────────────────────╯
local wk = require("which-key")

wk.add({
  -- Miscellaneous
  { "<leader>I", "<cmd>Telescope import<cr>", desc = "Import" },
  { "<leader>p", "<cmd>Format<cr>", desc = "Pretty" },
  { "<leader>sh", "<cmd>Telescope search_history<cr>", desc = "Search History" },
  { "<leader>m", "<cmd>Grapple tag<cr>", desc = "Grapple Tag" },
  { "<leader>M", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple Move" },
  { "<leader>z", "<cmd>Telescope spell_suggest<cr>", desc = "Spell Suggest" },
  -- Codeium
  { "<leader>C", group = "[C]odeium" },
  { "<leader>Ce", "<cmd>Codeium Enable<cr>", desc = "Codeium Enable" },
  { "<leader>Cd", "<cmd>Codeium Disable<cr>", desc = "Codeium Disable" },
  { "<leader>Ct", "<cmd>Codeium Toggle<cr>", desc = "Codeium Toggle" },
  { "<leader>Cc", "<cmd>lua vim.fn['codeium#Chat']()<cr>", desc = "Codeium Chat" },
  -- Comment Box
  { "<leader>c", group = "[c]omment Box" },
  -- nesting so I don't have to repeat the mode
  {
    mode = { "n", "v" },
    { "<leader>cb", "<cmd>CBccbox<cr>", desc = "[b]ox" },
    { "<leader>ct", "<cmd>CBllline<cr>", desc = "[t]itled Line" },
    { "<leader>cl", "<cmd>CBline<cr>", desc = "[l]ine" },
    { "<leader>cm", "<cmd>CBllbox14<cr>", desc = "[m]arked" },
    { "<leader>cq", "<cmd>CBllbox13<cr>", desc = "[q]uoted" },
    { "<leader>cr", "<cmd>CBd<cr>", desc = "[r]emove box" },
  },
  -- Ex commands
  { "<leader>e", group = "[E]x Commands" },
  { "<leader>ec", "<cmd>Telescope commands<cr>", desc = "Ex Commands" },
  { "<leader>eh", "<cmd>Telescope command_history<cr>", desc = "Ex Command History" },
  -- Diffview
  { "<leader>d", group = "Diffview" },
  { "<leader>da", "<cmd>DiffviewFileHistory<cr>", desc = "All Files" },
  { "<leader>dc", "<cmd>DiffviewFileHistory %<cr>", desc = "Current File" },
  { "<leader>df", "<cmd>DiffviewFocusFiles<cr>", desc = "Focus Files" },
  { "<leader>dr", "<cmd>DiffviewRefresh<cr>", desc = "Refresh" },
  { "<leader>dt", "<cmd>DiffviewToggleFiles<cr>", desc = "Toggle Files" },
  { "<leader>ds", "<cmd>DiffviewOpen<cr>", desc = "Open" },
  { "<leader>dm", "<cmd>DiffviewOpen main..@<cr>", desc = "Main to Current" },
  { "<leader>dq", "<cmd>DiffviewClose<cr>", desc = "Quit" },
  { "<leader>dx", "<cmd>DiffviewFileHistory<cr>", desc = "Selected" },
  -- Files
  { "<leader>f", group = "Files" },
  { "<leader>fa", "<cmd>Telescope autocommands<cr>", desc = "Autocommands" },
  { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "File(s)" },
  { "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "Live Search" },
  { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Git-tracked File(s)" },
  { "<leader>fi", "<cmd>Telescope media_files<cr>", desc = "Images & Media File(s)" },
  { "<leader>fl", "<cmd>Telescope resume<cr>", desc = "Last Search Results" },
  { "<leader>fo", "<cmd>Oil<cr>", desc = "Oil" },
  { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent File(s)" },
  { "<leader>ft", "<cmd>Telescope filetypes<cr>", desc = "Filetypes" },
  -- Git
  { "<leader>G", group = "Git" },
  { "<leader>Gf", "<cmd>Telescope git_bcommits<cr>", desc = "File History" },
  { "<leader>Gb", "<cmd>Telescope git_branches<cr>", desc = "Branches" },
  { "<leader>Gc", "<cmd>Telescope git_commits<cr>", desc = "Commits" },
  { "<leader>Gs", "<cmd>Telescope git_status<cr>", desc = "Status" },
  { "<leader>Gw", "<cmd>Telescope git_stash<cr>", desc = "WIP (Stashed)" },
  -- Requests
  { "<leader>R", group = "Request" },
  { "<leader>Rs", "<Plug>RestNvim", desc = "Send" },
  { "<leader>Rp", "<Plug>RestNvimPreview", desc = "Preview" },
  { "<leader>Rr", "<Plug>RestNvimLast", desc = "Repeat Last" },
  -- Browse URLs
  { "<leader>B", group = "Browse URLs" },
  { "<leader>Ba", "<cmd>UrlView<cr>", desc = "All URLs" },
  { "<leader>Bp", "<cmd>UrlView lazy<cr>", desc = "Plugin URLs" },
  -- Box
  { "<leader>b", group = "Box" },
  { "<leader>bb", "<cmd>CBccbox<cr>", desc = "Box Title" },
  { "<leader>bt", "<cmd>CBllline<cr>", desc = "Titled Line" },
  { "<leader>bl", "<cmd>CBline<cr>", desc = "Simple Line" },
  { "<leader>bm", "<cmd>CBllbox14<cr>", desc = "Marked" },
  { "<leader>bq", "<cmd>CBllbox13<cr>", desc = "Quote" },
  { "<leader>br", "<cmd>CBd<cr>", desc = "Remove Box Around Comment" },
  -- Hunks
  { "<leader>h", group = "Hunks", desc = "Hunks" },
  -- Jump
  { "<leader>j", group = "Jump" },
  { "<leader>jf", "<cmd>Portal jumplist forward<cr>", desc = "Forward" },
  { "<leader>jb", "<cmd>Portal jumplist backward<cr>", desc = "Backward" },
  -- Keymaps
  { "<leader>k", group = "Keymaps" },
  { "<leader>kl", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
  -- LSP
  { "<leader>l", group = "LSP" },
  { "<leader>lD", "<cmd>Telescope lsp_definitions()<cr>", desc = "Definitions" },
  { "<leader>ld", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
  { "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<cr>", desc = "Hover" },
  { "<leader>li", "<cmd>Telescope implementations<cr>", desc = "Implementations" },
  { "<leader>ll", "<cmd>vim.diagnostic.loclist()<cr>", desc = "Set Location List" },
  { "<leader>lo", "<cmd>vim.diagnostic.open_float<cr>", desc = "Open Float" },
  { "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<cr>", desc = "Signature Help" },
  { "<leader>lr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
  { "<leader>lt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Type Definitions" },
  { "<leader>lp", "<cmd>vim.diagnostic.goto_prev<cr>", desc = "Go-To Prev Diagnostic" },
  { "<leader>ln", "<cmd>vim.diagnostic.goto_next<cr>", desc = "Go-To Next Diagnostic" },
  { "<leader>lR", "<cmd>LspRestart<cr>", desc = "Restart" },
  { "<leader>lQ", "<cmd>LspStop<cr>", desc = "Quit" },
  { "<leader>lS", "<cmd>LspStart<cr>", desc = "Start LSP" },
  -- { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Actions" },
  -- <leader>lc change name
  { "<leader>lT", "<cmd>lua vim.lsp.buf.type_definition()<cr>", desc = "Type Definition" },
  --          ╭─────────────────────────────────────────────────────────╮
  --          │                    live-server.nvim                     │
  --          │    https://github.com/barrett-ruth/live-server.nvim     │
  --          ╰─────────────────────────────────────────────────────────╯
  { "<leader>L", group = "Live Server" },
  { "<leader>Ls", "<cmd>LiveServerStart<cr>", desc = "Start" },
  { "<leader>Lt", "<cmd>LiveServerStop<cr>", desc = "Stop" },
  -- Neogen
  { "<leader>n", group = "Neogen" },
  {
    "<leader>nf",
    "<cmd>lua require('neogen').generate({ type = 'func' })<cr>",
    desc = "Generate Function Annotation",
  },
  { "<leader>nc", "<cmd>lua require('neogen').generate({ type = 'class' })<cr>", desc = "Generate Class Annotation" },
  { "<leader>nt", "<cmd>lua require('neogen').generate({ type = 'type' })<cr>", desc = "Generate Type Annotation" },
  -- Jira
  { "<leader>J", group = "Jira" },
  { "<leader>Jv", "<cmd>JiraView<cr>", desc = "View Issue" },
  { "<leader>Jo", "<cmd>JiraOpen<cr>", desc = "Open Issue in Browser" },
  -- Overseer
  { "<leader>o", group = "Overseer" },
  { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle" },
  { "<leader>oc", "<cmd>OverseerClose<cr>", desc = "Close" },
  { "<leader>oo", "<cmd>OverseerOpen<cr>", desc = "Open" },
  { "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Info" },
  { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run" },
  -- Tabs
  { "<leader>t", group = "Tabs" },
  { "<leader>tl", "<cmd>Telescope telescope-tabs list_tabs<cr>", desc = "List" },
  -- Quickfix
  { "<leader>q", group = "Quickfix" },
  { "<leader>ql", "<cmd>Telescope quickfix<cr>", desc = "List" },
  { "<leader>qh", "<cmd>Telescope quickfix_history<cr>", desc = "History" },
  -- Snippets
  { "<leader>S", group = "Snippets" },
  {
    "<leader>Sl",
    "<cmd>lua require('luasnip.loaders.from_lua').load({ paths = './luasnippets' })<cr>",
    desc = "Load",
    silent = true,
  },
  -- Word
  { "<leader>w", group = "Word" },
  { "<leader>wd", "<cmd>Telescope thesaurus lookup<cr>", desc = "Definition" },
  { "<leader>ws", "<cmd>Telescope thesaurus query<cr>", desc = "Search" },
})

require("diffview").setup({
  view = {
    merge_tool = {
      layout = "diff4_mixed",
    },
  },
})
--          ╭─────────────────────────────────────────────────────────╮
--          │                     CODEWINDOW.NVIM                     │
--          │       https://github.com/gorbit99/codewindow.nvim       │
--          ╰─────────────────────────────────────────────────────────╯
local codewindow = require("codewindow")
codewindow.setup()

telescope.load_extension("fzf")

--        ╭────────────────────────────────────────────────────────────╮
--        │                    TELESCOPE-FZF-NATIVE                    │
--        │https://github.com/nvim-telescope/telescope-fzf-native.nvim │
--        ╰────────────────────────────────────────────────────────────╯
---@diagnostic disable-next-line: missing-parameter
telescope.setup({
  extensions = {
    import = {
      insert_at_top = true,
    },
  },
})

--          ╭─────────────────────────────────────────────────────────╮
--          │                  INDENT-BLANKLINE.NVIM                  │
--          │ https://github.com/lukas-reineke/indent-blankline.nvim  │
--          ╰─────────────────────────────────────────────────────────╯

require("ibl").setup()

--    ╭────────────────────────────────────────────────────────────────────╮
--    │                         SMART-SPLITS.NVIM                          │
--    │https://github.com/mrjones2014/smart-splits.nvim?tab=readme-ov-file │
--    ╰────────────────────────────────────────────────────────────────────╯
require("smart-splits").setup({
  resize_mode = { hooks = { on_leave = require("bufresize").register } },
})

--          ╭─────────────────────────────────────────────────────────╮
--          │                          NEORG                          │
--          │           https://github.com/nvim-neorg/neorg           │
--          ╰─────────────────────────────────────────────────────────╯
require("neorg").setup({
  load = {
    ["core.defaults"] = {}, -- Loads default behaviour
    ["core.concealer"] = {}, -- Adds pretty icons to your documents
    ["core.dirman"] = { -- Manages Neorg workspaces
      config = {
        workspaces = {
          su = "~/projects/work_notes/su/2024",
          ooo = "~/projects/work_notes/ooo/2024",
          home = "~/projects/home_notes",
        },
      },
    },
    ["core.keybinds"] = { config = { default_keybinds = {} } },
    ["core.completion"] = {
      config = {
        engine = "nvim-cmp",
      },
    },
  },
})

vim.api.nvim_create_user_command("Note", function(opts)
  local name = opts.fargs[1]
  vim.cmd("e ~/projects/home_notes/" .. name .. ".norg")
end, { range = false, nargs = 1 })

vim.api.nvim_create_user_command("SU", function(opts)
  local date = os.date("%Y-%m-%d")
  if opts.fargs[1] == "yesterday" then
    date = os.date("%Y-%m-%d", os.time() - 86400)
  elseif opts.fargs[1] == "today" then
    date = os.date("%Y-%m-%d")
  --TODO: Figure out how to create a SU note for the next Monday if current day is Friday
  elseif opts.fargs[1] == "tomorrow" then
    date = os.date("%Y-%m-%d", os.time() + 86400)
  elseif opts.fargs[1] == "monday" then
    date = os.date("%Y-%m-%d", os.time() + 86400 * (8 - os.date("%w")))
  else
    print("Invalid date")
    return
  end
  vim.cmd("e ~/projects/work_notes/su/2024/" .. date .. ".norg")
end, { range = false, nargs = 1 })

vim.api.nvim_create_user_command("Ticket", function(opts)
  local ticket_no = opts.fargs[1]
  local desc = opts.fargs[2]
  if tonumber(ticket_no) == nil then
    print("Invalid ticket")
    return
  end
  if type(desc) ~= "string" then
    print("Invalid ticket description")
    return
  end
  vim.cmd("e ~/projects/work_notes/tickets/KEET-" .. ticket_no .. "-" .. desc .. ".norg")
end, { nargs = "*" })

--TODO: Create a 'OOO' command to create One on One files

vim.cmd([[
  augroup neorg_cmds
    autocmd BufNewFile ~/projects/work_notes/su/**/*.norg 0read ~/projects/dotfiles/nvim/norg/templates/standup_template.norg
    autocmd BufNewFile ~/projects/work_notes/ooo/**/*.norg 0read ~/projects/dotfiles/nvim/norg/templates/ooo_template.norg
    autocmd FileType norg setlocal conceallevel=3
    " Figure out how to stop folds from getting created on buffers created after first entering into a .norg buffer
    autocmd BufWritePost ~/projects/work_notes/su/**/*.norg silent !git -C ~/projects/work_notes/su/ add . && git -C ~/projects/work_notes/su/ commit -m "Update work notes" && git -C ~/projects/work_notes/su/ push
    autocmd BufWritePost ~/projects/work_notes/ooo/**/*.norg silent !git -C ~/projects/work_notes/ooo/ add . && git -C ~/projects/work_notes/ooo/ commit -m "Update work notes" && git -C ~/projects/work_notes/ooo/ push
    " Figure out why recursive file pattern like ~/projects/home_notes/**/*.norg doesn't work?
    autocmd BufWritePost ~/projects/home_notes/*.norg silent !git -C ~/projects/home_notes/ add . && git -C ~/projects/home_notes/ commit -m "Update home notes" && git -C ~/projects/home_notes/ push
  augroup END
]])

--          ╭─────────────────────────────────────────────────────────╮
--          │                       COPILOT.VIM                       │
--          │          https://github.com/github/copilot.vim          │
--          ╰─────────────────────────────────────────────────────────╯
vim.cmd([[
  let g:copilot_filetypes = { 'norg': v:false }
]])

--         ╭───────────────────────────────────────────────────────────╮
--         │                  NVIM-TREESITTER-CONTEXT                  │
--         │https://github.com/nvim-treesitter/nvim-treesitter-context │
--         ╰───────────────────────────────────────────────────────────╯
require("treesitter-context").setup({
  max_lines = 5,
})

--          ╭─────────────────────────────────────────────────────────╮
--          │                       VIM-RHUBARB                       │
--          │          https://github.com/tpope/vim-rhubarb           │
--          ╰─────────────────────────────────────────────────────────╯
vim.api.nvim_create_user_command("Browse", function(opts)
  vim.fn.system({ "open", opts.fargs[1] })
end, { nargs = 1 })

require("urlview").setup({})

--          ╭─────────────────────────────────────────────────────────╮
--          │                      GITSIGNS.NVIM                      │
--          │       https://github.com/lewis6991/gitsigns.nvim        │
--          ╰─────────────────────────────────────────────────────────╯
require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, { expr = true, desc = "Next Hunk" })

    map("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end, { expr = true, desc = "Prev Hunk" })

    map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage Hunk" })
    map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset Hunk" })
    map("v", "<leader>hs", function()
      gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Stage Hunk" })
    map("v", "<leader>hr", function()
      gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Reset Hunk" })
    --TODO: Determine better buffer-wide actions
    map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage Buffer" })
    map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
    map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset Buffer" })
    map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview Hunk" })
    --TODO: Deteremine better keymap for this
    map("n", "<leader>hb", function()
      gs.blame_line({ full = true })
    end, { desc = "Blame Line" })

    -- Text object
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
  end,
})

--          ╭─────────────────────────────────────────────────────────╮
--          │                         Codeium                         │
--          │       https://github.com/Exafunction/codeium.vim        │
--          ╰─────────────────────────────────────────────────────────╯
vim.g.codeium_disable_bindings = 1
vim.g.codeium_no_map_tab = 1
-- defaults: https://github.com/Exafunction/codeium.vim?tab=readme-ov-file#%EF%B8%8F-keybindings
-- set the Meta key in iTerm2 > Preferences > Profiles > Keys > Left Option Key to Esc+
vim.keymap.set("i", "<C-g>", function()
  return vim.fn["codeium#Accept"]()
end, { expr = true, silent = true, desc = "Codeium Accept" })

vim.keymap.set("i", "<C-x>", function()
  return vim.fn["codeium#Clear"]()
end, { expr = true, silent = true, desc = "Codeium Clear" })

vim.cmd([[
  let g:codeium_filetypes = {
    \ "norg": v:false,
    \ "markdown": v:false,
    \ }
]])

--          ╭─────────────────────────────────────────────────────────╮
--          │                     NVIM-COLORIZER                      │
--          │     https://github.com/norcalli/nvim-colorizer.lua      │
--          ╰─────────────────────────────────────────────────────────╯
require("colorizer").setup()

--          ╭─────────────────────────────────────────────────────────╮
--          │                        OCTO.NVIM                        │
--          │         https://github.com/pwntester/octo.nvim          │
--          ╰─────────────────────────────────────────────────────────╯
require("octo").setup({
  default_to_projects_v2 = true,
  mappings_disable_default = true,
})

-- ── GENERAL ─────────────────────────────────────────────────────────
local set = vim.opt

-- autoindent new lines
set.autoindent = true
-- expands tabs into spaces
set.expandtab = true
-- number of spaces to use for each tab
set.tabstop = 2
-- number of spaces to use when indenting
set.shiftwidth = 2
-- number of spaces to use for (auto)indent step
set.softtabstop = 2
set.ignorecase = true
set.smartcase = true
set.number = true
set.splitbelow = true
set.splitright = true
-- set.scrolloff = 999
set.hlsearch = false
set.wildignore = "node_modules/*"
set.number = true
set.relativenumber = true
vim.cmd([[autocmd FileType * set formatoptions-=ro]])
set.syntax = "on"
set.termguicolors = true
set.virtualedit = "block"
set.inccommand = "split"

-- disable mouse
set.mouse = ""
-- ╓
-- ║ https://stackoverflow.com/questions/4642822/how-to-make-bashrc-aliases-available-within-a-vim-shell-command
-- ╙
set.shellcmdflag = "-ic"
vim.keymap.set("n", "n", "nzz", { silent = true, desc = "Search Next" })
vim.keymap.set("n", "N", "Nzz", { silent = true, desc = "Search Prev" })
vim.keymap.set("i", "<C-b>", "<CR><ESC>kA<CR>", { silent = true, desc = "Insert blank line" })
-- vim.keymap.set("i", "<C-o>", "<CR><ESC>I")
-- do not open folds when searching for text
vim.cmd([[set foldopen-=search]])
-- do not open folds when moving cursor
vim.diagnostic.config({ virtual_text = { source = true } })

vim.filetype.add({
  filename = {
    ["Brewfile"] = "brewfile",
  },
})
