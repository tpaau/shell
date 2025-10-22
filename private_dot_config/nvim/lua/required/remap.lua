-- set the leader key to space
vim.g.mapleader = " "

local opts = { noremap = true, silent = true }

-- open telescope-nvim
vim.api.nvim_set_keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)

-- toggle folding
vim.api.nvim_set_keymap("n", "zc", "za", opts)

-- toggle colorcolumn
vim.keymap.set("n", "<leader>h", "<cmd>ToggleNeoColumn<cr>", opts)

-- open file explorer
vim.api.nvim_set_keymap("n", "<leader>vv", "<cmd>Ex<CR>", opts)

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set(
    "n",
    "<leader>a",
    function()
        vim.cmd.RustLsp("codeAction")
    end,
    opts
)
vim.keymap.set(
	"n",
	"<leader>e",
	function()
		vim.cmd.RustLsp("explainError")
	end,
	opts
)
vim.keymap.set(
	"n",
	"F",
	function()
		vim.cmd.RustLsp({"renderDiagnostic", "cycle"})
	end,
	opts
)

-- Jumping one word left or right in normal and visual modes
vim.api.nvim_set_keymap("n", "H", "b", opts)
vim.api.nvim_set_keymap("n", "L", "w", opts)
vim.api.nvim_set_keymap("v", "H", "b", opts)
vim.api.nvim_set_keymap("v", "L", "w", opts)
