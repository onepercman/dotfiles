return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
██████╗ ███████╗███████╗███████╗███╗   ██╗
██╔══██╗██╔════╝╚══███╔╝██╔════╝████╗  ██║
██║  ██║█████╗    ███╔╝ █████╗  ██╔██╗ ██║
██║  ██║██╔══╝   ███╔╝  ██╔══╝  ██║╚██╗██║
██████╔╝███████╗███████╗███████╗██║ ╚████║
╚═════╝ ╚══════╝╚══════╝╚══════╝╚═╝  ╚═══╝]],
        },
      },
      indent = {
        scope = { enabled = true },
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
      image = {
        enabled = true,
        backend = "kitty",
        force = false,
      },
      terminal = {
        win = { position = "float", border = "rounded" },
      },
      picker = {
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
    },
  },
}
