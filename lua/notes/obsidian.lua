local M = {}

local VAULTS_ROOT = vim.fn.expand('~/Hive/obsidian')

-- Vault-specific type options
local VAULT_TYPES = {
	work     = { 'meeting', 'project', 'task' },
	personal = { 'journal', 'idea', 'task' },
	writing  = { 'idea', 'short-story', 'chapter', 'article', 'draft' },
}

-- Convert a title to a slug: lowercase, spaces → hyphens, strip special chars
local function slugify(title)
	return title:lower()
		:gsub('%s+', '-')
		:gsub('[^a-z0-9%-]', '')
		:gsub('%-+', '-')
		:gsub('^%-', '')
		:gsub('%-$', '')
end

-- Month names for daily note formatting
local MONTHS = {
	'January','February','March','April','May','June',
	'July','August','September','October','November','December'
}

-- Parse YYYY-MM-DD filename into "April 11 2026"
local function format_daily_date(filename)
	local y, m, d = filename:match('^(%d%d%d%d)-(%d%d)-(%d%d)$')
	if y then
		return MONTHS[tonumber(m)] .. ' ' .. tostring(tonumber(d)) .. ' ' .. y
	end
	return filename
end

-- Check if filename is a daily note (YYYY-MM-DD.md)
local function is_daily(filename)
	return filename:match('^%d%d%d%d%-%d%d%-%d%d$') ~= nil
end

-- Parse frontmatter from a file, return { title, tags, status }
local function parse_frontmatter(filepath)
	local result = { title = nil, tags = {}, status = nil }
	local f = io.open(filepath, 'r')
	if not f then return result end

	local in_frontmatter = false
	local in_tags_block  = false
	local line_count     = 0

	for line in f:lines() do
		line_count = line_count + 1
		if line_count == 1 and line == '---' then
			in_frontmatter = true
		elseif in_frontmatter and line == '---' then
			break
		elseif in_frontmatter then
			-- block list item under tags:
			if in_tags_block then
				local item = line:match('^%s*-%s+(.+)$')
				if item then
					table.insert(result.tags, item)
					goto continue
				else
					in_tags_block = false
				end
			end

			local key, val = line:match('^(%w+):%s*(.*)$')
			if key == 'title' then
				result.title = val
			elseif key == 'status' then
				result.status = val
			elseif key == 'tags' then
				if val == '' or val == nil then
					-- block sequence follows
					in_tags_block = true
				else
					-- inline array: [tag1, tag2]
					for tag in val:gmatch('[%w%-]+') do
						if tag ~= '' then table.insert(result.tags, tag) end
					end
				end
			end
		end
		::continue::
		if line_count > 30 then break end
	end
	f:close()
	return result
end

-- Build display parts: title string + list of { text, hl_group } for right side
local function build_display_parts(filepath, fname)
	local stem = fname:gsub('%.md$', '')

	if is_daily(stem) then
		return format_daily_date(stem), { { ':daily:', 'Comment' } }
	end

	local fm = parse_frontmatter(filepath)
	local title = fm.title or stem
	local meta = {}

	for _, tag in ipairs(fm.tags) do
		table.insert(meta, { '#' .. tag, 'Special' })
	end

	if fm.status then
		table.insert(meta, { ':' .. fm.status .. ':', 'Comment' })
	end

	return title, meta
end

-- Get the current vault path from obsidian client
local function current_vault_path()
	local ok, obs = pcall(require, 'obsidian')
	if ok and obs then
		local ok2, client = pcall(obs.get_client)
		if ok2 and client then
			return tostring(client.current_workspace.path)
		end
	end
	return VAULTS_ROOT .. '/personal'
end

-- Get the current vault name
local function current_vault_name()
	local ok, obs = pcall(require, 'obsidian')
	if ok and obs then
		local ok2, client = pcall(obs.get_client)
		if ok2 and client then
			return client.current_workspace.name
		end
	end
	return 'personal'
end

