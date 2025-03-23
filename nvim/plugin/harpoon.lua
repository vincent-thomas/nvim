local harpoon = require('harpoon')
harpoon:setup()

vim.keymap.set('n', 'gh', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set('n', 'ga', function()
  harpoon:list():add()
end)

vim.keymap.set('n', 'gA', function()
  harpoon:list().prepend()
end)

vim.keymap.set('n', "'f", function()
  harpoon:list():select(1)
end)

vim.keymap.set('n', "'d", function()
  harpoon:list():select(2)
end)

vim.keymap.set('n', "'s", function()
  harpoon:list():select(3)
end)

vim.keymap.set('n', "'a", function()
  harpoon:list():select(4)
end)

vim.keymap.set('n', '*f', function()
  harpoon:list():replace_at(1)
end)

vim.keymap.set('n', '*d', function()
  harpoon:list():replace_at(2)
end)

vim.keymap.set('n', '*s', function()
  harpoon:list():replace_at(3)
end)

vim.keymap.set('n', '*a', function()
  harpoon:list():replace_at(4)
end)
