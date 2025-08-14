vim.env.FZF_DEFAULT_OPTS = nil

require("fzf-lua").setup({
  -- Set up basic vim bindings.
  keymap = {
    fzf = {
      true, -- Inherit from default fzf keybinds
      jump = "accept",

      -- Normal mode keybinds
      j = "down",
      k = "up",
      o = "accept",
      f = "jump",

      -- We want to start out in insert mode, but we just created all the normal
      -- mode binds. So we toggle all of them off at startup. The only custom
      -- bind that ISN'T toggled is escape.
      --
      -- We also trigger this event elsewhere, where it serves as a "mode
      -- toggle". This lets us avoid listing all our keymaps whenever we want to
      -- change modes.
      start = "toggle-bind(j,k,o,f,i)",

      -- If we're in insert mode, then pressing esc should take us to normal
      -- mode. If we're NOT in insert mode, we must already be in normal mode,
      -- and esc should quit fzf.
      esc = 'transform:[[ "$FZF_INPUT_STATE" = enabled ]] && echo "hide-input+trigger(start)" || echo abort',

      -- From normal mode, enter insert mode. This key will only do anything if
      -- we've entered normal mode and enabled it. So, we trigger start AGAIN,
      -- disabling all the normal mode keymaps (including this one).
      i = "show-input+trigger(start)",
    },
  },

  -- Buffer picker starts in normal mode
  buffers = {
    keymap = {
      fzf = {
        -- I want an event I can call, so I don't have to keep listing the
        -- normal binds, and can just call the event. However, since I don't
        -- start in insert mode, I can't use `start` this time. Instead, we use
        -- click-header - if I'm clicking in fzf, I'm doing something wrong.
        ["click-header"] = "toggle-bind(j,k,o,f,i)",

        start = "hide-input",
        i = "show-input+trigger(click-header)",
        esc = 'transform:[[ "$FZF_INPUT_STATE" = enabled ]] && echo "hide-input+trigger(click-header)" || echo abort',
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
