vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.cmd [[ startinsert ]]
  end,
})

vim.cmd [[
command! -nargs=* T split | wincmd j | resize 10 | terminal <args>
]]
