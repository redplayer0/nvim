local M = {}
local api = vim.api

local merge_tb = vim.tbl_deep_extend

M.close_buffer = function(bufnr)
  if vim.bo.buftype == "terminal" then
    vim.cmd(vim.bo.buflisted and "set nobl | enew" or "hide")
  elseif vim.bo.modified then
    print "save the file bruh"
  else
    bufnr = bufnr or api.nvim_get_current_buf()
    require("core.utils").tabuflinePrev()
    vim.cmd("bd" .. bufnr)
  end
end

M.load_mappings = function(mappings, mapping_opt)
  -- set mapping function with/without whichkey
  local set_maps
  local whichkey_exists, wk = pcall(require, "which-key")

  if whichkey_exists then
    set_maps = function(keybind, mapping_info, opts)
      wk.register({ [keybind] = mapping_info }, opts)
    end
  else
    set_maps = function(keybind, mapping_info, opts)
      local mode = opts.mode
      opts.mode = nil
      vim.keymap.set(mode, keybind, mapping_info[1], opts)
    end
  end

  mappings = require("core.mappings")
  -- mappings.lspconfig = nil

  for _, section in pairs(mappings) do
    for mode, mode_values in pairs(section) do
      for keybind, mapping_info in pairs(mode_values) do
        -- merge default + user opts
        local default_opts = merge_tb("force", { mode = mode }, mapping_opt or {})
        local opts = merge_tb("force", default_opts, mapping_info.opts or {})

        if mapping_info.opts then
          mapping_info.opts = nil
        end

        set_maps(keybind, mapping_info, opts)
      end
    end
  end
end

-- merge plugin table
M.merge_plugins = function(plugins)

  local final_table = {}

  for key, _ in pairs(plugins) do
    plugins[key][1] = key
    final_table[#final_table + 1] = plugins[key]
  end

  return final_table
end

-- remove plugins
-- M.remove_default_plugins = function(plugins)
--    local removals = {}
--
--    if not vim.tbl_isempty(removals) then
--       for _, plugin in pairs(removals) do
--          plugins[plugin] = nil
--       end
--    end
--
--    return plugins
-- end

M.bufilter = function()
  local bufs = vim.t.bufs

  for i = #bufs, 1, -1 do
    if not vim.api.nvim_buf_is_valid(bufs[i]) then
      table.remove(bufs, i)
    end
  end

  return bufs
end

M.tabuflineNext = function()
  local bufs = M.bufilter() or {}

  for i, v in ipairs(bufs) do
    if api.nvim_get_current_buf() == v then
      vim.cmd(i == #bufs and "b" .. bufs[1] or "b" .. bufs[i + 1])
      break
    end
  end
end

M.tabuflinePrev = function()
  local bufs = M.bufilter() or {}

  for i, v in ipairs(bufs) do
    if api.nvim_get_current_buf() == v then
      vim.cmd(i == 1 and "b" .. bufs[#bufs] or "b" .. bufs[i - 1])
      break
    end
  end
end

-- closes tab + all of its buffers
M.closeAllBufs = function(action)
  local bufs = vim.t.bufs

  if action == "closeTab" then
    vim.cmd "tabclose"
  end

  for _, buf in ipairs(bufs) do
    M.close_buffer(buf)
  end

  if action ~= "closeTab" then
    vim.cmd "enew"
  end
end

return M
