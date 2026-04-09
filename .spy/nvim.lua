require('telescope').setup {
	pickers = {
		find_files = {
			theme = 'ivy',
			file_ignore_patterns = {
				--'org-roam-ui/node_modules',
				'env',
			},
		},
	}
}
