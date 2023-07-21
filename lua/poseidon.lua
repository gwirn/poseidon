
-- split string with separator
local function split_string (inputstr, sep)
  if sep == nil then
          sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
          table.insert(t, str)
  end
  return t
end

-- find current mapping of a specific left hand side
local find_mapping = function (maps, lhs)
    for _, value in ipairs(maps) do
        if value.lhs == lhs then
            return value
        end
    end
end

-- reset mapping to previous mapping when buffer is closed
local reset_mapping =  function (prev_map)
    if prev_map then
      if prev_map.rhs then
        vim.api.nvim_set_keymap('n', prev_map.lhs, prev_map.rhs,{})
      else
        vim.api.nvim_del_keymap('n', prev_map.lhs)
      end
    end
end


local M = {}
M.buffer_nav = function (full_set)
  local buf, win
  buf = vim.api.nvim_create_buf(false, true)
  local bufs = vim.api.nvim_list_bufs()
  -- get current file name and ending
  local filename = vim.fn.expand('%')
  local split_name = split_string(filename, ".")
  split_name = split_name[#split_name]
  -- store buffer indices and their names
  local buf_nums = {}
  local buf_names = {}
  -- iterate over all buffers and store either the same file buffer names and indices of all
  for _, b in pairs(bufs) do
    if vim.fn.buflisted(b) then
      local buffer_name = vim.fn.bufname(b)
      local split_bufname = split_string(buffer_name, ".")
      local file_ending = split_bufname[#split_bufname]
      if buffer_name:len() > 0 then
        if full_set then
            table.insert(buf_nums, b)
            table.insert(buf_names, string.format("%-3d %s", b, buffer_name))
        else
          if split_name == file_ending then
            table.insert(buf_nums, b)
            table.insert(buf_names, string.format("%-3d %s", b, buffer_name))
          end
        end
      end
    end
  end

  -- write to buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, buf_names)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

  -- generate new floating window
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")

  local win_height = math.ceil(height * 0.2)
  local win_width = math.ceil(width * 0.4)

  local row = math.ceil((height - win_height) / 2 - 1)
  local col = math.ceil((width - win_width) / 2)

  local opts = {
    style = "minimal",
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    border = "rounded",
    title = "Poseidon",
    title_pos = "center"
  }

  win = vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_win_set_option(win, "cursorline", true)

  -- change the mapping only for the floating window buffer and reset it afterwards
  local change_mapping = function (lhs, rhs, com, prev_map)
    vim.keymap.set('n', lhs, function ()
        local ind = vim.fn.line(".")
        if ind == nil then
          ind = 1
        end
        if tonumber(win) then
          vim.api.nvim_win_close(win, true)
          if com  == 0 then
            -- return to current buffer if no buffer is available
            if buf_nums[ind] == nil then
              buf_nums[ind] = 1
            end
            vim.api.nvim_command(string.format(rhs, buf_nums[ind]))
          end
        end
        win = nil
        buf = nil
        -- change mapping back to what it was
        reset_mapping(prev_map)
    end)
  end
  -- change mappings in the buffer window
  local maps = vim.api.nvim_get_keymap("n")
  local accept_map = find_mapping(maps, "<CR>")
  local del_map = find_mapping(maps, "D<CR>")
  local esc_map = find_mapping(maps, "<ESC>")
  change_mapping('<CR>', ':b %d', 0, accept_map)
  change_mapping('D<CR>', ':bw %d', 0, del_map)
  change_mapping('<ESC>', nil, 1, esc_map)
end

return M

