return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          header = [[
██████╗ ███████╗███████╗███████╗███╗   ██╗
██╔══██╗██╔════╝╚══███╔╝██╔════╝████╗  ██║
██║  ██║█████╗    ███╔╝ █████╗  ██╔██╗ ██║
██║  ██║██╔══╝   ███╔╝  ██╔══╝  ██║╚██╗██║
██████╔╝███████╗███████╗███████╗██║ ╚████║
╚═════╝ ╚══════╝╚══════╝╚══════╝╚═╝  ╚═══╝]],
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
      explorer = { enabled = true, replace_netrw = true },
      indent = {
        enabled = true,
        -- personal customization: rounded-corner indent chunk glyphs
        chunk = {
          enabled = true,
          char = {
            corner_top    = "╭",
            corner_bottom = "╰",
            horizontal    = "─",
            vertical      = "│",
            arrow         = "›",
          },
        },
        animate = {
          enabled = true,
          duration = { step = 20, total = 300 },
        },
      },
      input = { enabled = true },
      notifier = { enabled = true },
      picker = {
        enabled = true,
        -- personal customization: tree glyphs + explorer/files picker sources
        icons = {
          tree = {
            vertical = "│ ",
            middle   = "├╴",
            last     = "╰╴",
          },
        },
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
            layout = { preview = "main", layout = { preset = "ivy_split" } },
          },
          files = {
            hidden = true,
            ignored = false,
          },
        },
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      -- statuscolumn handled by native opt.statuscolumn in options.lua-equivalent; keep snacks' off
      statuscolumn = { enabled = false },
      words = { enabled = true },
      -- personal customization: floating terminal + kitty image backend
      terminal = {
        win = { position = "float", border = "rounded" },
      },
      image = {
        enabled = true,
        backend = "kitty",
        force = false,
      },
      styles = {
        notification = { border = "rounded" },
      },
    },
    keys = {
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart find files" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find config file" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Grep word", mode = { "n", "x" } },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help pages" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>e", function() Snacks.explorer() end, desc = "Explorer" },
      { "<leader>n", function()
        if Snacks.config.picker and Snacks.config.picker.enabled then
          Snacks.picker.notifications()
        else
          Snacks.notifier.show_history()
        end
      end, desc = "Notification History" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    },
  },
}
