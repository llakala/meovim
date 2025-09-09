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
      -- To prevent accidentally closing the current buf, we require a
      -- confirmation. response being 1 means yes
      local response = vim.fn.confirm("Close current buffer?", "&Yes\n&No")
      if response ~= 1 then
        goto continue
      end

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

      -- Normal (ish) mode keybinds. The true normal mode is used in `buffers`
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

  buffers = {
    fzf_opts = {
      ["--header-lines"] = false,
    },

    -- TODO: find a way to start on the second item

    actions = {
      ["ctrl-x"] = {
        reload = true,
        fn = create_scratch_buffer,
      },
    },

    -- Start in normal mode
    keymap = {
      fzf = {
        -- Buffer picker shouldn't start on the current buffer
        load = "pos(2)",

        j = "down",
        k = "up",
        l = "accept",
        f = "jump",

        -- Normal mode is on by default - calling this event will toggle it.
        -- Ideally, we would have some `toggle-input` event, but as we lack
        -- that, we use click-header (if I'm clicking in fzf, I'm doing
        -- something wrong). This lets us toggle modes without having to write
        -- out the keys in every single bind
        ["click-header"] = "toggle-bind(j,k,l,f,i)",

        -- If we're in insert mode, then pressing esc should take us to normal
        -- mode. If we're NOT in insert mode, we must already be in normal mode,
        -- and esc should quit fzf.
        esc = 'transform:[[ "$FZF_INPUT_STATE" = enabled ]] && echo "hide-input+trigger(click-header)" || echo abort',

        -- We have a true normal mode, let's use it!
        start = "hide-input+unbind(alt-j,alt-k,alt-l,alt-f)",

        -- From normal mode, enter insert mode. After doing this, we want to
        -- immediately unmap it so we can actually type `i`. So we trigger
        -- `click-header` and disable all the normal mode keymaps (including
        -- this one).
        i = "show-input+trigger(click-header)",
        u = "down",
      },
    },
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

-- Replace default LSP bindings with telescope equivalents
-- We don't mess with rename and code actions - snacks handles that
nnoremap("grr", FzfLua.lsp_references, { desc = "View usage(s)" })
nnoremap("gri", FzfLua.lsp_definitions, { desc = "View implementation" })
nnoremap("grt", FzfLua.lsp_typedefs, { desc = "View implementation" })
nnoremap("gO", FzfLua.lsp_document_symbols, { desc = "View implementation" })

-- Shows workspace diagnostics, so you can see errors in other files. Great for
-- Gleam dev, since the Gleam LSP gets stuck if one file has errors. Note that
-- this doesn't work for all LSPs!
nnoremap("grd", FzfLua.diagnostics_workspace, { desc = "Workspace diagnostics" })

-- Show normal buffers and helpfiles!
nnoremap("<leader>b", function()
  FzfLua.buffers({
    show_unlisted = true,

    -- Most buffers that aren't listed are bad, but helpfiles are an exception
    filter = function(bufnr)
      local ft = vim.bo[bufnr].filetype
      local buflisted = vim.bo[bufnr].buflisted

      if ft == "help" then
        return true
      else
        return buflisted
      end
    end,
  })
end, { desc = "Swap buffer, including hidden buffers" })

nnoremap("<leader>f", FzfLua.files, { desc = "Add new file in project" })
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

nnoremap("<leader>s", FzfLua.live_grep, { desc = "Search text in project" })
