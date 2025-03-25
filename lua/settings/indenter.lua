local M = {}

-- local function complete_directory(prompt, default)
--   local input = vim.fn.input(prompt, default, 'file')
--   if input == '' then
--     return nil
--   end
--   return input
-- end

function M.indent_dir()
  local current_dir = vim.fn.getcwd()
  -- local input = complete_directory("ディレクトリパスを入力してください:", current_dir)
  vim.ui.input({ prompt = "ディレクトリパスを入力してください:", default = current_dir, completion = 'file' }, function(input)
    if input then
      local job_ids = {}

      local function process_file(filename)
        local job_id = vim.fn.jobstart({"nvim", "--headless", "-c", "silent gg=G | $g/^[[:space:]]*$/d | wq", filename})
        table.insert(job_ids, job_id)
      end

      local function process_directory(directory)
        for _, filename in ipairs(vim.fn.readdir(directory)) do
          local full_path = vim.fn.join({directory, filename}, "/")
          if vim.fn.isdirectory(full_path) == 1 then
            process_file(full_path)
          end
        end
      end

      process_directory(input)

      -- ジョブの完了を待機 (オプション)
      for _, job_id in ipairs(job_ids) do
        vim.fn.jobwait({job_id})
      end

      print("インデント処理が完了しました。")
    else
      print("キャンセルされました。")
    end
  end)
end

return M
