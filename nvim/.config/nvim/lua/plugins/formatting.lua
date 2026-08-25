return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
        mode = "",
        desc = "Format buffer",
      },
      {
        "<leader>uf",
        function()
          vim.g.autoformat = not vim.g.autoformat
          vim.notify("Autoformat " .. (vim.g.autoformat and "enabled" or "disabled"))
        end,
        desc = "Toggle autoformat",
      },
    },
    opts = {
      format_on_save = function(bufnr)
        if vim.g.autoformat == false or vim.b[bufnr].autoformat == false then
          return
        end
        return { timeout_ms = 3000, lsp_format = "fallback" }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        sh = { "shfmt" },
        javascript = { "biome-check", "prettier", stop_after_first = true },
        javascriptreact = { "biome-check", "prettier", stop_after_first = true },
        typescript = { "biome-check", "prettier", stop_after_first = true },
        typescriptreact = { "biome-check", "prettier", stop_after_first = true },
        json = { "biome-check", "prettier", stop_after_first = true },
        css = { "biome-check", "prettier", stop_after_first = true },
        vue = { "prettier" },
        svelte = { "prettier" },
        python = { "ruff_format" },
        go = { "goimports", "gofumpt" },
        rust = { "rustfmt" },
      },
      formatters = {
        ["biome-check"] = {
          condition = function(_, ctx)
            return vim.fs.find(
              { "biome.json", "biome.jsonc" },
              { path = ctx.filename, upward = true }
            )[1] ~= nil
          end,
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      linters_by_ft = {
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        vue = { "eslint_d" },
        python = { "ruff" },
        go = { "golangcilint" },
        fish = { "fish" },
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