-- Custom Telescope picker for current vault
local function vault_picker()
	local vault_path = current_vault_path()
	local vault_name = current_vault_name()
	local files = vim.fn.glob(vault_path .. '/**/*.md', false, true)

	if #files == 0 then
		vim.notify('No notes found in vault: ' .. vault_name, vim.log.levels.INFO)
		return
	end

	local entries = {}
	for _, filepath in ipairs(files) do
		local fname  = vim.fn.fnamemodify(filepath, ':t')
		local title, meta = build_display_parts(filepath, fname)
		table.insert(entries, {
			filepath = filepath,
			title    = title,
			meta     = meta,
			ordinal  = title,
		})
	end

	local pickers      = require('telescope.pickers')
	local finders      = require('telescope.finders')
	local conf         = require('telescope.config').values
	local actions      = require('telescope.actions')
	local action_state = require('telescope.actions.state')
	local previewers   = require('telescope.previewers')

	pickers.new({}, {
		prompt_title  = 'Notes — ' .. vault_name,
		finder = finders.new_table({
			results = entries,
			entry_maker = function(e)
				return {
					value   = e.filepath,
					ordinal = e.title,
					title   = e.title,
					meta    = e.meta,
					display = function(entry)
						local title = entry.title or ''
						local meta  = entry.meta or {}
						if #meta == 0 then return title, {} end

						-- build right-side string and track segment positions
						local meta_str = ''
						local segments = {}
						for i, m in ipairs(meta) do
							if i > 1 then meta_str = meta_str .. '  ' end
							local s = #meta_str
							meta_str = meta_str .. m[1]
							table.insert(segments, { s, #meta_str, m[2] })
						end

						-- right-align within picker window
						local win_width = vim.api.nvim_win_get_width(0) - 6
						local padding   = win_width - #title - #meta_str
						if padding < 2 then padding = 2 end

						local full   = title .. string.rep(' ', padding) .. meta_str
						local offset = #title + padding
						local hls    = {}
						for _, seg in ipairs(segments) do
							table.insert(hls, { { offset + seg[1], offset + seg[2] }, seg[3] })
						end
						return full, hls
					end,
				}
			end,
		}),
		sorter    = conf.generic_sorter({}),
		previewer = conf.file_previewer({}),
		attach_mappings = function(prompt_bufnr, _)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local entry = action_state.get_selected_entry()
				if entry then vim.cmd('edit ' .. vim.fn.fnameescape(entry.value)) end
			end)
			return true
		end,
	}):find()
end

-- Auto-discover all vaults under ~/Hive/obsidian/
local function discover_workspaces()
	local workspaces = {}
	local dirs = vim.fn.glob(VAULTS_ROOT .. '/*', false, true)
	for _, dir in ipairs(dirs) do
		if vim.fn.isdirectory(dir) == 1 then
			local name = vim.fn.fnamemodify(dir, ':t')
			table.insert(workspaces, { name = name, path = dir })
		end
	end
	if #workspaces == 0 then
		table.insert(workspaces, { name = 'main', path = VAULTS_ROOT })
	end
	return workspaces
end

-- Check if slug exists in current vault
local function slug_exists(vault_path, slug)
	return vim.fn.filereadable(vault_path .. '/' .. slug .. '.md') == 1
end

-- Build frontmatter for a vault
local function build_frontmatter(title, note_type, vault_name)
	local date = os.date('%Y-%m-%d')
	local lines = {
		'---',
		'title: ' .. title,
		'date: ' .. date,
		'tags: []',
		'status: draft',
	}
	if note_type then
		table.insert(lines, 'type: ' .. note_type)
	end
	table.insert(lines, '---')
	table.insert(lines, '')
	table.insert(lines, '# ' .. title)
	table.insert(lines, '')
	return lines
end

-- Prompt for note type based on vault
local function prompt_note_type(vault_name, callback)
	local types = VAULT_TYPES[vault_name]
	if not types then
		callback(nil)
		return
	end

	local pickers    = require('telescope.pickers')
	local finders    = require('telescope.finders')
	local conf       = require('telescope.config').values
	local actions    = require('telescope.actions')
	local action_state = require('telescope.actions.state')

	pickers.new({}, {
		prompt_title = 'Note Type (' .. vault_name .. ')',
		finder = finders.new_table({
			results = types,
			entry_maker = function(t)
				return { value = t, display = t, ordinal = t }
			end,
		}),
		sorter = conf.generic_sorter({}),
		attach_mappings = function(prompt_bufnr, _)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local entry = action_state.get_selected_entry()
				callback(entry and entry.value or nil)
			end)
			return true
		end,
	}):find()
end

-- Create a new note with full convention
local function new_note()
	-- Step 1: prompt for title
	vim.ui.input({ prompt = 'Note title: ' }, function(title)
		if not title or title == '' then return end

		local slug       = slugify(title)
		local vault_path = current_vault_path()
		local vault_name = current_vault_name()

		-- Step 2: check for duplicate, warn if exists
		if slug_exists(vault_path, slug) then
			vim.ui.input({
				prompt = '⚠️  "' .. slug .. '.md" already exists. Use anyway? (y/n): ',
			}, function(answer)
				if answer ~= 'y' then
					vim.notify('Note creation cancelled.', vim.log.levels.INFO)
					return
				end
				prompt_note_type(vault_name, function(note_type)
					create_note_file(vault_path, slug, title, note_type, vault_name)
				end)
			end)
		else
			-- Step 3: pick note type
			prompt_note_type(vault_name, function(note_type)
				create_note_file(vault_path, slug, title, note_type, vault_name)
			end)
		end
	end)
