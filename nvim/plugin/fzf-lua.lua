vim.env.FZF_DEFAULT_OPTS = nil
local utils = require("fzf-lua.utils")
local path = require("fzf-lua.path")

-- Custom action to create a scratch buffer if we close the current buffer
local function create_scratch_buffer(selected, opts)
  for _, sel in ipairs(selected) do
    local entry = path.entry_to_file(sel, opts)
    local bufnr = entry.bufnr

    local is_dirty = utils.buffer_is_dirty(bufnr, true, false)

    -- If file isn't loaded. Not sure why this is needed, but it's from
    -- the original!
    if not bufnr then
      goto continue
    end

    -- If the current file has unsaved changes, prompt the user to save
    if is_dirty then
      local save_dialog = function()
        return utils.save_dialog(bufnr)
      end
      if not vim.api.nvim_buf_call(bufnr, save_dialog) then
        goto continue
      end
    end

    -- The current buffer is actually the picker - so the alt buffer lets
    -- us see the file we're currently editing
    local current_buf = vim.fn.bufnr("#")

    if bufnr == current_buf then
      -- replace current buf with scratch buf in all windows
      local windows = vim.fn.win_findbuf(current_buf)

      local new_buf = vim.api.nvim_create_buf(false, true)
      for _, win in ipairs(windows) do
        vim.api.nvim_win_set_buf(win, new_buf)
      end
    end

    vim.api.nvim_buf_delete(bufnr, { force = true })
    ::continue::
  end
end

require("fzf-lua").setup({
  previewers = {
    builtin = {
      -- This breaks tex files, due to an error with `standalone.cls`! I hate
      -- snacks more and more, folke loves abandonware
      snacks_image = { enabled = false },
    },
  },

  -- Set up basic vim bindings.
  keymap = {
    fzf = {
      true, -- Inherit from default fzf keybinds
      jump = "accept",

      -- Normal (ish) mode keybinds.
      ["ctrl-j"] = "down",
      ["ctrl-k"] = "up",
      ["ctrl-l"] = "accept",
      ["ctrl-f"] = "jump",
    },
    builtin = {
      true,
      ["<A-j>"] = "preview-down",
      ["<A-k>"] = "preview-up",
      ["<C-Space>"] = "toggle-preview",
    },
  },

  -- Autoselect current document symbol in `:FzfLua lsp_document_symbols` (bound
  -- to gO by default)
  lsp = {
    symbols = {
      locate = true,
    },
  },

  buffers = {
    fzf_opts = {
      ["--header-lines"] = false,
    },

    actions = {
      ["ctrl-x"] = {
        reload = true,
        fn = create_scratch_buffer,
      },
    },

    keymap = {
      fzf = {
        -- Buffer picker shouldn't start on the current buffer
        load = "pos(2)",
      },
    },

    -- We want to show helpfiles, but they're unlisted - so we allow all
    -- unlisted buffers, but filter them for only helpfiles
    show_unlisted = true,
    filter = function(bufnr)
      local ft = vim.bo[bufnr].filetype
      local is_listed = vim.bo[bufnr].buflisted

      if ft == "help" then
        return true
      else
        return is_listed
      end
    end,
  },

  -- Automatically create an fzf colorscheme based on our nvim colorscheme
  fzf_colors = true,

  winopts = {
    row = 0.50,
    preview = {
      layout = "vertical",
      vertical = "up:45%",
    },
  },
})

FzfLua.register_ui_select()

-- Replace default LSP bindings with fzf-lua equivalents We don't mess with
-- rename and code actions - just actions that use a picker
nnoremap("grr", FzfLua.lsp_references)
nnoremap("gri", FzfLua.lsp_definitions)
nnoremap("grt", FzfLua.lsp_typedefs)
nnoremap("gO", FzfLua.lsp_document_symbols)

-- Not a default bind, but good for some LSPs like gleam, where you want to see
-- diagnostics in other files
nnoremap("grd", FzfLua.diagnostics_workspace)

nnoremap("<leader>b", FzfLua.buffers, { desc = "Swap buffer, including hidden buffers" })
nnoremap("<leader>f", FzfLua.files, { desc = "Add new file in project" })
nnoremap("<leader>s", FzfLua.live_grep, { desc = "Search text in project" })

nnoremap(
  "<leader>l", -- l for local! doesn't hurt that it's easy to reach
  function()
    -- %:h gives us the folderpath of the current file. The filepath will look
    -- like `foo/bar` if it's within the nvim cwd, and like `/bar/baz` if it's
    -- from root. We make a boolean to allow separate logic dependent on this
    local current_dir = vim.fn.expand("%:h") .. "/"
    local is_within_project = current_dir:sub(1, 1) ~= "/"
    local opts = {}

    -- If it's within the project, we can set the query directly through fzf.
    -- This allows us to backspace the query directly. If it's a root path,
    -- doing it through fzf would be too slow, so we set the cwd through
    -- fzf-lua. No more backspacing, but at least we get decent speed.
    if is_within_project then
      opts.fzf_opts = {
        ["--query"] = current_dir,
      }
    else
      opts.cwd = current_dir
    end

    FzfLua.files(opts)
  end,
  { desc = "Add new file in current folder" }
)
