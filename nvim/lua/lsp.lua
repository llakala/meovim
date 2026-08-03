vim.keymap.del("n", "grn")
-- This is just ascii stuff by default - useless to me!
vim.keymap.del({ "n", "x" }, "gra")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local args = { buf = event.buf }
    vim.lsp.inlay_hint.enable(true)

    vim.diagnostic.config({
      virtual_text = false, -- Have this through a plugin
      severity_sort = true,
      signs = false,
      float = {
        border = "rounded",
      },
    })

    -- Replace mode is stupid, and nobody sane would ever use it. If neovim can
    -- change K, I can change R.
    vim.keymap.set("n", "R", function()
      vim.g.input_normal_mode = true
      vim.lsp.buf.rename()
    end, args)

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, args)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, args)
    vim.keymap.set("n", "grd", vim.diagnostic.setloclist, args)
    vim.keymap.set("n", "grD", vim.diagnostic.setqflist, args)

    vim.keymap.set({ "n", "x" }, "ga", vim.lsp.buf.code_action, args)
  end,
})
