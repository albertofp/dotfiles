vim.cmd [[
  command! -nargs=1 UpdateImageTag execute '%s/\(image:\s\+\S\+:\)\S\+/\1' . escape(<q-args>, '/') . '/g'
]]

-- Function to search the Terraform Registry
local function search_terraform_registry(query)
  if query == nil or query == '' then
    print("Error: No search query provided.")
    return
  end

  -- Construct the search query for DuckDuckGo's "I'm Feeling Lucky"
  local search_term = "terraform registry " .. query .. " !" -- Append " !" for lucky search

  -- URL encode the query
  local encoded_query = vim.uri_encode(search_term) -- Use vim.uri_encode for proper URL encoding
  local url = "https://duckduckgo.com/?q=" .. encoded_query

  -- Determine the command to open the URL based on the OS
  local open_cmd
  if vim.fn.has('macunix') then
    open_cmd = "open"
  elseif vim.fn.has('unix') then
    -- Try xdg-open first, fallback to open if it exists (e.g., WSL)
    if vim.fn.executable("xdg-open") == 1 then
      open_cmd = "xdg-open"
    elseif vim.fn.executable("open") == 1 then
      open_cmd = "open"
    else
      print("Error: Could not find 'xdg-open' or 'open' command to open URL.")
      return
    end
  elseif vim.fn.has('win32') or vim.fn.has('win64') then
    open_cmd = "start"
  else
    print("Error: Unsupported operating system.")
    return
  end

  -- Construct the full command string, ensuring proper quoting for the URL
  local cmd_string = open_cmd .. " '" .. url .. "'"

  -- Execute the command asynchronously
  print("Opening: " .. url)
  vim.fn.jobstart(cmd_string, { detach = true })
end

-- Create the user command :SearchTerraformRegistry
vim.api.nvim_create_user_command(
  'SearchTerraformRegistry',
  function(opts)
    search_terraform_registry(opts.args)
  end,
  {
    nargs = 1,         -- Expect exactly one argument
    complete = 'file', -- Basic completion, can be customized if needed
    desc = 'Search DuckDuckGo for "terraform registry <query>" and go to first result'
  }
)