end

-- Write the file and open it
function create_note_file(vault_path, slug, title, note_type, vault_name)
	local filepath = vault_path .. '/' .. slug .. '.md'
	local lines    = build_frontmatter(title, note_type, vault_name)

	local f = io.open(filepath, 'w')
	if not f then
		vim.notify('Failed to create note: ' .. filepath, vim.log.levels.ERROR)
		return
	end
	f:write(table.concat(lines, '\n'))
	f:close()

	vim.cmd('edit ' .. vim.fn.fnameescape(filepath))
	-- Place cursor after frontmatter (deferred so buffer is fully loaded)
	vim.schedule(function()
		local count = vim.api.nvim_buf_line_count(0)
		vim.api.nvim_win_set_cursor(0, { math.min(#lines, count), 0 })
	end)
end

M.plugins = {
	{
		'epwalsh/obsidian.nvim',
		version = '*',
		lazy = true,
		ft = 'markdown',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			require('obsidian').setup({
				workspaces = discover_workspaces(),
				-- Disable built-in new_notes_location so we handle it ourselves
				new_notes_location = 'current_dir',
				-- Daily note: YYYY-MM-DD.md, minimal frontmatter
				daily_notes = {
					folder    = 'daily',
					date_format = '%Y-%m-%d',
					template  = nil,
				},
				completion = {
					nvim_cmp = true,
					min_chars = 2,
				},
				note_id_func = function(title)
					return slugify(title or 'untitled')
				end,
				note_frontmatter_func = function(note)
					local out = {
						title  = note.title or note.id,
						date   = os.date('%Y-%m-%d'),
						tags   = note.tags or {},
						status = 'draft',
					}
					if note.metadata and note.metadata.type then
						out.type = note.metadata.type
					end
					return out
				end,
				mappings = {
					['gd'] = {
						action = function() return require('obsidian').util.gf_passthrough() end,
						opts = { noremap = false, expr = true, buffer = true },
					},
					['<cr>'] = {
						action = function() return require('obsidian').util.smart_action() end,
						opts = { buffer = true, expr = true },
					},
				},
				ui = { enable = false },
				follow_url_func = function(url)
					vim.fn.jobstart({ 'open', url })
				end,
			})

			local opt = { noremap = true, silent = true }
			vim.keymap.set('n', '<leader>on', new_note,       opt)
			vim.keymap.set('n', '<leader>oo', vault_picker,   opt)
			vim.keymap.set('n', '<leader>os', '<cmd>ObsidianSearch<CR>',         opt)
			vim.keymap.set('n', '<leader>ob', '<cmd>ObsidianBacklinks<CR>',      opt)
			vim.keymap.set('n', '<leader>ot', '<cmd>ObsidianTags<CR>',           opt)
			vim.keymap.set('n', '<leader>od', '<cmd>ObsidianToday<CR>',          opt)
			vim.keymap.set('n', '<leader>ow', '<cmd>ObsidianWorkspace<CR>',      opt)
		end,
	},
}

-- :ObsidianVault — Telescope picker to switch vaults
M.post = function()
	vim.api.nvim_create_user_command('ObsidianVault', function()
		local workspaces = discover_workspaces()
		if #workspaces == 0 then
			vim.notify('No vaults found under ' .. VAULTS_ROOT, vim.log.levels.WARN)
			return
		end

		local pickers      = require('telescope.pickers')
		local finders      = require('telescope.finders')
		local conf         = require('telescope.config').values
		local actions      = require('telescope.actions')
		local action_state = require('telescope.actions.state')

		pickers.new({}, {
			prompt_title = 'Obsidian Vaults',
			finder = finders.new_table({
				results = workspaces,
				entry_maker = function(ws)
					return { value = ws, display = ws.name, ordinal = ws.name }
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local entry = action_state.get_selected_entry()
					if entry then
						require('obsidian').get_client():switch_workspace(entry.value.name)
						vim.notify('Switched to vault: ' .. entry.value.name)
					end
				end)
				return true
			end,
		}):find()
	end, {})
end

return M
