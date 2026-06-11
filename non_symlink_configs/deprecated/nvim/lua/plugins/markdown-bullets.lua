return {
    {
        'dkarter/bullets.vim',
        ft = { 'markdown', 'text', 'gitcommit' },
        init = function()
        -- Enable mapping for Enter key to auto-increment lists
        vim.g.bullets_set_mappings = 1
        
        -- Enable nested list structures
        vim.g.bullets_nested_checkboxes = 1
        end
    }
}