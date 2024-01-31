-- capture.lua
local M = {}

-- local parsers = require("nvim-treesitter.parsers")
--
-- local note_language_id = 42  -- You can choose any unique number
--
-- -- Register the language and its parser
-- parsers.set_language(note_language_id, 'note', 'path/to/note_parser.so')
--
-- -- Get the parser for the 'note' language
-- local note_parser = parsers.get_parser(note_language_id)
--
-- note_parser:define_rule("metadata", "([%a_][%w_]*)%s*:%s*([%w_]+)")
-- note_parser:define_rule("content", "===\n(.*)")
--
-- require('nvim-treesitter.parsers').get_parser_configs().note = {
--   install_info = {
--     url = '', -- Leave this empty since we're using a custom parser
--   },
--   filetype = 'note',
--   used_by = { 'note' }, -- Define which other filetypes use this parser
--   maintainers = { 'Dhaval Patel' }, -- Add your name as a maintainer
--   parser = note_parser, -- Use the note_parser you defined
-- }

local directory = '/home/dhaval/captures'
-- Define functions for capturing notes and searching through notes
function M.capture_note()
    -- Prompt the user for title and tags in the command bar
    local title = vim.fn.input('Note Title: ')
    local tags = vim.fn.input('Tags (space-separated): ')

    -- Generate a unique ID
    local id = vim.fn.system('uuidgen')
    id = string.gsub(id, "\n", "")  -- Remove newline character if present

    -- Generate the note filename
    local title_slug = string.gsub(title, "%s+", "-")  -- Replace spaces with hyphens
    local timestamp = os.date('%Y%m%d%H%M%S')
    local note_filename = string.format('%s/%s-%s.note', directory, timestamp, title_slug)

    -- Create the note file with headers
    local note_content = string.format("id: %s\ntitle: %s\ntags: %s\n===\n", id, title, tags)

    -- Open the note in a new buffer
    vim.api.nvim_create_buf(false, true)  -- Create a new buffer
    --vim.api.nvim_buf_set_name(0, note_filename)  -- Set buffer name
    vim.api.nvim_command('e ' .. note_filename)  -- Open the buffer in a new window
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.fn.split(note_content, '\n'))  -- Set note content
end

-- Import necessary Telescope modules
local actions = require('telescope.actions')
local previewers = require('telescope.previewers')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values

-- Function to format note entries for display
local function format_note_entry(note)
  -- Extract title, tags, and content from the note
  local title = note.title
  local tags = note.tags
  local content = note.content or ''

  -- Format tags with highlighting
  local formatted_tags = ":"
  for _, tag in ipairs(tags) do
    formatted_tags = formatted_tags .. tag .. ":"
  end

  return {
    value = title,
    ordinal = title .. " " .. formatted_tags,
    display = title .. " " .. formatted_tags,
    content = content,
    tag_highlight = "TelescopeResultsTag",  -- Customize tag highlight group
  }
end

-- Function to create Telescope picker for notes

local function read_notes()
  local note_entries = {}

  -- Iterate through note files in the directory
  for _, filename in ipairs(vim.fn.readdir(directory)) do
    if vim.fn.isdirectory(directory .. '/' .. filename) == 0 then
      local file_path = directory .. '/' .. filename
      local file_content = table.concat(vim.fn.readfile(file_path), '\n')
      
      -- Assuming you have a parse_note function in your Note model
      local note = parse_note(file_content)
      if note then
        table.insert(note_entries, note)
      end
    end
  end
	return note_entries
end

-- Search notes
local function search_notes()
  local note_entries = read_notes()
  pickers.new({}, {
    prompt_title = 'Search Notes',
    finder = finders.new_table {
      results = note_entries,
      entry_maker = function(note)
        return format_note_entry(note)
      end,
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(_, map)
      -- Open selected note in a new buffer when pressing Enter
      map('i', '<CR>', function(prompt_bufnr)
    --     local entry = actions.get_selected_entry(prompt_bufnr)
				-- print(entry)
        -- actions.close(prompt_bufnr)
        -- vim.fn.nvim_buf_set_lines(0, 0, -1, false, vim.fn.split(entry.content, '\n'))
        -- vim.api.nvim_buf_set_name(0, entry.value)
      end)

      return true
    end,
    previewer = previewers.new_termopen_previewer {
      get_command = function(entry)
        return {"echo", "-e", entry.content}
      end,
    },
  }):find()
end

-- Function to parse a note from its content
function parse_note(content)
    local id = content:match("id:%s*(.-)\n")
    local title = content:match("title:%s*(.-)\n")
    local tags = content:match("tags:%s*(.-)\n")
    local note_content = content:match("===\n(.+)$")

    if id and title and tags then -- and note_content then
        -- Split tags into a table
        local tag_table = {}
        for tag in string.gmatch(tags, "%S+") do
            table.insert(tag_table, tag)
        end

        -- Create a new Note object
        local note = {
            id = id,
            title = title,
            tags = tag_table,
            content = note_content
        }

        return note
    else
        -- Return nil if any required field is missing
        return nil
    end
end


-- Keybindings
local opt = {
    noremap = true,
    silent = true,
}
local map = vim.keymap.set
-- Files
map('n', '<leader>cc', M.capture_note, opt)
map('n', '<leader>cf', search_notes, opt)

M.read_notes = read_notes
return M
