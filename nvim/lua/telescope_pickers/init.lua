-- Custom telescope pickers
-- Modified from buil-in picker: https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/builtin/init.lua
local pickers = {}

-- Ref: https://github.com/tjdevries/lazy.nvim
local function require_on_exported_call(mod)
  return setmetatable({}, {
    __index = function(_, picker)
      return function(...)
        return require(mod)[picker](...)
      end
    end,
  })
end

--- Lists diagnostics
--- - Fields:
---   - `All severity flags can be passed as `string` or `number` as per `:vim.diagnostic.severity:`
--- - Default keymaps:
---   - `<C-l>`: show autocompletion menu to prefilter your query with the diagnostic you want to see (i.e. `:warning:`)
--- - sort_by option:
---   - "buffer": order by bufnr (prioritizing current bufnr), severity, lnum
---   - "severity": order by severity, bufnr (prioritizing current bufnr), lnum
---@param opts table: options to pass to the picker
---@field bufnr number|nil: Buffer number to get diagnostics from. Use 0 for current buffer or nil for all buffers
---@field severity string|number: filter diagnostics by severity name (string) or id (number)
---@field severity_limit string|number: keep diagnostics equal or more severe wrt severity name (string) or id (number)
---@field severity_bound string|number: keep diagnostics equal or less severe wrt severity name (string) or id (number)
---@field root_dir string|boolean: if set to string, get diagnostics only for buffers under this dir otherwise cwd
---@field no_unlisted boolean: if true, get diagnostics only for listed buffers
---@field no_sign boolean: hide DiagnosticSigns from Results (default: false)
---@field line_width string|number: set length of diagnostic entry text in Results. Use 'full' for full untruncated text
---@field namespace number: limit your diagnostics to a specific namespace
---@field disable_coordinates boolean: don't show the line & row numbers (default: false)
---@field sort_by string: sort order of the diagnostics results; see above notes (default: "buffer")
-- pickers.diagnostics = require_on_exported_call("diagnostics").get
-- local diagnostics = require"telescope_pickers.diagnostics"
-- pickers.diagnostics = diagnostics.get
pickers.diagnostics = require_on_exported_call("telescope_pickers.diagnostics").get

local apply_config = function(mod)
  for k, v in pairs(mod) do
    mod[k] = function(opts)
      local pickers_conf = require("telescope.config").pickers

      opts = opts or {}
      opts.bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
      opts.winnr = opts.winnr or vim.api.nvim_get_current_win()
      local pconf = pickers_conf[k] or {}
      local defaults = (function()
        if pconf.theme then
          return require("telescope.themes")["get_" .. pconf.theme](pconf)
        end
        return vim.deepcopy(pconf)
      end)()

      if pconf.mappings then
        defaults.attach_mappings = function(_, map)
          for mode, tbl in pairs(pconf.mappings) do
            for key, action in pairs(tbl) do
              map(mode, key, action)
            end
          end
          return true
        end
      end

      if pconf.attach_mappings and opts.attach_mappings then
        local opts_attach = opts.attach_mappings
        opts.attach_mappings = function(prompt_bufnr, map)
          pconf.attach_mappings(prompt_bufnr, map)
          return opts_attach(prompt_bufnr, map)
        end
      end

      if defaults.attach_mappings and opts.attach_mappings then
        local opts_attach = opts.attach_mappings
        opts.attach_mappings = function(prompt_bufnr, map)
          defaults.attach_mappings(prompt_bufnr, map)
          return opts_attach(prompt_bufnr, map)
        end
      end

      v(vim.tbl_extend("force", defaults, opts))
    end
  end

  return mod
end

pickers = apply_config(pickers)

return pickers
