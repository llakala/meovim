-- Lifted from LazyVim, but removing the custom objects they added. We can add
-- our own as time goes on! Reference links:
-- https://github.com/LazyVim/LazyVim/blob/25abbf546d564dc484cf903804661ba12de45507/lua/lazyvim/plugins/coding.lua#L32
-- and:
-- https://github.com/LazyVim/LazyVim/blob/25abbf546d564dc484cf903804661ba12de45507/lua/lazyvim/util/mini.lua#L23
local function which_key_maps(my_mappings)
  local objects = {
    { " ", desc = "whitespace" },
    { '"', desc = '" string' },
    { "'", desc = "' string" },
    { "(", desc = "() block" },
    { ")", desc = "() block with ws" },
    { "<", desc = "<> block" },
    { ">", desc = "<> block with ws" },
    { "?", desc = "user prompt" },
    { "U", desc = "use/call without dot" },
    { "[", desc = "[] block" },
    { "]", desc = "[] block with ws" },
    { "_", desc = "underscore" },
    { "`", desc = "` string" },
    { "a", desc = "argument" },
    { "b", desc = ")]} block" },
    { "f", desc = "function call" },
    { "i", desc = "indent" },
    { "q", desc = "quote `\"'" },
    { "t", desc = "tag" },
    { "u", desc = "use/call" },
    { "{", desc = "{} block" },
    { "}", desc = "{} with ws" },
  }

  local ret = { mode = { "o", "x" } }

  for name, prefix in pairs(my_mappings) do
    if prefix ~= "" then
      name = name:gsub("^around_", ""):gsub("^inside_", "")
      ret[#ret + 1] = { prefix, group = name }

      for _, obj in ipairs(objects) do
        local desc = obj.desc

        if prefix:sub(1, 1) == "i" then
          desc = desc:gsub(" with ws", "")
        end

        ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
      end
    end
  end
  ret.preset = true

  return ret
end

return {
  "mini.ai",

  after = function()
    local mappings = {
      around = "a",
      inside = "i",
      around_next = "an",
      around_last = "al",
      inside_next = "in",
      inside_last = "il",
      goto_left = "g[",
      goto_right = "g]",
    }

    require("mini.ai").setup({
      mappings = mappings,
    })

    require("which-key").add(which_key_maps(mappings))
  end,
}
