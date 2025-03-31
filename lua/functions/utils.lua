local M = {}

function M.recursive_readdir(dir_path, file_list, exclude_list)
  local files = vim.fn.readdir(dir_path)
  for _, file in ipairs(files) do
    local file_path = vim.fn.join({ dir_path, file }, "/")

    if vim.fn.isdirectory(file_path) == 1 then
      local is_excluded = false
      if #exclude_list > 0 then
        for _, exclude_path in ipairs(exclude_list) do
          if exclude_path ~= "" and file_path and vim.fn.match(file_path, exclude_path) ~= -1 then
            is_excluded = true
            break
          end
        end
      end
      if not is_excluded then
        M.recursive_readdir(file_path, file_list, exclude_list)
      end
    elseif vim.fn.filereadable(file_path) == 1 then
      table.insert(file_list, file_path)
    end
  end
end

return M
