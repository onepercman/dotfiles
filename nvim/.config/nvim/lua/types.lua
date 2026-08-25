---@meta

-- snacks.nvim doesn't declare `enabled` on snacks.picker.Config even though
-- it's read at runtime (see snacks/init.lua's per-module enabled check).
---@class snacks.picker.Config
---@field enabled? boolean

-- trouble.nvim's `trouble.api: trouble.actions` inherits action methods typed
-- as fun(self, ctx) (the internal view:next(ctx) signature). At runtime
-- require("trouble").next/prev actually resolve through api.lua's __index to
-- M._action(k), a single-arg fun(opts?) wrapper -- the public call signature.
---@class trouble.api
---@field next fun(opts?: table|string): trouble.View?
---@field prev fun(opts?: table|string): trouble.View?
