local M = {}

local pickers     = require('telescope.pickers')
local finders     = require('telescope.finders')
local conf        = require('telescope.config').values
local previewers  = require('telescope.previewers')
local actions     = require('telescope.actions')
local action_state = require('telescope.actions.state')

local Terminal = require('toggleterm.terminal').Terminal

local PROJECTS_DIR = vim.fn.expand('~/.claude/projects/')

-- Parse a .jsonl session file into { title, messages[] }
local function parse_session(path)
	local messages = {}
	local title    = nil

	local f = io.open(path, 'r')
	if not f then return nil end

	for line in f:lines() do
		local ok, obj = pcall(vim.fn.json_decode, line)
		if ok and obj and not obj.isMeta then
			local role    = obj.type
			local content = obj.message and obj.message.content

			if role == 'user' or role == 'assistant' then
				local text = ''
				if type(content) == 'string' then
					text = content
				elseif type(content) == 'table' then
					for _, c in ipairs(content) do
						if type(c) == 'table' and c.type == 'text' then
							text = c.text
							break
						end
					end
				end

				text = text:gsub('<[^>]+>', ''):gsub('%s+', ' '):match('^%s*(.-)%s*$')
				if text and text ~= '' then
					if not title and role == 'user' then
						title = text:sub(1, 80)
					end
					table.insert(messages, { role = role, text = text })
				end
			end
		end
	end
	f:close()

	return { title = title or '(empty)', messages = messages }
end

-- Collect all sessions across all projects
local function get_sessions()
	local sessions = {}

	local projects = vim.fn.glob(PROJECTS_DIR .. '*', false, true)
	for _, project_dir in ipairs(projects) do
		if vim.fn.isdirectory(project_dir) == 1 then
			local project_name = vim.fn.fnamemodify(project_dir, ':t')
				:gsub('^%-', '')
				:gsub('%-', '/')

			local files = vim.fn.glob(project_dir .. '/*.jsonl', false, true)
			for _, file in ipairs(files) do
				local session_id = vim.fn.fnamemodify(file, ':t:r')
				local stat       = vim.loop.fs_stat(file)
				local mtime      = stat and stat.mtime.sec or 0
				local parsed     = parse_session(file)

				if parsed and #parsed.messages > 0 then
					table.insert(sessions, {
						session_id   = session_id,
						project      = project_name,
						title        = parsed.title,
						messages     = parsed.messages,
						mtime        = mtime,
						display      = string.format('%-40s  %s', parsed.title:sub(1,40), project_name),
					})
				end
			end
		end
	end

	table.sort(sessions, function(a, b) return a.mtime > b.mtime end)
	return sessions
end

-- Build preview lines from messages
local function build_preview(session)
	local lines = {}
	table.insert(lines, '  Session: ' .. session.session_id)
	table.insert(lines, '  Project: ' .. session.project)
	table.insert(lines, string.rep('─', 60))
	table.insert(lines, '')

	for _, msg in ipairs(session.messages) do
		if msg.role == 'user' then
			table.insert(lines, '▶ You')
		else
			table.insert(lines, '◀ Claude')
		end
		-- Word-wrap at 60 chars
		local text = msg.text
		while #text > 60 do
			local chunk = text:sub(1, 60)
			local break_at = chunk:match('.*()%s') or 60
			table.insert(lines, '  ' .. text:sub(1, break_at))
			text = text:sub(break_at + 1)
		end
		if text ~= '' then table.insert(lines, '  ' .. text) end
		table.insert(lines, '')
	end

	return lines
end

-- Open a session in a fullscreen toggleterm float
local function open_session(session_id)
	local term = Terminal:new({
		cmd       = 'claude --resume ' .. session_id,
		direction = 'float',
		float_opts = {
			border = 'curved',
			width  = vim.o.columns,
			height = vim.o.lines - 2,
			row    = 0,
			col    = 0,
		},
		hidden = false,
	})
	term:toggle()
end

function M.pick()
	local sessions = get_sessions()
	if #sessions == 0 then
		vim.notify('No Claude sessions found', vim.log.levels.WARN)
		return
	end

	pickers.new({}, {
		prompt_title  = 'Claude Sessions',
		results_title = 'Sessions (newest first)',
		preview_title = 'Conversation',

		finder = finders.new_table({
			results = sessions,
			entry_maker = function(session)
				return {
					value   = session,
					display = session.display,
					ordinal = session.title .. ' ' .. session.project,
				}
			end,
		}),

		sorter = conf.generic_sorter({}),

		previewer = previewers.new_buffer_previewer({
			title = 'Conversation',
			define_preview = function(self, entry)
				local lines = build_preview(entry.value)
				vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
				vim.api.nvim_buf_set_option(self.state.bufnr, 'filetype', 'markdown')
			end,
		}),

		attach_mappings = function(prompt_bufnr, _)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local entry = action_state.get_selected_entry()
				if entry then
					open_session(entry.value.session_id)
				end
			end)
			return true
		end,
	}):find()
end

return M
