return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = { "stylua", "shfmt" },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      -- explicit vim.lsp.enable() list in nvim-lspconfig config below is the
      -- single source of truth; disable mason-lspconfig's own auto-enable to
      -- avoid it silently attaching unrelated mason packages as LSP clients
      automatic_enable = false,
      ensure_installed = { "lua_ls", "vtsls", "tailwindcss", "vue_ls", "svelte" },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "bufferline.nvim", words = { "nvim_bufferline" } },
      },
    },
  },
  {
    -- all servers registered via the Neovim 0.11+ vim.lsp.config/vim.lsp.enable API
    "neovim/nvim-lspconfig",
    config = function()
      -- diagnostic signs/float/virtual_text already configured with the
      -- personal icon set in config/options.lua -- not duplicated here.

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            codeLens = { enable = true },
            completion = { callSnippet = "Replace" },
            doc = { privateName = { "^_" } },
            hint = {
              enable = true,
              setType = false,
              paramType = true,
              paramName = "Disable",
              semicolon = "Disable",
              arrayIndex = "Disable",
            },
          },
        },
      })

      vim.lsp.config("vtsls", {
        settings = {
          complete_function_calls = true,
          vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            experimental = {
              maxInlayHintLength = 30,
              completion = { enableServerSideFuzzyMatch = true },
            },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = { completeFunctionCalls = true },
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = false },
            },
          },
        },
      })

      vim.lsp.config("tailwindcss", {
        filetypes_exclude = { "markdown" },
        settings = {
          tailwindCSS = {
            includeLanguages = { elixir = "html-eex", eelixir = "html-eex", heex = "html-eex" },
          },
        },
      })

      vim.lsp.config("vue_ls", {})
      vim.lsp.config("svelte", {})

      -- basedpyright + ruff run together: basedpyright for hover/completion/types,
      -- ruff for diagnostics/actions (its own hover disabled below)
      vim.lsp.config("basedpyright", {
        settings = { python = { analysis = { typeCheckingMode = "basic" } } },
      })
      vim.lsp.config("ruff", {
        cmd_env = { RUFF_TRACE = "messages" },
        init_options = { settings = { logLevel = "error" } },
      })

      vim.lsp.config("rust_analyzer", {
        settings = { ["rust-analyzer"] = { check = { command = "clippy" } } },
      })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            gofumpt = true,
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            analyses = { nilness = true, unusedparams = true, unusedwrite = true, useany = true },
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
          },
        },
      })

      vim.lsp.enable({
        "lua_ls", "vtsls", "tailwindcss", "vue_ls", "svelte",
        "basedpyright", "ruff", "rust_analyzer", "gopls",
      })

      -- disable ruff's hover in favor of basedpyright's
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end
        end,
      })

      -- inlay hints (vue_ls's are noisy/unreliable, so skip vue)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buf = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if
            client
            and client:supports_method("textDocument/inlayHint")
            and vim.bo[buf].filetype ~= "vue"
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = buf })
          end
        end,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local buf = event.buf
          local function has(method)
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            return client and client:supports_method(method)
          end
          local function map(mode, lhs, rhs, desc, opts_)
            opts_ = opts_ or {}
            opts_.buffer = buf
            opts_.desc = desc
            vim.keymap.set(mode, lhs, rhs, opts_)
          end
          map("n", "<leader>cl", function() Snacks.picker.lsp_config() end, "Lsp Info")
          if has("textDocument/definition") then
            map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
          end
          map("n", "gr", vim.lsp.buf.references, "References", { nowait = true })
          map("n", "gI", vim.lsp.buf.implementation, "Goto Implementation")
          map("n", "gy", vim.lsp.buf.type_definition, "Goto Type Definition")
          map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
          map("n", "K", vim.lsp.buf.hover, "Hover")
          if has("textDocument/signatureHelp") then
            map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
            map("i", "<c-k>", vim.lsp.buf.signature_help, "Signature Help")
          end
          if has("textDocument/codeAction") then
            map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          end
          if has("textDocument/codeLens") then
            map({ "n", "x" }, "<leader>cc", vim.lsp.codelens.run, "Run Codelens")
            map("n", "<leader>cC", function() vim.lsp.codelens.enable(true, { bufnr = buf }) end, "Refresh & Display Codelens")
          end
          if has("workspace/willRenameFiles") or has("workspace/didRenameFiles") then
            map("n", "<leader>cR", function() Snacks.rename.rename_file() end, "Rename File")
          end
          if has("textDocument/rename") then
            map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
          end
          if has("textDocument/documentHighlight") then
            map("n", "]]", function() Snacks.words.jump(vim.v.count1) end, "Next Reference")
            map("n", "[[", function() Snacks.words.jump(-vim.v.count1) end, "Prev Reference")
            map("n", "<a-n>", function() Snacks.words.jump(vim.v.count1, true) end, "Next Reference")
            map("n", "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end, "Prev Reference")
          end
        end,
      })
    end,
  },
}
