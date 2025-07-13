return {
  name = "Open Toggleterm in Tab",
  builder = function()
    local nvim_shell, shell_args
    if vim.fn.has('win32') == 1 then
      nvim_shell = 'pwsh'
      shell_args = { '-NoLogo' }
    else
      nvim_shell = vim.o.shell
      shell_args = {}
    end
    return {
      cmd = vim.list_extend({ nvim_shell }, shell_args), -- コマンドと引数を分けて渡す
      components = { "default" },
      strategy = {
        "toggleterm",
        direction = "tab",
        hidden = true, -- タブをリストに表示しない
      },
      -- タスク開始時にタブへ移動
      on_start = function()
        vim.defer_fn(function()
          vim.cmd("tabnext")
        end, 100) -- 100ms 後にタブ移動（即座に移動すると意図しない挙動を防げる）
      end,
    }
  end,
}
