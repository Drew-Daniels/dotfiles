return {
  name = "lint_fix",
  builder = function()
    local file = vim.fn.expand("%:p")
    return {
      cmd = { "pnpm", "lint:fix" },
      args = { file },
      name = "ESLint Fix",
    }
  end,
}
