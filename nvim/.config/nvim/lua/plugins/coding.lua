return {
  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    version = "1.*",
    dependencies = { "rafamadriz/friendly-snippets", "folke/lazydev.nvim" },
    opts = {
      snippets = { preset = "default" },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = { lua = { inherit_defaults = true, "lazydev" } },
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },
      cmdline = {
        enabled = true,
        keymap = { preset = "cmdline", ["<Right>"] = false, ["<Left>"] = false },
        completion = {
          list = { selection = { preselect = false } },
          menu = { auto_show = function(ctx) return vim.fn.getcmdtype() == ":" end },
          ghost_text = { enabled = true },
        },
      },
      keymap = { preset = "enter", ["<C-y>"] = { "select_and_accept" } },
    },
  },
  {
    "nvim-mini/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      skip_ts = { "string" },
      skip_unbalanced = true,
      markdown = true,
    },
  },
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
          d = { "%f[%d]%d+" },
          e = {
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          u = ai.gen_spec.function_call(),
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
        },
      }
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "nvim-lspconfig", words = { "lspconfig.settings" } },
      },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      ensure_installed = {
        "bash", "c", "diff", "go", "html", "javascript", "jsdoc", "json",
        "lua", "luadoc", "luap", "markdown", "markdown_inline", "printf",
        "python", "query", "regex", "rust", "svelte", "toml", "tsx",
        "typescript", "vim", "vimdoc", "vue", "xml", "yaml",
      },
      highlight = { enable = true },
      indent = { enable = true },
      folds = { enable = true },
    },
    config = function(_, opts)
      local TS = require("nvim-treesitter")
      TS.setup({})
      local installed = TS.get_installed and TS.get_installed() or {}
      local missing = vim.tbl_filter(function(lang)
        return not vim.tbl_contains(installed, lang)
      end, opts.ensure_installed)
      if #missing > 0 then
        TS.install(missing)
      end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          if not (lang and pcall(vim.treesitter.get_parser, ev.buf, lang)) then
            return
          end
          if opts.highlight.enable then
            pcall(vim.treesitter.start, ev.buf)
          end
          if opts.indent.enable then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
          if opts.folds.enable then
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      select = { lookahead = true },
      move = {
        enable = true,
        set_jumps = true,
        keys = {
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter-textobjects").setup(opts)

      local select = require("nvim-treesitter-textobjects.select")
      local function map_select(lhs, query)
        vim.keymap.set({ "x", "o" }, lhs, function() select.select_textobject(query, "textobjects") end)
      end
      map_select("af", "@function.outer")
      map_select("if", "@function.inner")
      map_select("ac", "@class.outer")
      map_select("ic", "@class.inner")
      map_select("aa", "@parameter.outer")
      map_select("ia", "@parameter.inner")

      local swap = require("nvim-treesitter-textobjects.swap")
      vim.keymap.set("n", "<leader>a", function() swap.swap_next("@parameter.inner") end, { desc = "Swap next parameter" })
      vim.keymap.set("n", "<leader>A", function() swap.swap_previous("@parameter.inner") end, { desc = "Swap prev parameter" })

      local move = require("nvim-treesitter-textobjects.move")
      local function attach(buf)
        for method, keymaps in pairs(opts.move.keys) do
          for key, query in pairs(keymaps) do
            vim.keymap.set({ "n", "x", "o" }, key, function()
              if vim.wo.diff and key:find("[cC]") then
                return vim.cmd("normal! " .. key)
              end
              move[method](query, "textobjects")
            end, { buffer = buf, silent = true })
          end
        end
      end
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev) attach(ev.buf) end,
      })
      vim.tbl_map(attach, vim.api.nvim_list_bufs())
    end,
  },
}
