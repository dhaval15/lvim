local db_tables = {}
db_tables.nodes = 'nodes'

local function open_db()
	local sqlite = require('sqlite')
	local db_filename = '/home/dhaval/Hive/Realm/Neuron/neuron.db'
  local db = sqlite:open(db_filename)
  if not db then
    vim.notify('OrgRoam: error in opening DB', vim.log.levels.ERROR)
    return
  end
	return db
end

local function nodes()
	local db = open_db()
	local nodes = db:select(db_tables.nodes)
	return nodes
end


local function create_node()
end

local function goto()
end

local function notes(opts)
	local pickers = require "telescope.pickers"
	local finders = require "telescope.finders"
	local conf = require("telescope.config").values
	local actions = require "telescope.actions"
	local action_state = require "telescope.actions.state"
	local themes = require "telescope.themes"
  opts = opts or themes.get_ivy()
  pickers.new(opts, {
    prompt_title = "colors",
    finder = finders.new_table {
      results = nodes(),
			entry_maker = function(node)
        return {
          value = node,
          display = string.sub(node.title,2, -2),
          ordinal = node.file,
        }
      end,
    },
		attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
				vim.cmd('edit ' .. string.sub(selection.value.file, 2, -2))
      end)
      return true
    end,
    sorter = conf.generic_sorter(opts),
  }):find()
end

local M = {}

M.post = function ()
	local opt = {
		noremap = true,
		silent = true,
	}
	local map = vim.keymap.set
	map('n', '<leader>rf', notes, opt)
end

M.plugins = {
	{
		'kkharji/sqlite.lua',
	},
}

return M
